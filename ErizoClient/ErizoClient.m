//
//  ErizoClientIOS
//
//  Copyright (c) 2015 Alvaro Gil (zevarito@gmail.com).
//
//  MIT License, see LICENSE file for details.
//

@import WebRTC;
#import "ErizoClient.h"
#import "rtc/ECClient.h"

@implementation ErizoClient

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
#ifdef DEBUG
        RTCSetMinDebugLogLevel(RTCLoggingSeverityError);
#endif
        RTCInitializeSSL();
        [ECClient setPreferredVideoCodec:@"H264"];
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
