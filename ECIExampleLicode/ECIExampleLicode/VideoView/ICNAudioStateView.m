//
//  ICNAudioStateView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/18.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNAudioStateView.h"

@implementation ICNAudioStateView {
    UIImageView *stateView;
    ICNSurroundButton *avatar;
}

- (instancetype)initWithButton:(ICNSurroundButton *)button
                         frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if(self){
        avatar = button;
        stateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Aduio-Mute-Icon"]];
        [self addSubview:avatar];
        [self addSubview:stateView];
    }
    return self;
}


- (void)setAudioEnable:(BOOL)enable {
    
    stateView.hidden = enable;

}

- (void)layoutSubviews {
    stateView.mh_x = self.bounds.size.width
                     -stateView.mh_width
                     - 6;
    
    stateView.mh_y = avatar.imageView.mh_height
                     - stateView.mh_height
                     + 4;
}

@end
