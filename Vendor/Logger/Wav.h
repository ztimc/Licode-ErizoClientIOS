//
//  Wav.h
//  AudioUnitTest
//
//  Created by ztimc on 2018/3/13.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wav : NSObject

- (void)createFile:(NSString *)name;
- (void)writeFile:(UInt8 *)data :(NSUInteger)length;
- (NSData *)readFile:(NSUInteger)length;
- (void)closeFile;
@end
