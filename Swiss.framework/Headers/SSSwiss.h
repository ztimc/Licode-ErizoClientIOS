//
//  SSSwiss.h
//  Swiss
//
//  Created by ztimc on 2018/2/28.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSFormat.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kSwissDidConnectNotification;

FOUNDATION_EXPORT NSString *const kSwissDidDisconnectNotification;

FOUNDATION_EXPORT NSString *const kSwissMultipleDeviceErrorNotification;

@interface SSSwiss : NSObject

+ (SSSwiss *)sharedInstance;

- (void)initialize;


/**
 开始录制制定格式音频

 @param audioBlock 音频数据回调
 @param format 声道数，采样率
 */
- (void)startRecord:(nullable void (^)(UInt8 * pcm,UInt32 length))audioBlock :(SSFormat *)format;

/**
 开始录制音频

 @param audioBlock 回调block
 */
- (void)startRecord:(nullable void (^)(UInt8 * pcm,UInt32 length))audioBlock;

/**
 停止录制
 */
- (void)stopRecord;

/**
 AGC(自动增益) 开关

 @param enable YES 打开 NO 关闭
 */
- (void)setAGC:(BOOL)enable;

/**
 ANS(噪声抑制)

 @param level 0-3
 */
- (void)setANS:(UInt8)level;

/**
 设置监听音量(从耳机听到麦克的声音)

 @param value 0-100
 */
- (void)setMonitor:(UInt8)value;

/**
 设置混响大小
 
 @param value 0-100
 */
- (void)setReverberaion:(UInt8)value;

/**
 设置混音

 @param enable YES  打开 NO 关闭
 */
- (void)setMusicMix:(BOOL)enable;

/**
 响指检查开关
 注意目前只能在 录制|播放 音乐的过程中生效,
 后续会改动

 @param enable YES 打开 NO 关闭
 */
- (void)setFinger:(BOOL)enable;

/**
 去人声开关
 注意目前只能在 录制|播放 音乐的过程中生效,
 后续会改动
 @param enable YES 开启去人声 NO 关闭去人声
 */
- (void)setDevocal:(BOOL)enable;

/**
 是否有设备连接

 @return YES 有设备连接 NO 没有设备连接
 */
- (BOOL)hasDevice;

NS_ASSUME_NONNULL_END

@end
