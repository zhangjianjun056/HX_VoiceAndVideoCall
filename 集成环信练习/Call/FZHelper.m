//
//  FZHelper.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZHelper.h"
#import "FZCallController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JJSound.h"
#import <UserNotifications/UserNotifications.h>


@interface FZHelper()<EMClientDelegate, EMCallManagerDelegate, EMCallBuilderDelegate>

@property (nonatomic, strong) EMCallSession *currentSession;
@property (nonatomic, strong) FZCallController *callController;
@property (nonatomic, strong) NSTimer *callTimer;
//! 震动和响铃
@property(nonatomic,strong) JJSound *jjSound;


@end

static FZHelper *helper = nil;

@implementation FZHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[FZHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self _unRegisterCallNotifications];
        [self _registerCallNotifications];
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        options.videoResolution = EMCallVideoResolution640_480;
        options.isFixedVideoResolution = YES;
        [[EMClient sharedClient].callManager setCallOptions:options];
        
    }
    return self;
}

- (void)_unRegisterCallNotifications
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
}

- (void)_registerCallNotifications
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark -  make call

- (void)makeCall:(NSString *)remote callType:(EMCallType)callType
{
    if (remote.length <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient].callManager startCall:callType remoteName:remote ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
        if (!aError) {
            
            weakSelf.currentSession = aCallSession;
            weakSelf.callController = [[FZCallController alloc] initWithCallSession:weakSelf.currentSession];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:weakSelf.callController animated:YES completion:nil];
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"呼叫失败" message:aError.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

#pragma mark - Timer
// 设置超时时间，超时结束呼叫
- (void)startCallTimer
{
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(timeToCancelCall) userInfo:nil repeats:NO];
}

- (void)stopCallTimer
{
    if (self.callTimer == nil) {
        return;
    }
    [self.callTimer invalidate];
    self.callTimer = nil;
}
- (void)timeToCancelCall
{
    [self hangupCall:EMCallEndReasonNoResponse];
}

- (void)hangupCall:(EMCallEndReason)aReason
{
    [self stopCallTimer];
    if (self.currentSession) {
        
        [[EMClient sharedClient].callManager endCall:self.currentSession.callId reason:aReason];
    }
    self.currentSession = nil;
    [self clearCallData];
}

- (void)clearCallData
{
    [self stopCallTimer];
    [self.callController clearData];
    [self.callController dismissViewControllerAnimated:YES completion:nil];
    self.callController = nil;
    
    //! 停止响铃和震动
    [_jjSound stopMusicAndShock];
}

- (void)answerIncomingCall:(NSString *)callId
{
    if (!self.currentSession || ![self.currentSession.callId isEqualToString:callId]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:weakSelf.currentSession.callId];
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hangupCall:EMCallEndReasonFailed];
            });
        }
    });
}

#pragma mark - EMCallManagerDelegate
- (void)callDidReceive:(EMCallSession *)aSession
{
    if (!aSession || aSession.callId.length <= 0) {
        return;
    }
    
    //! 程序在后台时，接收到语音或视频时，进行本地推送和响铃
    //! 本地推送
    UILocalNotification *notify = [[UILocalNotification alloc]init];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notify.fireDate = fireDate;
    notify.timeZone = [NSTimeZone defaultTimeZone]; //时区,默认的时区就是手机系统对应的时区
    notify.soundName = UILocalNotificationDefaultSoundName;
    notify.applicationIconBadgeNumber = 1;
    
    NSString *stype =nil; //通知内容
    if (aSession.type == EMCallTypeVoice) {
        stype = @"实时语音";
    }
    else if (aSession.type == EMCallTypeVideo){
        stype = @"视频通话";
    }
    NSString *notifyStr = [NSString stringWithFormat:@"%@向您发起%@",aSession.remoteName,stype];
    notify.alertBody = notifyStr;
    
    // ios8后，需要添加注册,才能得到授权
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    });
    
    
    // 判断是否正在通话，正在通话时收到请求，直接拒绝请求。
    if (self.currentSession && self.currentSession.status != EMCallSessionStatusDisconnected) {
        
        [[EMClient sharedClient].callManager endCall:aSession.callId reason:EMCallEndReasonBusy];
        [_jjSound stopMusicAndShock]; //! 停止震动和响铃
    }
    
    self.currentSession = aSession;
    self.callController = [[FZCallController alloc] initWithCallSession:self.currentSession];
    [self startCallTimer];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.callController animated:YES completion:^{
        
        //! 震动和响铃
        _jjSound = [[JJSound alloc] init];
        [_jjSound playMusicAndShock];
        
        
    }];
}



- (void)callDidConnect:(EMCallSession *)aSession
{
    if (self.callController) {
        
        [self.callController changeToConnectedState];
    }
}

- (void)callDidAccept:(EMCallSession *)aSession
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        
        [self stopCallTimer];
        [self.callController changeToAnsweredState];
        
        //! 停止震动和响铃
        [_jjSound stopMusicAndShock];
    }
}

- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        
        [self stopCallTimer];
        self.currentSession = nil;
        [self clearCallData];
        
        //! 提示框
        if (aReason == EMCallEndReasonHangup) return [self tip:@"对方挂断"];
        if (aReason == EMCallEndReasonNoResponse) return [self tip:@"对方没有响应"];
        if (aReason == EMCallEndReasonDecline) return [self tip:@"对方拒接"];
        if (aReason == EMCallEndReasonBusy) return [self tip:@"对方占线"];
        if (aReason == EMCallEndReasonFailed) return [self tip:@"失败"];
        if (aReason == EMCallEndReasonUnsupported) return [self tip:@"功能不支持"];
        if (aReason == EMCallEndReasonRemoteOffline) return [self tip:@"对方不在线"];
    }
    
    //! 停止震动和响铃
    [_jjSound stopMusicAndShock];
}



- (void)callRemoteOffline:(NSString *)aRemoteName
{
    
}

- (void)callStateDidChange:(EMCallSession *)aSession type:(EMCallStreamingStatus)aType
{
    
}



//!MARK:- EMClientDelegate

//!MARK:- 当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice {
    [self tip:@"当前账号在其他设备上登录"];
}

//!MARK:- 提示框
- (void)tip:(NSString *)tipTitle {
    
    [JJMBProgressHUD showHUDAddToView:[UIApplication sharedApplication].keyWindow.rootViewController.view contentText:tipTitle completation:nil];
}






@end
