//
//  FZActionView.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZActionView;
@protocol FZActionViewDelegate <NSObject>

@optional


//! 外音按钮的点击事件
- (void)view:(FZActionView *)actionView speakerOutAction:(UIButton *)sender;
//!MARK:- 相机切换的点击事件
- (void)view:(FZActionView *)actionView switchCaremaAction:(UIButton *)sender;
//!MARK:- 静音按钮的点击事件
- (void)view:(FZActionView *)actionView muteAction:(UIButton *)sender;
//!MARK:- 拒绝按钮的点击事件
- (void)view:(FZActionView *)actionView rejectCallAction:(UIButton *)sender;
//!MARK:- 接听按钮的点击事件
- (void)view:(FZActionView *)actionView answerCallAction:(UIButton *)sender;

@end

@interface FZActionView : UIView

@property (nonatomic, strong) UIButton *speakerOutButton; //! 外音按钮
@property (nonatomic, strong) UIButton *switchCameraButton; //! 相机按钮
@property (nonatomic, strong) UIButton *muteButton; //! 静音按钮
@property (nonatomic, strong) UIButton *rejectButton; //! 拒绝按钮
@property (nonatomic, strong) UIButton *answerButton; //! 接听按钮

@property (nonatomic, weak) id<FZActionViewDelegate>acDelegate;

- (void)remakeRejectButtonLayout;

@end
