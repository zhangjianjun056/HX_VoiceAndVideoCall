//
//  JJMBProgressHUD.h
//  常用工具类的封装
//
//  Created by 一介布衣 on 2017/5/8.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
// 文本框的提示显示

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^JJMBProgressHUDCompletationBlock)(void);

@interface JJMBProgressHUD : NSObject


+ (void)showHUDAddToView:(UIView *)view contentText:(NSString *)text completation:(JJMBProgressHUDCompletationBlock)jjMBProgressHUDCompletation;


@end
