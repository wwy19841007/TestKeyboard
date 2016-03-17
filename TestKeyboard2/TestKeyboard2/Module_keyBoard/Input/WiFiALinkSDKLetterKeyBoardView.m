//
//  WiFiALinkSDKLetterKeyBoardView.m
//  AutoNavi
//
//  2014-9-25 Wang Weiyang
//
//

#import "WiFiALinkSDKLetterKeyBoardView.h"


@interface WiFiALinkSDKLetterKeyBoardView ()
{
    float ALWiFiKeyBoardbasisWidth;
    float ALWiFiKeyBoardbasisHeight;
}
@end

@implementation WiFiALinkSDKLetterKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ALWiFiKeyBoardbasisWidth = frame.size.width/10;
        ALWiFiKeyBoardbasisHeight = 65/2.0;
        [self initKeyboardLayout];
    }
    return self;
}

/**
 * 键盘面板初始化类，填充各种按钮和控件，定义控件的位置
 */
- (void)initKeyboardLayout
{
    CGFloat x, y, w, h;
    y = self.frame.size.height - 130;
    w = ALWiFiKeyBoardbasisWidth;
    h = ALWiFiKeyBoardbasisHeight;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"Q" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"W" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"E" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"R" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"T" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"Y" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"U" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"I" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"O" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"P" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"A" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"S" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"D" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"F" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"G" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"H" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"J" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"K" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"L" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    deleteBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"DELE" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(deleteButtonPressed:)];
    [self addSubview:deleteBtn];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"Z" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"X" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"C" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"V" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"B" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"N" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"M" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    UIButton* moveLeftBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"LEFTMOBILE" frame:CGRectMake(x, y, w * 1.5, h) enable:YES target:self action:@selector(moveCursorToLeftButtonPressed:)];
    moveLeftBtn.tag = 101;
    [self addSubview:moveLeftBtn];
    x += w * 1.5;
    UIButton* moveRightBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"RIGHTMOBILE" frame:CGRectMake(x, y, w * 1.5, h) enable:YES target:self action:@selector(moveCursorToRightButtonPressed:)];
    moveRightBtn.tag = 102;
    [self addSubview:moveRightBtn];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@" " frame:CGRectMake(x, y, w * 5.0, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w * 5.0;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"?#123" frame:CGRectMake(x, y, w * 2.0, h) enable:NO]];
    x += w * 2.0;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"首拼..." frame:CGRectMake(x, y, w * 3.0, h) enable:YES target:self action:@selector(selectKeyboardButtonPressed:)]];
}

- (void)dealloc
{
    SAFE_ARC_SUPER_DEALLOC();
}

@end
