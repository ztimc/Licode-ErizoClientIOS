//
//  ICNConferenceVideo.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ECStream.h>

@protocol ICNConferenceVideo <NSObject>

- (void)showBigStyle;

- (void)showSmallStyle;

- (UIView *)getView;

- (ECStream *)getStream;

- (BOOL)isLocal;

- (BOOL)enableVideo;

@end
