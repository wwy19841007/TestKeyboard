//
//  UITextField+Utility.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-29.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import "UITextField+Utility.h"

@implementation UITextField (Utility)

- (NSInteger) currentPosition{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    
    return [self offsetFromPosition:beginning toPosition:selectionStart];
}

- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
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
