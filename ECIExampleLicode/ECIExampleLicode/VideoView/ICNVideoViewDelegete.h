//
//  ICNVideoView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/24.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ICNVideoViewDelegete <NSObject>

- (UIView *)getVideoView;

- (NSString *)getStreamId;

@end
