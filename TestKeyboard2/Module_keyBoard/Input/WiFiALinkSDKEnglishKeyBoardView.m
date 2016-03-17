//
//  WiFiALinkSDKEnglishKeyBoardView.m
//  AutoNavi
//
//  2014-9-25 Wang Weiyang
//
//

#import "WiFiALinkSDKEnglishKeyBoardView.h"

@interface WiFiALinkSDKEnglishKeyBoardView ()
{
    float       ALWiFiKeyBoardbasisWidth;
    float       ALWiFiKeyBoardbasisHeight;
    /** shift按钮 */
    UIButton*   shiftBtn;
    /** 大写状态 */
    BOOL        uppercase;
}
@end

@implementation WiFiALinkSDKEnglishKeyBoardView

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
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"q" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"w" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"e" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"r" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"t" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"y" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"u" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"i" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"o" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"p" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"a" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"s" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"d" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"f" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"g" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"h" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"j" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"k" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"l" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    deleteBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"DELE" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(deleteButtonPressed:)];
    [self addSubview:deleteBtn];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"z" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"x" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"c" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"v" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"b" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"n" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"m" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
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
    shiftBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"SHIFT" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(shiftButtonPressed:)];
    [self addSubview:shiftBtn];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@" " frame:CGRectMake(x, y, w * 4.0, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w * 4.0;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"?#123" frame:CGRectMake(x, y, w * 2.0, h) enable:YES target:self action:@selector(changeNumberKeyboardButtonPressed:)]];
    x += w * 2.0;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"English..." frame:CGRectMake(x, y, w * 3.0, h) enable:YES target:self action:@selector(selectKeyboardButtonPressed:)]];
}

/**
 * 字符按钮事件，如果大写状态在，那么字符要以大写输入，如果是空格，则不影响
 */
- (IBAction)charButtonPressed:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
    {
        NSString* title = btn.currentTitle;
        if (uppercase && !(title != nil && [title isEqualToString:@" "]))
        {
            title = [title uppercaseString];
            [shiftBtn setImage:[UIImage imageNamed:@"ALbtn_icn_uppercase.png"] forState:UIControlStateNormal];
            uppercase = NO;
        }
        [self.delegate insertText:title];
        [self renewButtonStatus];
    }
}

/** 
 * shift按钮事件，用于变换图标及设置大写状态
 */
- (IBAction)shiftButtonPressed:(id)sender
{
    if (uppercase)
    {
        [shiftBtn setImage:[UIImage imageNamed:@"ALbtn_icn_uppercase.png"] forState:UIControlStateNormal];
        uppercase = NO;
    }
    else
    {
        [shiftBtn setImage:[UIImage imageNamed:@"ALbtn_icn_uppercase_2.png"] forState:UIControlStateNormal];
        uppercase = YES;
    }
}

- (void)dealloc
{
    SAFE_ARC_SUPER_DEALLOC();
}

@end
