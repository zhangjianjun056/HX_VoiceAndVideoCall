//
//  FZCallController.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FZCallController : UIViewController

- (instancetype)initWithCallSession:(EMCallSession *)callSession;

- (void)changeToConnectedState;
- (void)changeToAnsweredState;
- (void)clearData;


@end
