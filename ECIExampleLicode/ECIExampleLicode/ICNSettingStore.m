//
//  ICNSettingStore.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/28.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSettingStore.h"

static NSString *const kVideoResolutionKey = @"rtc_video_resolution_key";
static NSString *const kAudioBitrateKey = @"rtc_audio_max_bitrate_key";
static NSString *const kVideoBitrateKey = @"rtc_video_max_bitrate_key";


@interface ICNSettingStore() {
    NSUserDefaults *_storage;
}

@end

@implementation ICNSettingStore

+ (void)setDefaultsForVideoResolution:(NSString *)videoResolution
                              audioBitrate:(nullable NSNumber *)audioBitrate
                              videoBitrate:(nullable NSNumber *)videoBitrate{
    NSMutableDictionary<NSString *, id> *defaultsDictionary = [[NSMutableDictionary alloc] init];
    
    if(videoResolution){
        defaultsDictionary[kVideoResolutionKey] = videoResolution;
    }
    
    if(audioBitrate){
        defaultsDictionary[kAudioBitrateKey] = audioBitrate;
    }
    
    if(videoBitrate){
        defaultsDictionary[kVideoBitrateKey] = videoBitrate;
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

- (nullable NSNumber *)maxAudioBitrate{
    return [self.storage objectForKey:kAudioBitrateKey];
}

- (void)setMaxAudioBitrate:(nullable NSNumber *)value{
    [self.storage setObject:value forKey:kAudioBitrateKey];
    [self.storage synchronize];
}

- (nullable NSNumber *)maxVideoBitrate{
     return [self.storage objectForKey:kVideoBitrateKey];
}

- (void)setMaxVideoBitrate:(nullable NSNumber *)value{
    [self.storage setObject:value forKey:kVideoBitrateKey];
    [self.storage synchronize];
}


@end
