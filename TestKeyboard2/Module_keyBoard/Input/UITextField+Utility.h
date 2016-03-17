//
//  UITextField+Utility.h
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-29.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Utility)

- (NSInteger) currentPosition;
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
- (void) moveCursorToLeft;
- (void) moveCursorToRight;

@end
