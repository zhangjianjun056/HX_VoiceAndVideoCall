//
//  FZCallController.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZCallController.h"
#import "FZTopView.h"
#import "FZActionView.h"
#import "FZHelper.h"



@interface FZCallController ()<FZActionViewDelegate>

@property (nonatomic, strong) FZTopView *topView;
@property (nonatomic, strong) FZActionView *actionView;
@property (nonatomic, strong) EMCallSession *callSession;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeLength;
@end

@implementation FZCallController

- (instancetype)initWithCallSession:(EMCallSession *)callSession
{
    self = [super init];
    if (self) {
        self.callSession = callSession;
    }
    return self;
}

- (FZTopView *)topView
{
    if (!_topView) {
        _topView = [[FZTopView alloc] init];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        _topView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (FZActionView *)actionView
{
    if (!_actionView) {
        _actionView = [[FZActionView alloc] init];
        _actionView.acDelegate = self;
        _actionView.translatesAutoresizingMaskIntoConstraints = NO;
        _actionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_actionView];
    }
    return _actionView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSubviews];
    [self layoutUI];
}

- (void)setupSubviews
{
    
    self.view.backgroundColor = [UIColor colorWithRed:62/255.0 green:92/255.0 blue:120/255.0 alpha:1.0];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-((CGRectGetMaxY(self.view.frame)*1)/3));
    }];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)layoutUI
{
    self.topView.remoteNameLabel.text = _callSession.remoteName;
    self.topView.timeLabel.hidden = YES;
    self.topView.statusLabel.text = @"正在拨号中……";
    switch (self.callSession.type)
    {
            case EMCallTypeVoice:
            {
                self.topView.showInfoButton.hidden = YES;
                self.actionView.switchCameraButton.hidden = YES;
                if (self.callSession.isCaller) {
                    
                    self.actionView.answerButton.hidden = YES;
                    [self.actionView remakeRejectButtonLayout];
                }
            }
                break;
            case EMCallTypeVideo:
            {
                self.actionView.speakerOutButton.hidden = YES;
                if (self.callSession.isCaller) {
                    
                    self.actionView.answerButton.hidden = YES;
                    [self.actionView remakeRejectButtonLayout];
                }
                [self setupLocalVideoView];
            }
                break;
            default:
                break;
    }
}

#pragma mark - 处理视频图像
- (void)setupLocalVideoView
{
    FLog(@"---setupLocalVideoView")
    self.callSession.localVideoView = [[EMCallLocalView alloc] init];
    self.callSession.localVideoView.scaleMode = EMCallViewScaleModeAspectFit;
    [self.view addSubview:self.callSession.localVideoView];
    [self.view bringSubviewToFront:self.callSession.localVideoView];
    [self.callSession.localVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-20);
        CGFloat width = 80;
        CGFloat boundsWidth = self.view.bounds.size.width;
        CGFloat boundsHeight = self.view.bounds.size.height;
        CGFloat height = boundsHeight * (80 / boundsWidth);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
}

- (void)setupRemoteVideoView
{
    FLog(@"---setupRemoteVideoView")
    self.callSession.remoteVideoView = [[EMCallRemoteView alloc] init];
    self.callSession.remoteVideoView.scaleMode = EMCallViewScaleModeAspectFill;
    [self.view addSubview:self.callSession.remoteVideoView];
    [self.view sendSubviewToBack:self.callSession.remoteVideoView];
    [self.callSession.remoteVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - Call State Changed

- (void)changeToConnectedState
{
    self.topView.statusLabel.text = @"等待对方接听"; //! 连接建立完成
}

- (void)changeToAnsweredState
{
    self.topView.statusLabel.hidden = YES;
    self.topView.timeLabel.hidden = NO;
    [self _startTimer];
    self.actionView.answerButton.hidden = YES;
    [self.actionView remakeRejectButtonLayout];
    [self setupRemoteVideoView];
    
}

#pragma mark - Timer
- (void)_startTimer
{
    self.timeLength = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCallingTime) userInfo:nil repeats:YES];
}

- (void)_stopTimer
{
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateCallingTime
{
    self.timeLength += 1;
    int hour = self.timeLength / 3600;
    int m = (self.timeLength - hour * 3600) / 60;
    int s = self.timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        self.topView.timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        self.topView.timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        self.topView.timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
    
    FLog(@"-----%f-----%f",self.callSession.remoteVideoResolution.width,self.callSession.remoteVideoResolution.height);
}


#pragma mark - FZActionViewDelegate
//! 外音按钮的点击事件
- (void)view:(FZActionView *)actionView speakerOutAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (sender.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil]; //! 扬声器模式
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil]; //! 听筒模式
    }
    [audioSession setActive:YES error:nil];
}


//!MARK:- 静音按钮的点击事件
- (void)view:(FZActionView *)actionView muteAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self.callSession pauseVoice]; //! 暂停
    } else {
        
        [self.callSession resumeVoice]; //! 恢复
    }
}


//!MARK:- 相机切换的点击事件
- (void)view:(FZActionView *)actionView switchCaremaAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        
        [self.callSession switchCameraPosition:NO];
    } else {
        [self.callSession switchCameraPosition:YES];
    }
}


//!MARK:- 拒绝按钮的点击事件
- (void)view:(FZActionView *)actionView rejectCallAction:(UIButton *)sender
{
    [self _stopTimer];
    if (self.callSession.isCaller) {
        
        [[FZHelper shareHelper] hangupCall:EMCallEndReasonNoResponse];
    } else {
        
        [[FZHelper shareHelper] hangupCall:EMCallEndReasonDecline];
    }
}


//!MARK:- 接听按钮的点击事件
- (void)view:(FZActionView *)actionView answerCallAction:(UIButton *)sender
{
    [[FZHelper shareHelper] answerIncomingCall:self.callSession.callId];
}



- (void)clearData
{
    [self _stopTimer];
    self.callSession.remoteVideoView.hidden = YES;
    self.callSession.remoteVideoView = nil;
    self.callSession = nil;
}

@end
