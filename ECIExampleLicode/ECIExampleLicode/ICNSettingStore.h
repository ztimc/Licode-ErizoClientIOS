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
                         audioBitrate:(nullable NSNumber *)audioBitrate
                         videoBitrate:(nullable NSNumber *)videoBitrate;

@property(nonatomic) NSString *videoResolution;


- (nullable NSNumber *)maxAudioBitrate;

- (void)setMaxAudioBitrate:(nullable NSNumber *)value;

- (nullable NSNumber *)maxVideoBitrate;

- (void)setMaxVideoBitrate:(nullable NSNumber *)value;

@end
