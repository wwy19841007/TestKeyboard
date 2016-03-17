//
//  JTHandWritePadView.h
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 1/28/15.
//  Copyright (c) 2015 autonavi\wang.weiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JTHandWritePadViewProtocol;
@protocol JTDrawingTool;

@interface JTHandWritePadView : UIView
{
    NSTimer* timer_;
}

@property (nonatomic, assign) id<JTHandWritePadViewProtocol> delegate;

// public properties
@property (nonatomic, assign) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

@property (assign) BOOL bIsHwrRecoging; //识别是否已经开始
@property (assign) BOOL bIsHwrLineBegin; //是否已经开始绘制笔迹
@property (nonatomic, copy) NSMutableArray *strokeArray;



// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (strong, nonatomic) CALayer * layerWaiting;

- (void) showWaitImage:(id)param;
- (void) hideWaitImage:(id)param;

- (void) startTimer;
- (void) stopTimer;
- (void) TimerEx;

- (void) viewRootviewWillDismiss;

//进行识别
- (void) doHwrRecog:(id)param;

- (BOOL) isInPointView:(CGPoint)point;

/**
 * 手写板是否有笔迹
 */
@property BOOL hasMarks;

/**
 * 清理手写板内容
 */
- (void)clearHandWritePad;

@end

@protocol JTHandWritePadViewProtocol <NSObject>

@optional
- (void)drawingView:(JTHandWritePadView *)view willBeginDrawUsingTool:(id<JTDrawingTool>)tool;
- (void)drawingView:(JTHandWritePadView *)view didEndDrawUsingTool:(id<JTDrawingTool>)tool;
- (bool) hwrEngineRecog:(NSMutableArray*)ponitArray;

@end

@interface JTHWRWordPoint : NSObject

@property (assign) NSInteger locationX;
@property (assign) NSInteger locationY;

- (id)initWithCGPoint:(CGPoint)point;

@end