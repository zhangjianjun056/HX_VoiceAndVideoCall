//
//  FZTopView.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZTopView.h"

@implementation FZTopView

#pragma mark - getters

- (UILabel *)remoteNameLabel
{
    if (!_remoteNameLabel) {
        
        _remoteNameLabel = [[UILabel alloc] init];
        _remoteNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _remoteNameLabel.backgroundColor = [UIColor clearColor];
        _remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        _remoteNameLabel.textColor = [UIColor whiteColor];
        _remoteNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _remoteNameLabel.text = @"RemoteName";
        [self addSubview:_remoteNameLabel];
    }
    return _remoteNameLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:17];
        _statusLabel.text = @"拨号中……";
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:30];
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)showInfoButton
{
    if (!_showInfoButton) {
        
        _showInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_showInfoButton setImage:[UIImage imageNamed:@"Button_Stats"] forState:UIControlStateNormal];
        [_showInfoButton setImage:[UIImage imageNamed:@"Button_Stats disabled"] forState:UIControlStateDisabled];
        [_showInfoButton addTarget:self action:@selector(showInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showInfoButton];
    }
    return _showInfoButton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    [self.remoteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(30);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.showInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.remoteNameLabel.mas_top);
        make.width.height.equalTo(@40);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.remoteNameLabel.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.remoteNameLabel.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
}

#pragma mark - Actions
- (void)showInfoButtonClick
{
    FLog(@"---showInfoButtonClick")
}


@end
