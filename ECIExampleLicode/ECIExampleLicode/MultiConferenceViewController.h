//
//  MultiConferenceViewController.h
//  ECIExampleLicode
//
//  Created by Alvaro Gil on 9/4/15.
//  Copyright (c) 2015 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebRTC;
#import "ECRoom.h"

typedef enum _ChatMode{
    Audio = 0,
    Video = 1
} ChatMode;


@interface MultiConferenceViewController : UIViewController <ECRoomDelegate>


- (instancetype) initWithMode:(ChatMode)mode
                     roomName:(NSString*)roomName
                     userName:(NSString*)userNmae;

@end

