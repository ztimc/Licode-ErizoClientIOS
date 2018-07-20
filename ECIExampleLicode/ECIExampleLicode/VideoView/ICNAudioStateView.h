//
//  ICNAudioStateView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/18.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICNSurroundButton.h"


@interface ICNAudioStateView : UIView


- (instancetype)initWithButton:(ICNSurroundButton *)button
                         frame:(CGRect)frame;

- (void)setAudioEnable:(BOOL)enable;

@end
