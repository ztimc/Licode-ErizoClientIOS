//
//  ICNSettingModel.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/28.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNSettingModel : NSObject



/**
 当前能用的分辨率

 @return 分辨率的字符串数组
 */
- (NSArray<NSString *> *)availableVideoResolutions;

/**
 获取当前存储的视频分辨率

 @return 返回字符串,默认640x480
 */
- (NSString *)currentVideoResolutionSettingFromStore;
- (int)currentVideoResolutionWidthFromStore;
- (int)currentVideoResolutionHeightFromStore;


/**
 存储分辨率

 @param resolution 分辨率
 @return 是否存储成功
 */
- (BOOL)storeVideoResolutionSetting:(NSString *)resolution;


/**
 获取当前最大的音频bitrate

 @return 最大音频bitrate值
 */
- (nullable NSNumber *)currentMaxAudioBitrateSettingFromStore;


/**
 存储bitrate

 @param bitrate
 */
- (void)storeMaxAudioBitrateSetting:(nullable NSNumber *)bitrate;

/**
 获取当前最大的视频bitrate
 
 @return 最大视频bitrate值
 */
- (nullable NSNumber *)currentMaxVideoBitrateSettingFromStore;


/**
 存储bitrate
 
 @param bitrate
 */
- (void)storeMaxVideoBitrateSetting:(nullable NSNumber *)bitrate;


- (nullable NSString *)currentServerSettingFromStore;


- (void)storeServerSetting:(nullable NSString *)bitrate;


- (NSArray<NSString *> *)defaultServers;

@end
