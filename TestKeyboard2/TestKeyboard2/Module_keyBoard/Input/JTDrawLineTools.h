
#import <UIKit/UIKit.h>


//#if __has_feature(objc_arc)
//#define ACE_HAS_ARC 1
//#define ACE_RETAIN(exp) (exp)
//#define ACE_RELEASE(exp)
//#define ACE_AUTORELEASE(exp) (exp)
//#else
//#define ACE_HAS_ARC 0
//#define ACE_RETAIN(exp) [(exp) retain]
//#define ACE_RELEASE(exp) [(exp) release]
//#define ACE_AUTORELEASE(exp) [(exp) autorelease]
//#endif


@protocol JTDrawingTool <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

@end

#pragma mark -

@interface JTDrawingPenTool : UIBezierPath<JTDrawingTool>

@end

