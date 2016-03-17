//
//  JTHandWritePadView.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 1/28/15.
//  Copyright (c) 2015 autonavi\wang.weiyang. All rights reserved.
//

#import "JTHandWritePadView.h"
#import "JTDrawLineTools.h"
#import "ARCMacros.h"

#import <QuartzCore/QuartzCore.h>


#define kDefaultLineColor       [UIColor whiteColor]
#define kDefaultLineWidth       4.0f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0

//进行识别
void * doHwrRecog(void *userParam);

@interface JTHandWritePadView ()
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) id<JTDrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;
@end

@implementation JTHandWritePadView
@synthesize  layerWaiting;
@synthesize delegate;
@synthesize bIsHwrRecoging;
@synthesize bIsHwrLineBegin;
@synthesize strokeArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        layerWaiting = [[CALayer alloc] init];
        [self.layer addSublayer:layerWaiting];
        [self configure];
        bIsHwrRecoging = NO;
        bIsHwrLineBegin = NO;
        
        self.hasMarks = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    // init the private arrays
    self.pathArray = [NSMutableArray array];
    strokeArray = [[NSMutableArray alloc] init];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ALbtn_input_handelwritePanel.png"]];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
    [self.currentTool draw];
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
//        if (self.image){
//            SAFE_ARC_RELEASE(self.image);
//        }
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<JTDrawingTool> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
#pragma mark waite image
- (void) showWaitImage:(id)param
{
    layerWaiting.bounds = CGRectMake(0, 0, 30, 30);
    layerWaiting.position = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2 );
    
    UIImage *image = [UIImage imageNamed:@"loading_sinovoice"];
    layerWaiting.contents = (id)image.CGImage;
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 60];//顺时针转60圈
    rotationAnimation.duration = 60.0f;//30秒
    
    [layerWaiting addAnimation:rotationAnimation forKey:@"rotateAnimation"];
}
- (void) hideWaitImage:(id)param
{
    bIsHwrRecoging = NO;
    layerWaiting.contents = nil;
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (bIsHwrRecoging) {//正在识别过程中不响应笔迹
        return;
    }
    self.hasMarks = YES;
    bIsHwrLineBegin = YES;
    
    [self stopTimer];
    // init the bezier path
    self.currentTool = SAFE_ARC_AUTORELEASE([JTDrawingPenTool new]);
    self.currentTool.lineWidth = self.lineWidth;
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineAlpha = self.lineAlpha;
    [self.pathArray addObject:self.currentTool];
    
    // add the first touch
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.currentTool setInitialPoint:point];
    [strokeArray addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc]initWithCGPoint:point])];
    //NSLog(@"[%d   %d]",(int)point.x,(int)point.y);
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((bIsHwrRecoging) || (!bIsHwrLineBegin)){//正在识别过程中,或者识别结束但是没有开始绘制笔迹不响应笔迹
        return;
    }
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    
    if (([self isInPointView:previousLocation]) && ([self isInPointView:currentLocation])){//前一个点在绘图区域当前点在绘图区域
        // NSLog(@"[%d   %d]",(int)currentLocation.x,(int)currentLocation.y);
        [strokeArray addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc]initWithCGPoint:currentLocation])];
    }else if ((![self isInPointView:previousLocation]) && ([self isInPointView:currentLocation])) {//前一个点不在绘图区域当前点在绘图区域
        //NSLog(@"[%d   %d]",(int)currentLocation.x,(int)currentLocation.y);
        [strokeArray addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc]initWithCGPoint:currentLocation])];
    }else if (([self isInPointView:previousLocation]) && (![self isInPointView:currentLocation])) {//前一个点在绘图区域当前点不在绘图区域
        CGPoint endPoint;
        endPoint.x = -1;
        endPoint.y = 0;
        [strokeArray addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc]initWithCGPoint:endPoint])];
        //NSLog(@"[%d   %d]",(int)endPoint.x,(int)endPoint.y);
    }else{//前一个点不在绘图区域当前点不在绘图区域
    }
    
    [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
    
#if PARTIAL_REDRAW
    // calculate the dirty rect
    CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 0.5;
    CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 0.5;
    CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 0.5;
    CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 0.5;
    [self setNeedsDisplayInRect:CGRectMake(minX, minY, (maxX - minX), (maxY - minY))];
#else
    [self setNeedsDisplay];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((bIsHwrRecoging) || (!bIsHwrLineBegin)){//正在识别过程中,或者识别结束但是没有开始绘制笔迹不响应笔迹
        return;
    }
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    // update the image
    [self updateCacheImage:NO];
    
    // clear the current tool
    self.currentTool = nil;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    
    if ([self isInPointView:currentLocation]) {//如果点在绘图区域内就增加 -1,0
        CGPoint endPoint;
        endPoint.x = -1;
        endPoint.y = 0;
        [strokeArray addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc]initWithCGPoint:endPoint])];
        // NSLog(@"[%d   %d]",(int)endPoint.x,(int)endPoint.y);
    }
    
    //    // call the delegate
    //    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
    //        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
    //    }
    
    [self startTimer];
}
- (BOOL) isInPointView:(CGPoint)point
{
    if ((point.x < 0) || (point.y < 0) || (point.x > self.bounds.size.width ) || (point.y > self.bounds.size.height)) {
        return NO;
    }
    return YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

- (void) startTimer
{
    [self stopTimer];
    timer_ = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(TimerEx)
                                            userInfo:nil
                                             repeats:NO];
}

- (void) stopTimer
{
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

- (void) TimerEx
{
    bIsHwrRecoging = YES; //设置成正在识别状态
    bIsHwrLineBegin = NO;
    
    [self stopTimer];
//    [self clearHandWritePad];
    
    if ([strokeArray count] == 0) {
        bIsHwrRecoging = NO;
        return;
    }
    
    [self performSelectorOnMainThread:@selector(showWaitImage:) withObject:nil waitUntilDone:NO];
    
//    CGPoint endPoint;
//    endPoint.x = -1;
//    endPoint.y = -1;
//    [strokeArray addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc] initWithCGPoint:endPoint])];
    [NSThread detachNewThreadSelector:@selector(doHwrRecog:) toTarget:self withObject:nil];
}

- (void) viewRootviewWillDismiss
{
    if (!bIsHwrRecoging) {
        [strokeArray removeAllObjects];
        [self clearHandWritePad];
    }
}

- (void) doHwrRecog:(id)param
{
//    if ([strokeArray count] != 0) {
//        NSMutableArray *tempStroke = [NSMutableArray arrayWithArray:strokeArray];
//        [strokeArray removeAllObjects];
//        [delegate hwrEngineRecog:tempStroke];
//        [self performSelectorOnMainThread:@selector(hideWaitImage:) withObject:nil waitUntilDone:NO];
//    }
    NSMutableArray *tempStroke = [NSMutableArray arrayWithArray:strokeArray];
    CGPoint endPoint;
    endPoint.x = -1;
    endPoint.y = -1;
    [tempStroke addObject:SAFE_ARC_AUTORELEASE([[JTHWRWordPoint alloc] initWithCGPoint:endPoint])];
    [delegate hwrEngineRecog:tempStroke];
    bIsHwrRecoging = NO;
}

#pragma mark - Actions

- (void)clearHandWritePad
{
    if ([strokeArray count] != 0) {
        [strokeArray removeAllObjects];
    }
    //[self.bufferArray removeAllObjects];
    self.hasMarks = NO;
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}

//#if !ACE_HAS_ARC

- (void)dealloc
{
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
    delegate = nil;
    if (layerWaiting) {
        SAFE_ARC_RELEASE(layerWaiting);
        layerWaiting = nil;
    }
    if (self.pathArray) {
        SAFE_ARC_RELEASE(self.pathArray);
        self.pathArray = nil;
    }
    self.currentTool = nil;
//    if (self.image) {
//        SAFE_ARC_RELEASE(self.image);
//        self.image = nil;
//    }
    if (strokeArray) {
        SAFE_ARC_RELEASE(strokeArray);
        strokeArray = nil;
    }
    SAFE_ARC_SUPER_DEALLOC();
}

//#endif

@end

@implementation JTHWRWordPoint
@synthesize locationX;
@synthesize locationY;
- (id)initWithCGPoint:(CGPoint)point
{
    if (self = [super init]) {
        locationX = point.x;
        locationY = point.y;
    }
    return self;
}
@end
