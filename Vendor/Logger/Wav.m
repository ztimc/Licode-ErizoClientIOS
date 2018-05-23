//
//  Wav.m
//  AudioUnitTest
//
//  Created by ztimc on 2018/3/13.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import "Wav.h"

@interface Wav(){
    NSString *docPath;
    NSString *filePath;
    
    NSFileHandle *fileHandle;
}
@end
@implementation Wav

- (void)createFile:(NSString *)name{
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [docPath stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
}
- (void)writeFile:(UInt8 *)data :(NSUInteger)length{
    NSData *nsData = [NSData dataWithBytes:data length:length];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:nsData];
}

- (NSData *)readFile:(NSUInteger)length{
    return [fileHandle readDataOfLength:length];
}

- (void)closeFile{
    if(fileHandle){
        [fileHandle closeFile];
    }
}

@end
