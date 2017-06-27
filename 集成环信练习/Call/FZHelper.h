//
//  FZHelper.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"


@class FZMenuViewController;
@interface FZHelper : NSObject

+ (instancetype)shareHelper;
- (void)makeCall:(NSString *)remote callType:(EMCallType)callType;

//! 挂断电话
- (void)hangupCall:(EMCallEndReason)aReason;

- (void)answerIncomingCall:(NSString *)callId;
@end
