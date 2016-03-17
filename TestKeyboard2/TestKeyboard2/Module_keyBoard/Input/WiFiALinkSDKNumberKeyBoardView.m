//
//  WiFiALinkSDKNumberKeyBoardView.m
//  AutoNavi
//
//  2014-9-25 Wang Weiyang
//
//

#import "WiFiALinkSDKNumberKeyBoardView.h"

@interface WiFiALinkSDKNumberKeyBoardView ()
{
    float ALWiFiKeyBoardbasisWidth;
    float ALWiFiKeyBoardbasisHeight;
}
@end

@implementation WiFiALinkSDKNumberKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ALWiFiKeyBoardbasisWidth = frame.size.width/3;
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
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"1" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"2" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"3" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"4" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"5" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"6" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"7" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"8" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"9" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"0" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    UIButton* moveLeftBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"LEFTMOBILE" frame:CGRectMake(x, y, w / 2.0, h) enable:YES target:self action:@selector(moveCursorToLeftButtonPressed:)];
    moveLeftBtn.tag = 101;
    [self addSubview:moveLeftBtn];
    x += w / 2.0;
    UIButton* moveRightBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"RIGHTMOBILE" frame:CGRectMake(x, y, w/ 2.0, h) enable:YES target:self action:@selector(moveCursorToRightButtonPressed:)];
    moveRightBtn.tag = 102;
    [self addSubview:moveRightBtn];
    x += w / 2.0;
    deleteBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"DELE" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(deleteButtonPressed:)];
    [self addSubview:deleteBtn];
}

- (void)dealloc
{
    SAFE_ARC_SUPER_DEALLOC();
}

@end
