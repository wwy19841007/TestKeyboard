//
//  WiFiALinkSDKkeyBoardView.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-15.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import "WiFiALinkSDKkeyBoardView.h"

@interface WiFiALinkSDKkeyBoardView()
{
    //弹出的输入面板选择框及其控件
    UIImageView*    imageView;
    UIButton*       backgroundBtn;
    UIButton*       btnHandWrite;
    UIButton*       Letter;
    UIButton*       pinyin;
    UIButton*       english;
}

@end

@implementation WiFiALinkSDKkeyBoardView

- (id)init{
    self = [super init];
    if (self)
    {
        [self setHidden:YES];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHidden:YES];
    }
    return self;
}

- (IBAction)touchDown:(id)sender
{
    if (((UIButton *)sender).tag == 101)
    {
        if (moveCursorTimer != nil) {
            [moveCursorTimer invalidate];
            moveCursorTimer = nil;
        }
        recognizeMoveCursorLongClickTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startRecognizeLeftLongClick) userInfo:nil repeats:NO];
    }
    if (((UIButton *)sender).tag == 102)
    {
        if (moveCursorTimer != nil) {
            [moveCursorTimer invalidate];
            moveCursorTimer = nil;
        }
        recognizeMoveCursorLongClickTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startRecognizeRightLongClick) userInfo:nil repeats:NO];
    }
}

- (IBAction)touchUp:(id)sender
{
    if (recognizeMoveCursorLongClickTimer != nil) {
        [recognizeMoveCursorLongClickTimer invalidate];
        recognizeMoveCursorLongClickTimer = nil;
    }
    if (moveCursorTimer != nil) {
        [moveCursorTimer invalidate];
        moveCursorTimer = nil;
    }
}

- (void)startRecognizeLeftLongClick
{
    if (recognizeMoveCursorLongClickTimer != nil) {
        [recognizeMoveCursorLongClickTimer invalidate];
        recognizeMoveCursorLongClickTimer = nil;
    }
    if (moveCursorTimer != nil) {
        [moveCursorTimer invalidate];
        moveCursorTimer = nil;
    }
    moveCursorTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moveCursorToLeftButtonPressed:) userInfo:nil repeats:YES];
}

- (void)startRecognizeRightLongClick
{
    if (recognizeMoveCursorLongClickTimer != nil) {
        [recognizeMoveCursorLongClickTimer invalidate];
        recognizeMoveCursorLongClickTimer = nil;
    }
    if (moveCursorTimer != nil) {
        [moveCursorTimer invalidate];
        moveCursorTimer = nil;
    }
    moveCursorTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moveCursorToRightButtonPressed:) userInfo:nil repeats:YES];
}

- (IBAction)moveCursorToLeftButtonPressed:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onCursorMovedLeft:)])
    {
        [self.delegate onCursorMovedLeft:self];
    }
}

- (IBAction)moveCursorToRightButtonPressed:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onCursorMovedRight:)])
    {
        [self.delegate onCursorMovedRight:self];
    }
}

- (void)inKeyboard{
    [self setHidden:NO];
    [self renewButtonStatus];
}

- (void)outKeyboard{
    [self setHidden:YES];
}

+ (CGFloat)getKeyboardHeight{
    return 225;
}

- (IBAction)charButtonPressed:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
    {
        NSString* title = btn.currentTitle;
        [self.delegate insertText:title];
        [self renewButtonStatus];
    }
}

- (IBAction)deleteButtonPressed:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteBackward)])
    {
        [self.delegate deleteBackward];
        [self renewButtonStatus];
    }
}

//- (IBAction)changeKeyboardButtonPressed:(id)sender{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onKeyBoardViewChanged:)])
//    {
//        [self.delegate onKeyBoardViewChanged:self];
//    }
//}

- (IBAction)changeNumberKeyboardButtonPressed:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onNumberKeyBoardViewSelected:)])
    {
        [self.delegate onNumberKeyBoardViewSelected:self];
    }
}

- (IBAction)returnFromNumberKeyboardButtonPressed:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onNumberKeyBoardViewReturned:)])
    {
        [self.delegate onNumberKeyBoardViewReturned:self];
    }
}

- (void)changeKeyBoardFlag:(UIButton *)btn
{
    [self hiddenChooseBtn];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onChangeKeyBoardView:atIndex:)])
    {
        [self.delegate onChangeKeyBoardView:self atIndex:btn.tag];
    }
}

- (void)hiddenChooseBtn
{
    [backgroundBtn setHidden:YES];
    [imageView setHidden:YES];
}

- (IBAction)selectKeyboardButtonPressed:(id)sender{
    if (backgroundBtn == nil) {
        //初始化输入面板选择弹出框
        backgroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [backgroundBtn addTarget:self action:@selector(hiddenChooseBtn) forControlEvents:UIControlEventTouchUpInside];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 151, self.frame.size.height - 130, 151, 130)];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImage:[UIImage imageNamed:@"ALbtn_input_selection.png"]];
        [self addSubview:backgroundBtn];
        [self addSubview:imageView];
        [backgroundBtn setHidden:YES];
        [imageView setHidden:YES];
        
        btnHandWrite = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 151, 120/4.0)];
        [btnHandWrite setTitle:@"手写" forState:UIControlStateNormal];
        [btnHandWrite addTarget:self action:@selector(changeKeyBoardFlag:) forControlEvents:UIControlEventTouchUpInside];
        btnHandWrite.tag = 0;
        [imageView addSubview:btnHandWrite];
        
        Letter = [[UIButton alloc]initWithFrame:CGRectMake(0, 110/4.0, 151, 120/4.0)];
        [Letter setTitle:@"首拼" forState:UIControlStateNormal];
        [Letter addTarget:self action:@selector(changeKeyBoardFlag:) forControlEvents:UIControlEventTouchUpInside];
        Letter.tag = 1;
        [imageView addSubview:Letter];
        
        pinyin = [[UIButton alloc]initWithFrame:CGRectMake(0, 110/2.0, 151, 120/4.0)];
        [pinyin setTitle:@"全拼" forState:UIControlStateNormal];
        [pinyin addTarget:self action:@selector(changeKeyBoardFlag:) forControlEvents:UIControlEventTouchUpInside];
        pinyin.tag = 2;
        [imageView addSubview:pinyin];
        
        english = [[UIButton alloc]initWithFrame:CGRectMake(0, (110 * 3)/4.0, 151, 120/4.0)];
        [english setTitle:@"英文" forState:UIControlStateNormal];
        [english addTarget:self action:@selector(changeKeyBoardFlag:) forControlEvents:UIControlEventTouchUpInside];
        english.tag = 3;
        [imageView addSubview:english];
    }
    [backgroundBtn setHidden:NO];
    [imageView setHidden:NO];
}

- (void)renewButtonStatus
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(hasText)])
    {
        [deleteBtn setEnabled:[self.delegate hasText]];
    }
}

+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame enable:(BOOL)enable
{
    return [self buttonWithTitle:title frame:frame enable:enable target:nil action:nil];
}

+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame enable:(BOOL)enable target:(id)target action:(SEL)action{
    UIButton* cteateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cteateButton setFrame:frame];
    
    //可伸缩的按钮图片
    UIImage* buttonImageNormal = [UIImage imageNamed:@"ALbtn_keyBoard.png"];
    UIImage* buttonImagePressed = [UIImage imageNamed:@"ALbtn_keyBoard_B.png"];
    UIImage* stretchableButtonImageNormal = [buttonImageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(buttonImageNormal.size.height/2.0, buttonImageNormal.size.width/2.0, buttonImageNormal.size.height/2.0 + 1.0, buttonImageNormal.size.width/2.0 + 1.0)];
    UIImage* stretchableButtonImagePressed = [buttonImagePressed resizableImageWithCapInsets:UIEdgeInsetsMake(buttonImagePressed.size.height/2.0, buttonImagePressed.size.width/2.0, buttonImagePressed.size.height/2.0 + 1.0, buttonImagePressed.size.width/2.0 + 1.0)];
    [cteateButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [cteateButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateDisabled];
    [cteateButton setBackgroundImage:stretchableButtonImagePressed forState:(UIControlState)UIControlStateHighlighted];
    
    //文字
    cteateButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    cteateButton.tintColor=[UIColor blackColor];
    [cteateButton setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    [cteateButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    //特别的图形按钮，将title初始化后图形即可自动居中
    if ([title isEqualToString:@"LEFTMOBILE"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_leftMove.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_leftMove_C.png"] forState:UIControlStateDisabled];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
        
        
        if (target != nil && [target respondsToSelector:@selector(touchDown:)] && [target respondsToSelector:@selector(touchUp:)]) {
            [cteateButton addTarget:target action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
            [cteateButton addTarget:target action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
            [cteateButton addTarget:target action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
            [cteateButton addTarget:target action:@selector(touchUp:) forControlEvents:UIControlEventTouchCancel];
            cteateButton.tag = 101;
        }
    }
    else if ([title isEqualToString:@"RIGHTMOBILE"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_rightMove.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_rightMove_C.png"] forState:UIControlStateDisabled];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
        
        if (target != nil && [target respondsToSelector:@selector(touchDown:)] && [target respondsToSelector:@selector(touchUp:)]) {
            [cteateButton addTarget:target action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
            [cteateButton addTarget:target action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
            [cteateButton addTarget:target action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
            [cteateButton addTarget:target action:@selector(touchUp:) forControlEvents:UIControlEventTouchCancel];
            cteateButton.tag = 102;
        }
    }
    else if ([title isEqualToString:@" "])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_space.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_space_C.png"] forState:UIControlStateDisabled];
        //因为空格需要字符输入，title不能置空，所以需要微调图标位置
        [cteateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    }
    else if ([title isEqualToString:@"DELE"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_dele.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_dele_C.png"] forState:UIControlStateDisabled];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if ([title isEqualToString:@"SHIFT"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_uppercase.png"] forState:UIControlStateNormal];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if ([title isEqualToString:@"RETURN"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_goback.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_goback.png"] forState:UIControlStateDisabled];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if ([title isEqualToString:@"UP"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_handwrite_on.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_handwrite_on_C.png"] forState:UIControlStateDisabled];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if ([title isEqualToString:@"DOWN"])
    {
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_handwrite_down.png"] forState:UIControlStateNormal];
        [cteateButton setImage:[UIImage imageNamed:@"ALbtn_icn_handwrite_down_C.png"] forState:UIControlStateDisabled];
        [cteateButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    //按钮是否可用
    [cteateButton setEnabled:enable];
    
    //按钮事件
    if (target != nil && action != nil && [target respondsToSelector:action])
    {
        [cteateButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return cteateButton;
}

- (void)dealloc
{
    self.delegate = nil;
    if (recognizeMoveCursorLongClickTimer != nil) {
        [recognizeMoveCursorLongClickTimer invalidate];
        recognizeMoveCursorLongClickTimer = nil;
    }
    if (moveCursorTimer != nil) {
        [moveCursorTimer invalidate];
        moveCursorTimer = nil;
    }
//    SAFE_ARC_RELEASE(moveCursorGr);
    
    SAFE_ARC_RELEASE(imageView);
    SAFE_ARC_RELEASE(backgroundBtn);
    SAFE_ARC_RELEASE(btnHandWrite);
    SAFE_ARC_RELEASE(Letter);
    SAFE_ARC_RELEASE(pinyin);
    SAFE_ARC_RELEASE(english);
    SAFE_ARC_RELEASE(deleteBtn);
    SAFE_ARC_SUPER_DEALLOC();
}

@end
