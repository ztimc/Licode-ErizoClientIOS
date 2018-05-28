//
//  ICNSettingStore.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/28.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSettingStore.h"

static NSString *const kVideoResolutionKey = @"rtc_video_resolution_key";
static NSString *const kBitrateKey = @"rtc_max_bitrate_key";


@interface ICNSettingStore() {
    NSUserDefaults *_storage;
}

@end

@implementation ICNSettingStore

+ (void)setDefaultsForVideoResolution:(NSString *)videoResolution
                              bitrate:(nullable NSNumber *)bitrate{
    NSMutableDictionary<NSString *, id> *defaultsDictionary = [[NSMutableDictionary alloc] init];
    
    if(videoResolution){
        defaultsDictionary[kVideoResolutionKey] = videoResolution;
    }
    
    if(bitrate){
        defaultsDictionary[kBitrateKey] = bitrate;
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
}

- (NSUserDefaults *)storage {
    if (!_storage) {
        _storage = [NSUserDefaults standardUserDefaults];
    }
    return _storage;
}

- (NSString *)videoResolution {
    return [self.storage objectForKey:kVideoResolutionKey];
}

- (void)setVideoResolution:(NSString *)resolution {
    [self.storage setObject:resolution forKey:kVideoResolutionKey];
    [self.storage synchronize];
}

- (nullable NSNumber *)maxBitrate {
    return [self.storage objectForKey:kBitrateKey];
}

- (void)setMaxBitrate:(nullable NSNumber *)value {
    [self.storage setObject:value forKey:kBitrateKey];
    [self.storage synchronize];
}

@end
