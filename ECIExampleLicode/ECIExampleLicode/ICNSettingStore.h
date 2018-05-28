//
//  ICNSettingStore.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/28.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNSettingStore : NSObject

+ (void)setDefaultsForVideoResolution:(NSString *)videoResolution
                              bitrate:(nullable NSNumber *)bitrate;

@property(nonatomic) NSString *videoResolution;

/**
 * Returns current max bitrate number stored in the store.
 */
- (nullable NSNumber *)maxBitrate;

/**
 * Stores the provided value as maximum bitrate setting.
 * @param value the number to be stored
 */
- (void)setMaxBitrate:(nullable NSNumber *)value;

@end
