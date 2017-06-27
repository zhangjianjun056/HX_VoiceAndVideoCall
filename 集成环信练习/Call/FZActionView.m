//
//  FZActionView.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZActionView.h"

#define kFUNCBUTTON_HORIZ_PADD 100
#define kFUNCBUTTON_WIDTH_HEIGHT 40
#define kFUNCBUTTON_VETI_PADD 20
#define kACTIONBUTTON_HORIZ_PADD 60
#define kACTIONBUTTON_VETI_PADD 35
#define kACTIONBUTTON_WIDTH_HEIGHT 65

@implementation FZActionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _layoutButtons];
    }
    return self;
}

#pragma mark - getters

- (UIButton *)speakerOutButton
{
    if (!_speakerOutButton) {
        
        _speakerOutButton = [self setupButtonWithImage:@"Button_Speaker" selectImage:@"Button_Speaker active" selector:@selector(speakerOut:)];
        [self addSubview:_speakerOutButton];
    }
    return _speakerOutButton;
}



- (UIButton *)switchCameraButton
{
    if (!_switchCameraButton) {
        
        _switchCameraButton = [self setupButtonWithImage:@"Button_Camera switch" selectImage:@"Button_Camera switch active" selector:@selector(caremaSwitched:)];
        [self addSubview:_switchCameraButton];
    }
    return _switchCameraButton;
}

- (UIButton *)muteButton
{
    if (!_muteButton) {
        
        _muteButton = [self setupButtonWithImage:@"Button_Mute" selectImage:@"Button_Mute active" selector:@selector(voiceMuted:)];
        [self addSubview:_muteButton];
    }
    return _muteButton;
}

- (UIButton *)rejectButton
{
    if (!_rejectButton) {
        
        _rejectButton = [self setupButtonWithImage:@"Button_End" selectImage:@"Button_End" selector:@selector(rejectCall:)];
        [self addSubview:_rejectButton];
    }
    return _rejectButton;
}

- (UIButton *)answerButton
{
    if (!_answerButton) {
        
        _answerButton = [self setupButtonWithImage:@"Button_Answer" selectImage:@"Button_Answer" selector:@selector(answerCall:)];
        [self addSubview:_answerButton];
    }
    return _answerButton;
}

- (UIButton *)setupButtonWithImage:(NSString *)image selectImage:(NSString *)selectImage selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    if (image.length > 0) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (selectImage.length > 0) {
        [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    if (selector) {
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

#pragma mark - layout buttons

- (void)_layoutButtons
{
    [self.speakerOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(kFUNCBUTTON_HORIZ_PADD);
        make.top.equalTo(self.mas_top).offset(kFUNCBUTTON_VETI_PADD);
        make.width.height.equalTo(@(kFUNCBUTTON_WIDTH_HEIGHT));
    }];
    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(kFUNCBUTTON_HORIZ_PADD);
        make.top.equalTo(self.mas_top).offset(kFUNCBUTTON_VETI_PADD);
        make.width.height.equalTo(@(kFUNCBUTTON_WIDTH_HEIGHT));
    }];
    [self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(kFUNCBUTTON_VETI_PADD);
        make.right.equalTo(self.mas_right).offset(-kFUNCBUTTON_HORIZ_PADD);
        make.width.height.equalTo(@(kFUNCBUTTON_WIDTH_HEIGHT));
    }];
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(kACTIONBUTTON_HORIZ_PADD);
        make.bottom.equalTo(self.mas_bottom).offset(-kACTIONBUTTON_VETI_PADD);
        make.width.height.equalTo(@(kACTIONBUTTON_WIDTH_HEIGHT));
    }];
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-kACTIONBUTTON_HORIZ_PADD);
        make.bottom.equalTo(self.mas_bottom).offset(-kACTIONBUTTON_VETI_PADD);
        make.width.height.equalTo(@(kACTIONBUTTON_WIDTH_HEIGHT));
    }];
}

- (void)remakeRejectButtonLayout
{
    [self.rejectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-kACTIONBUTTON_VETI_PADD);
        make.width.height.equalTo(@(kACTIONBUTTON_WIDTH_HEIGHT));
    }];
}

#pragma mark - Actions
//! 外音按钮的点击事件
- (void)speakerOut:(UIButton *)sender
{
    FLog(@"---speakerOut")
    if (self.acDelegate && [self.acDelegate respondsToSelector:@selector(view:speakerOutAction:)]) {
        
        [self.acDelegate view:self speakerOutAction:sender];
    }
}



//!MARK:- 相机切换的点击事件
- (void)caremaSwitched:(UIButton *)sender
{
    FLog(@"---caremaSwitched")
    if (self.acDelegate && [self.acDelegate respondsToSelector:@selector(view:switchCaremaAction:)]) {
        
        [self.acDelegate view:self switchCaremaAction:sender];
    }
}


//!MARK:- 静音按钮的点击事件
- (void)voiceMuted:(UIButton *)sender
{
    FLog(@"---voiceMuted")
    if (self.acDelegate && [self.acDelegate respondsToSelector:@selector(view:muteAction:)]) {
        
        [self.acDelegate view:self muteAction:sender];
    }
}


//!MARK:- 拒绝按钮的点击事件
- (void)rejectCall:(UIButton *)sender
{
    FLog(@"---rejectCall")
    if (self.acDelegate && [self.acDelegate respondsToSelector:@selector(view:rejectCallAction:)]) {
        
        [self.acDelegate view:self rejectCallAction:sender];
    }
}


//!MARK:- 接听按钮的点击事件
- (void)answerCall:(UIButton *)sender
{
    FLog(@"---answerCall")
    if (self.acDelegate && [self.acDelegate respondsToSelector:@selector(view:answerCallAction:)]) {
        
        [self.acDelegate view:self answerCallAction:sender];
    }
}

@end
