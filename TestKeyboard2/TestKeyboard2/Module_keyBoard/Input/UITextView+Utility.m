//
//  UITextView+Utility.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-29.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import "UITextView+Utility.h"

@implementation UITextView (Utility)

- (NSInteger) currentPosition{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    
    return [self offsetFromPosition:beginning toPosition:selectionStart];
}

- (void) moveCursorToLeft{
    NSInteger position = self.currentPosition;
    if (position > 0) {
        position--;
    }
    [self setSelectedRange:NSMakeRange(position, 0)];
}

- (void) moveCursorToRight{
    NSInteger position = self.currentPosition;
    if (position < self.text.length) {
        position++;
    }
    [self setSelectedRange:NSMakeRange(position, 0)];
}

@end
