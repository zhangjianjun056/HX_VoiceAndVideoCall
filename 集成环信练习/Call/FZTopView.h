//
//  FZTopView.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZTopView : UIView

//! 通信另一方的用户名
@property (nonatomic, strong) UILabel *remoteNameLabel;
//! 通信状态
@property (nonatomic, strong) UILabel *statusLabel;
//! 通信时间
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *showInfoButton;
@end
