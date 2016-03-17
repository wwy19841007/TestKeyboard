//
//  UIView+Utility.h
//
//  Created by autonavi\wang.weiyang on 14-9-16.
//
//  2014-9-25 Wang Weiyang
//  对UIView的扩展，用于查找FirstResponder
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)
/**
 * 查找View及SubView中的firstResponder
 */
- (UIView *)findFirstResponder;

/**
 * 类方法，查找整个应用中的firstResponder
 */
+ (UIView *)findFirstResponderInApplication;

@end
