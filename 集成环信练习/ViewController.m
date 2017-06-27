//
//  ViewController.m
//  集成环信练习
//
//  Created by 一介布衣 on 2017/5/22.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
//

/**
 说明：
 * 测试账号1：test1    密码：123
 * 测试账号2：test2    密码：123
 */


#import "ViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "JJMBProgressHUD.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiverUserNameTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


//! 点击了登录按钮
- (IBAction)clickedLoginButton:(UIButton *)sender {
    
    [[EMClient sharedClient] loginWithUsername:_userNameTextField.text
                                      password:_passwordTextField.text
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        if (!aError) {
                                            NSLog(@"登录成功");
                                            [JJMBProgressHUD showHUDAddToView:self.view contentText:@"登录成功" completation:nil];
                                            
                                        } else {
                                            NSLog(@"登录失败");
                                            [JJMBProgressHUD showHUDAddToView:self.view contentText:@"登录失败" completation:nil];
                                        }
                                    }];
}


//!MARK:- 点击了通话按钮
- (IBAction)clickedCallButton:(UIButton *)sender {
    
    if (![self isRemoteValid:_receiverUserNameTextField.text]) {
        return;
    }
    
    [[FZHelper shareHelper] makeCall:_receiverUserNameTextField.text callType:EMCallTypeVoice];
}


//! 点击了视频按钮
- (IBAction)clickedVideoButton:(UIButton *)sender {
    
    if (![self isRemoteValid:_receiverUserNameTextField.text]) {
        return;
    }
    [[FZHelper shareHelper] makeCall:_receiverUserNameTextField.text callType:EMCallTypeVideo];
}



//!MARK:- 判断通信的另一方的用户名是否为nil或者是否为当前用户
- (BOOL)isRemoteValid:(NSString *)remote
{
    if (remote.length <= 0 || [remote isEqualToString:[[EMClient sharedClient] currentUsername]]) {
        
        UIAlertController *alrtC = [UIAlertController alertControllerWithTitle:@"通信的另一方的用户名\n不能为nil并且不能为当前用户" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alrtC addAction:action];
        [self presentViewController:alrtC animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
