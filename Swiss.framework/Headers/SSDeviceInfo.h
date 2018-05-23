//
//  SSDeviceInfo.h
//  Swiss
//
//  Created by ztimc on 2018/3/1.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _DEVICE_NAME{
    //alaya 经典版
    ALAYA_SILVER = 0x0,
    //alaya 专业版
    ALAYA_PRO = 0x1,
    //SMIC
    S_MIC = 0x10,
    //K歌麦克
    K_MIC = 0x20,
    //录耳包
    K_HEADSET = 0x30,
    //麦克类
    M_MIKE = 0x40,
    //未知设备或者没有设备
    UNKNOWN_DEVICE = 0xFF
} DEVICE_NAME;

@interface SSDeviceInfo : NSObject

//获取协议波版本
- (NSNumber *)getProtocol;
//获取固件版本
- (NSNumber *)getFirmware;
//获取硬件版本
- (NSString *)getHardware;
//获取制造商
- (NSString *)getManufacture;
//获取许可证
- (NSString *)getLicensed;
//获取采样率
- (NSUInteger)getSampleRate;
//获取声道数
- (NSUInteger)getChannel;
//获取比特率
- (NSUInteger)getBitRate;
//获取监听值
- (NSUInteger)getMonitor;
//获取混响值
- (NSUInteger)getReverberration;
//获取ANS值
- (NSUInteger)getANS;
//获取AGC状态
- (BOOL)getAGC;
//获取混音状态
- (BOOL)getMusicMix;
//获取响指开关状态
- (BOOL)getFinger;


@end
