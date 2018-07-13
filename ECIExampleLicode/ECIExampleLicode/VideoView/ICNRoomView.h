//
//  ICNRoomView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/13.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _CameraType{
    front = 0,
    back = 1
}CameraType;

@protocol RoomViewDelegete <NSObject>

- (void)onSwitchCamera:(CameraType)cameraType;

- (void)onMutuCtlClick:(BOOL)mutu;

- (void)onCameraCtlClick:(BOOL)close;

- (void)onHangUpClick;

- (void)onSpeakerCtlClick:(BOOL)speaker;

@end

@interface ICNRoomView : UIView

@property(nonatomic,strong) id<RoomViewDelegete> delegete;




@end
