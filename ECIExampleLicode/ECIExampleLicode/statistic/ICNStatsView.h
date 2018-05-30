//
//  ICNStatsView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/30.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICNStatsView : UIView

- (void)setStats:(NSString *)mediaType
            kbps:(long)kbps;

@end
