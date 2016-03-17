//
//  UIView+Utility.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-16.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

- (UIView *)findFirstResponder
{
    //利用递归查找firstResponder，如果自身就是，则返回，如果不是，则查找SubView
    if (self.isFirstResponder)
    {
        return self;
    }
    for (UIView* subView in self.subviews)
    {
        UIView* firstResponder = [subView findFirstResponder];
        if (firstResponder != nil)
        {
            return firstResponder;
        }
    }
    return nil;
}

+ (UIView *)findFirstResponderInApplication{
    //在Windows中查找firstResponder
    NSArray* windows = [[UIApplication sharedApplication] windows];
    if ([windows count]<2)
    {
        return nil;
    }

    for (long j = [windows count] - 1; j >= 0; j--)
    {
        UIWindow* window = [windows objectAtIndex:j];
        UIView* firstResponder = [window findFirstResponder];
        if (firstResponder != nil)
        {
            return firstResponder;
        }
    }
    return nil;
}

@end
