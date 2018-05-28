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
 获取当前最大的bitrate

 @return 最大bitrate值
 */
- (nullable NSNumber *)currentMaxBitrateSettingFromStore;


/**
 存储bitrate

 @param bitrate
 */
- (void)storeMaxBitrateSetting:(nullable NSNumber *)bitrate;

@end
