//
//  ICNEditText.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/12.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ICNEditText : UIView

typedef void(^OnTextFieldChangeCallback)(NSString *text);

- (instancetype)initWithIcon:(UIImage *)image
                        text:(NSString *)text
                keyboardType:(UIKeyboardType)keyboardType
                       frame:(CGRect)frame;

- (void)setOnTextChange:(OnTextFieldChangeCallback)callback;

@end
