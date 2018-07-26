//
//  ICNConferenceAudioView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECStream.h"

@interface ICNConferenceAudioView : UIView

@property(nonatomic, strong, readonly)ECStream *stream;

- (instancetype)initWithStream:(ECStream *)stream
                         frame:(CGRect)frame;

- (void)showMute:(BOOL)enable;

@end
