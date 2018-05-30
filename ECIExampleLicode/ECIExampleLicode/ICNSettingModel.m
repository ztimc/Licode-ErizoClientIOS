//
//  ICNSettingModel.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/28.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSettingModel.h"
#import "ICNSettingStore.h"
#import "WebRTC/RTCCameraVideoCapturer.h"
#import "WebRTC/RTCMediaConstraints.h"
#import "WebRTC/RTCVideoCodecFactory.h"

@interface ICNSettingModel(){
    ICNSettingStore *_settingsStore;
}

@end

@implementation ICNSettingModel


+ (NSArray<NSString *> *)remainResolutions{
    static NSArray<NSString *> *_titles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _titles = @[@"192x144",
                    @"320x240",
                    @"480x360",
                    @"640x480",
                    @"1280x720"];
    });
    return _titles;
}

- (NSArray<NSString *> *)availableVideoResolutions {
    
    NSMutableSet<NSArray<NSNumber *> *> *resolutions =
    [[NSMutableSet<NSArray<NSNumber *> *> alloc] init];
    for (AVCaptureDevice *device in [RTCCameraVideoCapturer captureDevices]) {
        for (AVCaptureDeviceFormat *format in
             [RTCCameraVideoCapturer supportedFormatsForDevice:device]) {
            CMVideoDimensions resolution =
            CMVideoFormatDescriptionGetDimensions(format.formatDescription);
            NSArray<NSNumber *> *resolutionObject = @[ @(resolution.width), @(resolution.height) ];
            [resolutions addObject:resolutionObject];
        }
    }
    
    NSArray<NSArray<NSNumber *> *> *sortedResolutions =
    [[resolutions allObjects] sortedArrayUsingComparator:^NSComparisonResult(
                                                                             NSArray<NSNumber *> *obj1, NSArray<NSNumber *> *obj2) {
        return obj1.firstObject > obj2.firstObject;
    }];
    
    NSMutableArray<NSString *> *resolutionStrings = [[NSMutableArray<NSString *> alloc] init];
    for (NSArray<NSNumber *> *resolution in sortedResolutions) {
        NSString *resolutionString =
        [NSString stringWithFormat:@"%@x%@", resolution.firstObject, resolution.lastObject];
        [resolutionStrings addObject:resolutionString];
    }
    
    return [self filterResolution:[resolutionStrings copy]];
}

- (NSArray<NSString *> *)filterResolution:(NSMutableArray<NSString *> *)resolutions{
    
    NSArray<NSString *> *remains = [ICNSettingModel remainResolutions];
    
    BOOL isContains = true;
    for(NSString *resolution in remains){
        isContains |= [resolutions containsObject:resolution];
    }
    if(isContains){
        return remains;
    }
    
    return resolutions;
}

- (ICNSettingStore *)settingsStore {
    if (!_settingsStore) {
        _settingsStore = [[ICNSettingStore alloc] init];
        [self registerStoreDefaults];
    }
    return _settingsStore;
}

- (NSString *)currentVideoResolutionSettingFromStore {
    [self registerStoreDefaults];
    return [[self settingsStore] videoResolution];
}

- (BOOL)storeVideoResolutionSetting:(NSString *)resolution {
    if (![[self availableVideoResolutions] containsObject:resolution]) {
        return NO;
    }
    [[self settingsStore] setVideoResolution:resolution];
    return YES;
}

- (nullable NSNumber *)currentMaxAudioBitrateSettingFromStore{
    [self registerStoreDefaults];
    return [[self settingsStore] maxAudioBitrate];
}

- (void)storeMaxAudioBitrateSetting:(nullable NSNumber *)bitrate{
    [[self settingsStore] setMaxAudioBitrate:bitrate];
}

- (nullable NSNumber *)currentMaxVideoBitrateSettingFromStore{
    [self registerStoreDefaults];
    return [[self settingsStore] maxVideoBitrate];
}

- (void)storeMaxVideoBitrateSetting:(nullable NSNumber *)bitrate{
    [[self settingsStore] setMaxVideoBitrate:bitrate];
}

- (int)currentVideoResolutionWidthFromStore {
    NSString *resolution = [self currentVideoResolutionSettingFromStore];
    
    return [self videoResolutionComponentAtIndex:0 inString:resolution];
}

- (int)currentVideoResolutionHeightFromStore {
    NSString *resolution = [self currentVideoResolutionSettingFromStore];
    return [self videoResolutionComponentAtIndex:1 inString:resolution];
}


- (int)videoResolutionComponentAtIndex:(int)index inString:(NSString *)resolution {
    if (index != 0 && index != 1) {
        return 0;
    }
    NSArray<NSString *> *components = [resolution componentsSeparatedByString:@"x"];
    if (components.count != 2) {
        return 0;
    }
    return components[index].intValue;
}


- (NSString *)defaultVideoResolutionSetting {
    return @"480x360";
}

- (void)registerStoreDefaults {
    [ICNSettingStore setDefaultsForVideoResolution:[self defaultVideoResolutionSetting] audioBitrate:nil videoBitrate:nil];
}

@end
