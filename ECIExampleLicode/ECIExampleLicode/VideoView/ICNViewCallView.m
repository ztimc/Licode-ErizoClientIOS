//
//  ICNViewCallView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/23.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNViewCallView.h"

static CGFloat vHeight = 160.0;

@interface ICNCameraPreviewView : RTCCameraPreviewView<ICNVideoView>

@end

@implementation ICNCameraPreviewView

- (UIView *)getVideoView {
    return self;
}

- (NSString *)getStreamId {
    return @"local";
}

@end

@interface ICNPlayView : ECPlayerView<ICNVideoView>
@end

@implementation ICNPlayView

- (UIView *)getVideoView {
    return self;
}

- (NSString *)getStreamId {
    return self.stream.streamId;
}

@end


@implementation ICNViewCallView

@synthesize captureSession = _captureSession;


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        ICNCameraPreviewView *preView = [[ICNCameraPreviewView alloc] initWithFrame:CGRectZero];
        _videoScrollView = [[UIScrollView alloc] initWithFrame: CGRectZero];
        _videoViews = [[NSMutableArray<ICNVideoView> alloc] init];
        _current = preView;
        _currentPosition = 0;
        
        [self addSubview:preView];
        [self addSubview:_videoScrollView];
        
        
    }
    return self;
}


- (void)setCaptureSession:(AVCaptureSession *)captureSession {
    _captureSession = captureSession;
    for(int i = 0; i < self.subviews.count; i++) {
        if([self.subviews[i] isKindOfClass:[ICNCameraPreviewView class]]){
            ICNCameraPreviewView *preview = (ICNCameraPreviewView *)self.subviews[i];
            preview.captureSession = _captureSession;
        }
    }
}


- (void)layoutSubviews {
    NSLog(@"fucking");
    CGRect bounds = self.bounds;
    [[_current getVideoView] setFrame:bounds];
    CGRect scrollFrame = CGRectMake(0, bounds.size.height - vHeight, bounds.size.width, vHeight);
    _videoScrollView.contentOffset = CGPointZero;
    _videoScrollView.frame = scrollFrame;
    
   
}

- (CGRect)obtainFrameByIndex:(NSInteger)index {
    CGFloat width = [UIScreen mainScreen].bounds.size.width * (CGFloat)0.27;
    CGFloat height = _videoScrollView.frame.size.height;
    return CGRectMake(6 + (index * (width + 6)), 0,width, height);
}

- (void)calcViewContent {
    CGFloat width = [UIScreen mainScreen].bounds.size.width * (CGFloat)0.27;
    _videoScrollView.contentSize = CGSizeMake((width + 10) * _videoViews.count , vHeight);
}

- (void)watchStream:(ECStream *)stream {
    CGRect frame = [self obtainFrameByIndex:_videoViews.count];
    ICNPlayView *playView = [[ICNPlayView alloc] initWithLiveStream:stream frame:frame];
    playView.videoView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addBorderToView:playView];
    [self addClickAction:playView];
    [_videoScrollView addSubview:playView];
    [_videoViews addObject:playView];
    [self calcViewContent];
}

- (void)removeStreamById:(NSString *)streamId {
    
    if([[_current getStreamId] caseInsensitiveCompare:streamId] == NSOrderedSame){
        for(int i = 0; i < _videoViews.count; i++){
            if([[_videoViews[i] getStreamId] caseInsensitiveCompare:@"local"] == NSOrderedSame){
                UIView *videoView = [_videoViews[i] getVideoView];
                [videoView removeGestureRecognizer:videoView.gestureRecognizers[0]];
                [self swichView:_videoViews[i]];
                break;
            }
        }
    }
    
    for(int i = 0; i < _videoViews.count; i++){
        if([[_videoViews[i] getStreamId] caseInsensitiveCompare:streamId] == NSOrderedSame){
            UIView *view = [_videoViews[i] getVideoView];
            [_videoViews removeObjectAtIndex:i];
            [view removeFromSuperview];
            break;
        }
    }
    
    [self layoutScroll];
    [self calcViewContent];
}

- (void)addClickAction:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchStream:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

- (void)layoutScroll {
    for(int i = 0; i < _videoViews.count; i++){
        UIView *childView = [_videoViews[i] getVideoView];
        childView.frame = [self obtainFrameByIndex:i];
        if([childView isKindOfClass:[ICNPlayView class]]){
            ICNPlayView *playView = (ICNPlayView *)childView;
            CGRect viewFrame = childView.frame;
            viewFrame.origin.x = 0;
            playView.videoView.frame = viewFrame;
        }
    }
}

- (void)switchStream:(id)sender {
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    
    id<ICNVideoView> clickedVideoView = (id<ICNVideoView>)gesture.view;
    [clickedVideoView.getVideoView removeGestureRecognizer:gesture];
    [self swichView:clickedVideoView];
}

- (void)swichView:(id<ICNVideoView>)playView {
    id<ICNVideoView> clickedVideoView = playView;
    UIView *clickedView = [clickedVideoView getVideoView];
    id<ICNVideoView> currentVideoView = _current;
    UIView *currentView = [currentVideoView getVideoView];
    [self addClickAction:currentView];
    
    //remove view
    [_videoViews removeObject:clickedVideoView];
    [clickedView removeFromSuperview];
    [currentView removeFromSuperview];
    //addBorder and remove border
    [[clickedView layer] setBorderWidth:0];
    [self addBorderToView:currentView];
    
    CGRect currentFrame = clickedView.frame;
    if([currentView isKindOfClass:[ICNCameraPreviewView class]]){
        currentView.frame = currentFrame;
    }else{
        ICNPlayView *playView = (ICNPlayView *)currentView;
        playView.frame = currentFrame;
        CGRect videoFrame = currentFrame;
        videoFrame.origin.x = 0;
        playView.videoView.frame = videoFrame;
    }
    
    //set view frame
    CGRect clickedFrame = self.frame;
    
    if([clickedView isKindOfClass:[ICNPlayView class]]){
        ICNPlayView *playView = (ICNPlayView *)clickedView;
        playView.frame = clickedFrame;
        
        playView.videoView.frame = clickedFrame;
    }else{
        clickedView.frame = clickedFrame;
    }
    
    //add view to parent
    _current = clickedVideoView;
    [_videoViews addObject:currentVideoView];
    [_videoScrollView addSubview:currentView];
    [self insertSubview:clickedView belowSubview:_videoScrollView];
}

- (void)addBorderToView:(UIView *) view{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1] CGColor];
}


@end
