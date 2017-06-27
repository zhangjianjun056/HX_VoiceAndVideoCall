//
//  JJMBProgressHUD.m
//  常用工具类的封装
//
//  Created by 一介布衣 on 2017/5/8.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
//

#import "JJMBProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>


@implementation JJMBProgressHUD


/**
 显示提示框：（如：网络错误）

 @param view 要添加到的那个View视图
 @param text 要显示的文本
 @param jjMBProgressHUDCompletation 显示完成后的回调
 */
+ (void)showHUDAddToView:(UIView *)view contentText:(NSString *)text completation:(JJMBProgressHUDCompletationBlock)jjMBProgressHUDCompletation {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 15.0;
    
    hud.completionBlock = ^{
        if (jjMBProgressHUDCompletation) {
            jjMBProgressHUDCompletation();
        }
    };
    [hud hide:YES afterDelay:2.0];
}



@end
