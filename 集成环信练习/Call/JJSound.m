//
//  JJSound.m
//  集成环信练习
//
//  Created by 一介布衣 on 2017/5/25.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
//

#import "JJSound.h"
#import <AudioToolbox/AudioToolbox.h>

@interface JJSound ()

@property(nonatomic,assign) SystemSoundID sound;
//! 停止震动的定时器
@property(nonatomic,strong)NSTimer *vibrationTimer;

@end



@implementation JJSound



//!MARK:- 震动和响铃
- (void)playMusicAndShock {
    // 如果你想震动的提示播放音乐的话就在下面填入你的音乐文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iphone_5s" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &(_sound));
    AudioServicesAddSystemSoundCompletion(_sound, NULL, NULL, soundCompleteCallback, NULL);
    //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(_sound);
    
    //! 初始化计时器  每一秒振动一次
    _vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playkSystemSound) userInfo:nil repeats:YES];
}


//==========后台持续震动和播放铃声的方法============
void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    AudioServicesPlaySystemSound(sound); //! 响铃
}

//!MARK:- 停止铃声和震动
-(void)stopMusicAndShock {
    [_vibrationTimer invalidate];
    //    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(_sound);
    AudioServicesDisposeSystemSoundID(_sound);
}


//振动
- (void)playkSystemSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //    AudioServicesPlaySystemSound(_sound);
}
//============end=================

@end
