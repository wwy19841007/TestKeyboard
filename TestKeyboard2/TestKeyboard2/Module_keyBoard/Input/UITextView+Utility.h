//
//  UITextView+Utility.h
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-29.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Utility)

- (NSInteger) currentPosition;
- (void) moveCursorToLeft;
- (void) moveCursorToRight;

@end
