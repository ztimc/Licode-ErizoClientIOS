//
//  ICNRoomView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/13.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNRoomView.h"
#import "ICNSurroundButton.h"
#import "ECPlayerView.h"
#import <WebRTC/RTCCameraPreviewView.h>
#import <WebRTC/RTCAudioSession.h>
#import "ICNAudioStateView.h"


typedef enum _MediaState{
    AudioMode = 0,
    VideoMode = 1,
}MediaState;


typedef enum _MediaType{
    Audio = 0,
    Video = 1,
}MediaType;

@protocol StreamView
- (ECStream *)getStream;
- (MediaType)getMediaType;
- (UIView *)getView;

@end

@interface AudioView : ICNAudioStateView<StreamView>

@property (nonatomic,strong) ECStream *stream;

- (instancetype)initWithStream:(ECStream *)stream
                        button:(ICNSurroundButton *)button
                         frame:(CGRect)frame;

@end

@implementation AudioView

- (instancetype)initWithStream:(ECStream *)stream
                        button:(ICNSurroundButton *)button
                         frame:(CGRect)frame;{
    self = [super initWithButton:button frame:frame];
    if(self){
        _stream = stream;
    }
    
    return self;
}

- (ECStream *)getStream{
    return _stream;
}
- (MediaType)getMediaType{
    return Audio;
}
- (UIView *)getView{
    return self;
}
@end

@interface VideoView : UIView<StreamView>

@property (nonatomic, strong) ECPlayerView *playView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) ECStream *stream;

- (instancetype)initWithECPlayer:(ECPlayerView*)playView
                            name:(NSString *)name
                          stream:(ECStream *)stream
                           frame:(CGRect)frame;

@end

@implementation VideoView

- (instancetype)initWithECPlayer:(ECPlayerView*)playView
                            name:(NSString *)name
                          stream:(ECStream *)stream
                           frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.stream = stream;
        self.playView = playView;
        self.nameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,frame.size.width - 8, 15)];
        self.nameView.text = name;
        self.nameView.font = [UIFont systemFontOfSize:13];
        self.nameView.textColor = [UIColor whiteColor];
        self.nameView.layer.shadowColor = RGBHexAlpha(0x000000, 0.5).CGColor;
        self.nameView.layer.shadowOpacity = 1.0f;
        self.nameView.layer.shadowOffset = CGSizeMake(1, 1);
        self.nameView.layer.shadowRadius = 0.5F;
        [self addSubview:playView];
        [self addSubview:_nameView];
    }
    return self;
}

- (ECStream *)getStream{
    return _stream;
}

- (MediaType)getMediaType{
    return Video;
}
- (UIView *)getView{
    return self;
}

- (void)layoutSubviews{
    _nameView.mh_centerX = CGRectGetMidX(self.bounds);
    _nameView.mh_x = _nameView.mh_x + 4;
    _nameView.mh_y = self.bounds.size.height
                     - _nameView.mh_height
                     - 4;
}

@end


@interface LocalVideoView : RTCCameraPreviewView<StreamView>

@property (nonatomic, strong) ECStream *stream;
@property (nonatomic, strong) UILabel *nameView;

- (instancetype)initWithStream:(ECStream *)stream
                         frame:(CGRect)frame;

@end

@implementation LocalVideoView


- (instancetype)initWithStream:(ECStream *)stream
                         frame:(CGRect)frame{
    self = [self initWithFrame:frame];
    
    if(self){
        self.stream = stream;
        self.nameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,frame.size.width - 8, 15)];
        self.nameView.text = stream.getAttributes[@"actualName"];
        self.nameView.font = [UIFont systemFontOfSize:13];
        self.nameView.textColor = [UIColor whiteColor];
        self.nameView.layer.shadowColor = RGBHexAlpha(0x000000, 0.5).CGColor;
        self.nameView.layer.shadowOpacity = 1.0f;
        self.nameView.layer.shadowOffset = CGSizeMake(1, 1);
        self.nameView.layer.shadowRadius = 0.5F;
        [self addSubview:_nameView];
    }
    
    return self;
}

- (void)layoutSubviews {
    _nameView.mh_centerX = CGRectGetMidX(self.bounds);
    _nameView.mh_x = _nameView.mh_x + 4;
    _nameView.mh_y = self.bounds.size.height
    - _nameView.mh_height
    - 4;
}

- (ECStream *)getStream{
    return _stream;
}

- (MediaType)getMediaType{
    return Video;
}

- (UIView *)getView{
    return self;
}

@end

@implementation ICNRoomView{
    
    UILabel     *nameText;
    UIButton    *cameraSwichImage;
    UIButton    *hangupImage;
    
    UIImageView *backgroudView;
    UIImageView *backgroudIcon;
    
    ICNSurroundButton *muteCtlImage;
    ICNSurroundButton *cammerCtlImage;
    ICNSurroundButton *speakerCtlImage;
    
    NSMutableArray<ECStream*> *remoteStreams;
    NSMutableArray<id<StreamView>> *remoteAudioViews;
    NSMutableArray<id<StreamView>> *smallVideoViews;
    
    id<StreamView> currentVideo;
    ICNSurroundButton *selfAvater;
    LocalVideoView *localVideo;

    MediaState state;
    ECStream *localStream;
    dispatch_source_t timer;
}


- (instancetype)initWithLocalStream:(ECStream *)stream
                      frame:(CGRect)frame{
    
    localStream = stream;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = localStream.getAttributes[@"actualName"];
         NSString *roomName = localStream.getAttributes[@"roomName"];
        remoteStreams = [[NSMutableArray alloc] init];
        remoteAudioViews = [[NSMutableArray alloc] init];
        smallVideoViews = [[NSMutableArray alloc] init];
        
        localVideo = [[LocalVideoView alloc] initWithFrame:self.bounds];
        currentVideo = localVideo;
        selfAvater = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        backgroudView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroudIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Background-Icon"]];
       
        
        nameText     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 16)];
        
        hangupImage      = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        
        cameraSwichImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        muteCtlImage     = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        cammerCtlImage   = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        speakerCtlImage  = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];;
        
        
        [self setButtonInfo:muteCtlImage
                       text:@"静音"
              selectedImage:[UIImage imageNamed: @"Mic-Mute-Selected-Icon"] normalImage:[UIImage imageNamed: @"Mic-Mute-Normal-Icon"]];
        [self setButtonInfo:cammerCtlImage
                       text:@"摄像头"
              selectedImage:[UIImage imageNamed: @"Camera-Selected-Icon"]
                normalImage:[UIImage imageNamed: @"Camera-Normal-Icon"]];
        [self setButtonInfo:speakerCtlImage
                       text:@"扬声器"
              selectedImage:[UIImage imageNamed: @"Speaker-Selected-Icon"]
                normalImage:[UIImage imageNamed: @"Speaker-Normal-Icon"]];
        
        [self setButtonInfo:selfAvater
                       text:name
              selectedImage:[UIImage imageNamed: @"Avatar-Icon"]
                normalImage:[UIImage imageNamed: @"Avatar-Icon"]];
        
        [backgroudView setImage:[UIImage imageNamed: @"Main-Background"]];
        
        [cameraSwichImage setImage:[UIImage imageNamed: @"Camera-Filp-Icon"] forState:UIControlStateNormal];
        
        [hangupImage setImage:[UIImage imageNamed: @"Hungup-Icon"] forState:UIControlStateNormal];
        
        nameText.font = [UIFont systemFontOfSize:14];
        nameText.layer.shadowColor = RGBHexAlpha(0x000000, 0.5).CGColor;
        nameText.layer.shadowOpacity = 1.0f;
        nameText.layer.shadowOffset = CGSizeMake(1, 1);
        nameText.layer.shadowRadius = 0.5F;
        nameText.textColor = [UIColor whiteColor];
        
        nameText.text = [NSString stringWithFormat:@"房间号:%@", roomName];
        
        [cameraSwichImage addGestureRecognizer:[self createGesture]];
        [muteCtlImage addGestureRecognizer:[self createGesture]];
        [cammerCtlImage addGestureRecognizer:[self createGesture]];
        [hangupImage addGestureRecognizer:[self createGesture]];
        [speakerCtlImage addGestureRecognizer:[self createGesture]];
        
        
        [self addSubview:backgroudView];
        [self addSubview:backgroudIcon];
        [self addSubview:localVideo];
        [self addSubview:selfAvater];
        [self addSubview:nameText];
        [self addSubview:cameraSwichImage];
        [self addSubview:muteCtlImage];
        [self addSubview:cammerCtlImage];
        [self addSubview:speakerCtlImage];
        [self addSubview:hangupImage];
        
        [self checkSate];
        cammerCtlImage.selected = state == Video;
        
      
    }
    return self;
}

- (void)setButtonInfo:(ICNSurroundButton *)button
                 text:(NSString*)text
        selectedImage:(UIImage*)selectedImage
          normalImage:(UIImage*)normalImage {
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:RGBHexAlpha(0x6FD8FF, 1) forState:UIControlStateSelected];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
}


- (void)layoutSubviews {
    NSInteger leftMargin = 10;
    
    nameText.mh_x = leftMargin;
    nameText.mh_y = 18;
    
    cameraSwichImage.mh_x = self.bounds.size.width
                            - 10
                            - cameraSwichImage.bounds.size.width;
    cameraSwichImage.mh_y = 8;
    
    
    muteCtlImage.mh_x = 14;
    muteCtlImage.mh_y = self.bounds.size.height
                        - muteCtlImage.bounds.size.height
                        - 30;
    
    cammerCtlImage.mh_x = muteCtlImage.mh_x
                          + muteCtlImage.mh_width
                          + 14;
    
    cammerCtlImage.mh_y = self.bounds.size.height
                          - muteCtlImage.bounds.size.height
                          - 30;
    
    hangupImage.mh_centerX = self.bounds.size.width / 2;
    hangupImage.mh_y       = self.bounds.size.height
                             - hangupImage.mh_height
                             - 10;
    
    speakerCtlImage.mh_x = self.bounds.size.width
                           - 50
                           - speakerCtlImage.mh_width;
    speakerCtlImage.mh_y = self.bounds.size.height
                           - speakerCtlImage.mh_height
                           - 30;
    
    selfAvater.mh_x = 10;
    selfAvater.mh_y = 45;
    backgroudIcon.mh_centerX = CGRectGetMidX(self.bounds);
    backgroudIcon.mh_y = 180;
    
    
    
    if([currentVideo.getView isKindOfClass:LocalVideoView.class]){
        currentVideo.getView.frame = self.frame;
    }else{
        VideoView *videoView = (VideoView *)currentVideo.getView;
        videoView.playView.frame = self.bounds;
        videoView.playView.videoView.frame = self.bounds;
    }
    
    int index = 1;
    for(int i = 0; i < smallVideoViews.count; i++) {
        UIView *videoView = [smallVideoViews[i] getView];
        if([self streamHasVideo:smallVideoViews[i].getStream]){
            videoView.mh_x = self.bounds.size.width - 12 - videoView.mh_width;
            videoView.mh_y = (self.bounds.size.height - 90)
            - (videoView.mh_height * (index))
            - (index * 12);
        }
    }
    
    for(int i = 0; i < remoteAudioViews.count; i++) {
        UIView *audioView = [remoteAudioViews[i] getView];
        if(audioView != nil){
            audioView.mh_x = 12
            + (audioView.mh_width * (i + 1));
            audioView.mh_y = 45;
        }
    }
    
}

- (void)setCaptureSession:(AVCaptureSession *)captureSession{
    [localVideo setCaptureSession:captureSession];
}

- (void)watchStream:(ECStream *)stream {
    
    [remoteStreams addObject:stream];
    
    NSString *name =stream.getAttributes[@"actualName"];
    CGRect audioFrame= CGRectMake(0, 0, 50, 50);
    ICNSurroundButton *avatar = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    AudioView *audioView = [[AudioView alloc] initWithStream:stream button:avatar frame:audioFrame];
    [self setButtonInfo:avatar text:name selectedImage:[UIImage imageNamed: @"Avatar-Icon"] normalImage:[UIImage imageNamed: @"Avatar-Icon"]];
    [audioView setAudioEnable:YES];
    [remoteAudioViews addObject:audioView];
    [self addSubview:audioView];
    
    
    CGRect videoFrame = CGRectMake(0, 0, 90, 90);
    ECPlayerView *playView = [[ECPlayerView alloc] initWithLiveStream:stream frame:videoFrame];
    RTCMTLVideoView *view = (RTCMTLVideoView *)playView.videoView;
    [view setContentMode:UIViewContentModeScaleAspectFill];
    view.clipsToBounds = YES;
    
    VideoView *videoView = [[VideoView alloc] initWithECPlayer:playView name:name stream:stream frame:videoFrame];
    
    [smallVideoViews addObject:videoView];
    [self addBorderToView:videoView];
    [self addSubview:videoView];
    
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(didVideoClick:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [videoView addGestureRecognizer:tapRecognizer];
    if(state == Audio && [self streamHasVideo:stream]){
        [self swapClickVideoViewToCurrent:videoView];
    }
    
    [self checkSate];
}


- (void)removeStreamById:(NSString *)streamId {
    //移除 streams中
    for(int i = 0; i < remoteStreams.count; i++) {
        if([remoteStreams[i].streamId isEqualToString:streamId]){
            [remoteStreams removeObjectAtIndex:i];
        }
    }
    
    //移除对应关系的AudioView
    for(int i = 0; i < remoteAudioViews.count; i++){
        if([remoteAudioViews[i].getStream.streamId isEqualToString:streamId]){
            [remoteAudioViews[i].getView removeFromSuperview];
            [remoteAudioViews removeObject:remoteAudioViews[i]];
            break;
        }
    }
    
    //先交换位置再移除，不然移除逻辑太复杂
    if([currentVideo.getStream.streamId isEqualToString:streamId]){
        [self swapClickVideoViewToCurrent:localVideo];
    }
    
    //移除对应关系的videoView
    for(int i = 0; i < smallVideoViews.count; i++){
        if([smallVideoViews[i].getStream.streamId isEqualToString:streamId]){
            [smallVideoViews[i].getView removeFromSuperview];
            [smallVideoViews removeObject:smallVideoViews[i]];
            break;
        }
    }
    
    [self checkSate];
}

- (void)notifyRemoteAudioSateChange:(ECStream *)stream
                            ennable:(BOOL)enable{
    NSLog(@"remote stream audio %@ is %d",stream,enable);
    for(int i = 0; i < remoteAudioViews.count; i++){
        AudioView *audioVideo = (AudioView *)remoteAudioViews[i];
        if([[audioVideo getStream].streamId isEqualToString:stream.streamId]){
            [audioVideo setAudioEnable:enable];
            return;
        }
    }
}

- (void)notifyRemoteVideoSateChange:(ECStream *)stream
                            ennable:(BOOL)enable{
    NSLog(@"remote stream video %@ is %d",stream,enable);
    
    for(int i = 0; i < remoteStreams.count; i++) {
        if([remoteStreams[i].streamId isEqualToString:stream.streamId]){
            NSDictionary *dictionary = remoteStreams[i].getAttributes;
            NSMutableDictionary *mutableArray =  [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [mutableArray setValue:@(enable) forKey:@"video"];
            [remoteStreams[i] setAttributes:[NSDictionary dictionaryWithDictionary:mutableArray]];
            break;
        }
    }
    
    if(state == AudioMode && currentVideo == localVideo){
        for (int i = 0; i < smallVideoViews.count; i++) {
            [self swapClickVideoViewToCurrent: smallVideoViews[0]];
        }
    }
    
    [self checkSate];
    [self setNeedsLayout];
}

# pragma mark - private

- (BOOL)streamHasVideo:(ECStream *)stream{
    NSNumber *video = stream.getAttributes[@"video"];
    if(video){
       return video.boolValue;
    }
    return NO;
}

- (void)swapClickVideoViewToCurrent:(id<StreamView>)view{
    
    id<StreamView> currentView = currentVideo;
    id<StreamView> clickView = view;
    
    //1.改变view大小,样式,手势删除，添加手势

    CGRect clickFrame = clickView.getView.frame;
    CGRect currentFrame = currentView.getView.frame;

    if([currentView.getView isKindOfClass:VideoView.class]){
        VideoView *videoView = (VideoView *)currentView.getView;
        [videoView.nameView setHidden:NO];
        videoView.playView.frame = CGRectMake(0, 0, 90, 90);
        videoView.playView.videoView.frame = CGRectMake(0, 0, 90, 90);
    }
    
    if([clickView.getView isKindOfClass:VideoView.class]){
        VideoView *videoView = (VideoView *)clickView.getView;
        [videoView.nameView setHidden:YES];
        videoView.playView.frame = currentFrame;
        videoView.playView.videoView.frame = currentFrame;
    }
    
    clickView.getView.frame = currentFrame;
    currentView.getView.frame = clickFrame;
  
    [self addBorderToView:currentVideo.getView];
    clickView.getView.layer.borderWidth = 0;
    clickView.getView.layer.cornerRadius = 0;
    
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(didVideoClick:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [currentView.getView addGestureRecognizer:tapRecognizer];
    [clickView.getView removeGestureRecognizer:clickView.getView.gestureRecognizers[0]];
    
   
    
    //2.开始交换
    NSUInteger clickSmallIndex = [smallVideoViews indexOfObject:clickView];
    NSUInteger clickViewIndex = [self.subviews indexOfObject:clickView.getView];
    NSUInteger currentViewIndex = [self.subviews indexOfObject:currentVideo.getView];
    
    [smallVideoViews removeObject:clickView];
    currentVideo = clickView;
    [smallVideoViews insertObject:currentView atIndex:clickSmallIndex];
    
    
    [self exchangeSubviewAtIndex:clickViewIndex withSubviewAtIndex:currentViewIndex];

}

- (void)addBorderToView:(UIView *) view{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1] CGColor];
    
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
}

- (UITapGestureRecognizer *)createGesture{
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(didTriple:)];
    tapRecognizer.numberOfTapsRequired = 1;
    return tapRecognizer;
}

- (void)didVideoClick:(UITapGestureRecognizer *)recognizer {
    [self swapClickVideoViewToCurrent:(id<StreamView>)recognizer.view];
}
         
- (void)didTriple:(UITapGestureRecognizer *)recognizer {
    
    if(!_delegete) return;
    
    if(recognizer.view == cameraSwichImage){
        
       [_delegete onSwitchCamera];
        
    }else if(recognizer.view == muteCtlImage){
        
        BOOL selected = !muteCtlImage.isSelected;
        [muteCtlImage setSelected:selected];
        [_delegete onMutuCtlClick:selected];
    }else if(recognizer.view == cammerCtlImage){
        
        BOOL selected = !cammerCtlImage.isSelected;
        [cammerCtlImage setSelected:selected];
        
        [_delegete onCameraCtlClick:selected];
        
        [self checkSate];
        
        if(selected && (currentVideo != localVideo)){
            [self swapClickVideoViewToCurrent:localVideo];
        }
        
        if(!selected && (currentVideo == localVideo) &&state == VideoMode){
            for(int i = 0; i < smallVideoViews.count; i++){
                if([self streamHasVideo: smallVideoViews[i].getStream]){
                    [self swapClickVideoViewToCurrent:smallVideoViews[i]];
                    return;
                }
            }
        }
        
    }else if(recognizer.view == hangupImage){
        
       [_delegete onHangUpClick];
        
    }else if(recognizer.view == speakerCtlImage){
        
        BOOL selected = !speakerCtlImage.selected;
        [speakerCtlImage setSelected:selected];
        [_delegete onSpeakerCtlClick:selected];
        
    }
}

- (void)checkSate {
    BOOL hasVideo = NO;
    for(int i = 0; i < remoteStreams.count; i++){
        hasVideo |= [self streamHasVideo:remoteStreams[i]];
    }
    
    hasVideo |= localStream.mediaStream.videoTracks[0].isEnabled;
    
    if(hasVideo){
        state = VideoMode;
    }else{
        state = AudioMode;
    }
    [self hiddedVideo];
}

- (void)hiddedVideo {
    if(state == AudioMode){
        [currentVideo.getView setHidden:YES];
        for(int i = 0; i < smallVideoViews.count; i++){
            [smallVideoViews[i].getView setHidden:YES];
        }
        [cameraSwichImage setHidden:YES];
    }else{
        if(localStream.mediaStream.videoTracks[0].isEnabled){
            [cameraSwichImage setHidden:NO];
        }else{
            [cameraSwichImage setHidden:YES];
        }
        
        if(currentVideo == localVideo){
            if(localStream.mediaStream.videoTracks[0].isEnabled){
                currentVideo.getView.hidden = NO;
            }else{
                currentVideo.getView.hidden = YES;
            }
        }else{
            if([self streamHasVideo: currentVideo.getStream]){
                currentVideo.getView.hidden = NO;
            }else{
                currentVideo.getView.hidden = YES;
            }
        }
        
        for(int i = 0; i < smallVideoViews.count; i++){
            
            if([smallVideoViews[i].getView isKindOfClass:LocalVideoView.class]){
                if(localStream.mediaStream.videoTracks[0].isEnabled){
                    [smallVideoViews[i].getView setHidden:NO];
                }else{
                    [smallVideoViews[i].getView setHidden:YES];
                }
                continue;
            }
            
            if([self streamHasVideo:smallVideoViews[i].getStream]){
                [smallVideoViews[i].getView setHidden:NO];
            }else{
                [smallVideoViews[i].getView setHidden:YES];
            }
        }
    }
    
}


@end
