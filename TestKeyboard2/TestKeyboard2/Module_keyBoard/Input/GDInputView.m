//
//  GDInputView.m
//  HWInput
//
//  Created by huiwei.chen on 13-1-10.
//
//

#import "GDInputView.h"

#import "WiFiALinkSDKJTHandWriteKeyBoardView.h"
#import "WiFiALinkSDKLetterKeyBoardView.h"
#import "WiFiALinkSDKPinyinKeyBoardView.h"
#import "WiFiALinkSDKEnglishKeyBoardView.h"
#import "WiFiALinkSDKNumberKeyBoardView.h"
#import "WiFiALinkSDKPublicNumberKeyBoardView.h"

#import "UIView+Utility.h"
#import "UITextField+Utility.h"
#import "UITextView+Utility.h"
#import "WiFiALinkSDKkeyBoardGlobal.h"

/**
 * 定义键盘类型
 */
enum WiFiALinkSDKKeyBoardType
{
    /** 手写 */
    WiFiALinkSDKKeyBoardHandWrite       = 0,
    /** 首拼 */
    WiFiALinkSDKKeyBoardLetter          = 1,
    /** 全拼 */
    WiFiALinkSDKKeyBoardPinyin          = 2,
    /** 英文 */
    WiFiALinkSDKKeyBoardEnglish         = 3,
    /** 数字符号 */
    WiFiALinkSDKKeyBoardPublicNumber    = 4,
    /** 纯数字键盘 */
    WiFiALinkSDKKeyBoardNumber          = 5
};

@interface GDInputView()
{
    /**
     * 当前选中的键盘，在手写、首拼、拼音、英文中循环，当切换到数字时，选中键盘不变
     */
    long                    keyboardSelectedIndex;
    /**
     * 当前显示的键盘，可以是任意类型的键盘，可以和选中键盘不一样
     */
    long                    keyboardShowIndex;
    /**
     * 当前编辑的控件
     */
    __weak UIView*          firstResponder;
    /**
     * 当前控件的代理，textField和textView是自身，searchBar是里面的textField
     */
    __weak id<UIKeyInput>   firstResponderDelegate;
}

/**
 * 包含所有类型的键盘列表
 */
@property (SAFE_ARC_PROP_RETAIN, nonatomic) NSArray* keyboardList;
/**
 * 当前控件原来的代理，用于避免键盘代理对原代理的事件造成影响
 */
@property (SAFE_ARC_PROP_RETAIN, nonatomic) id originalResponderDelegate;

@end

@implementation GDInputView

@synthesize isShowed;

/**
 * 初始化所有键盘类型，并填入keyboardList
 */
- (id)init
{
    self = [super init];
    if (self)
    {
        firstResponder                  = nil;
        self.originalResponderDelegate  = nil;
        keyboardShowIndex               = -1;
        keyboardSelectedIndex           = -1;
        isShowed                        = NO;
        
        [self resetFrame:[WiFiALinkSDKkeyBoardView getKeyboardHeight] withOffset:0];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ALKeyboard_Background.png"]]];
        
        UIView* _digitalBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_digitalBackground];
        
        WiFiALinkSDKJTHandWriteKeyBoardView* aLinkSDKHandWriteKeyBoardView = [[WiFiALinkSDKJTHandWriteKeyBoardView alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width, self.frame.size.height)];
        [aLinkSDKHandWriteKeyBoardView setDelegate:self];
        [aLinkSDKHandWriteKeyBoardView setTag:WiFiALinkSDKKeyBoardHandWrite];
        [self addSubview:aLinkSDKHandWriteKeyBoardView];
        
        WiFiALinkSDKLetterKeyBoardView* aLinkSDKLetterKeyBoardView = [[WiFiALinkSDKLetterKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [aLinkSDKLetterKeyBoardView setDelegate:self];
        [aLinkSDKLetterKeyBoardView setTag:WiFiALinkSDKKeyBoardLetter];
        [self addSubview:aLinkSDKLetterKeyBoardView];
        
        WiFiALinkSDKPinyinKeyBoardView* aLinkSDKPinyinKeyBoardView = [[WiFiALinkSDKPinyinKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [aLinkSDKPinyinKeyBoardView setDelegate:self];
        [aLinkSDKPinyinKeyBoardView setTag:WiFiALinkSDKKeyBoardPinyin];
        [self addSubview:aLinkSDKPinyinKeyBoardView];
        
        WiFiALinkSDKEnglishKeyBoardView* aLinkSDKEnglishKeyBoardView = [[WiFiALinkSDKEnglishKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [aLinkSDKEnglishKeyBoardView setDelegate:self];
        [aLinkSDKEnglishKeyBoardView setTag:WiFiALinkSDKKeyBoardEnglish];
        [self addSubview:aLinkSDKEnglishKeyBoardView];
        
        WiFiALinkSDKPublicNumberKeyBoardView* aLinkSDKPublicNumberKeyBoardView = [[WiFiALinkSDKPublicNumberKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [aLinkSDKPublicNumberKeyBoardView setDelegate:self];
        [aLinkSDKPublicNumberKeyBoardView setTag:WiFiALinkSDKKeyBoardPublicNumber];
        [self addSubview:aLinkSDKPublicNumberKeyBoardView];
        
        WiFiALinkSDKNumberKeyBoardView* aLinkSDKNumberKeyBoardView = [[WiFiALinkSDKNumberKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [aLinkSDKNumberKeyBoardView setDelegate:self];
        [aLinkSDKNumberKeyBoardView setTag:WiFiALinkSDKKeyBoardNumber];
        [self addSubview:aLinkSDKNumberKeyBoardView];
        
        self.keyboardList = @[aLinkSDKLetterKeyBoardView, aLinkSDKPinyinKeyBoardView, aLinkSDKEnglishKeyBoardView, aLinkSDKPublicNumberKeyBoardView, aLinkSDKNumberKeyBoardView];
        
        SAFE_ARC_RELEASE(aLinkSDKHandWriteKeyBoardView);
        SAFE_ARC_RELEASE(aLinkSDKLetterKeyBoardView);
        SAFE_ARC_RELEASE(aLinkSDKPinyinKeyBoardView);
        SAFE_ARC_RELEASE(aLinkSDKEnglishKeyBoardView);
        SAFE_ARC_RELEASE(aLinkSDKPublicNumberKeyBoardView);
        SAFE_ARC_RELEASE(aLinkSDKNumberKeyBoardView);
        
        SAFE_ARC_RELEASE(_digitalBackground);
    }
    
    return self;
}


/**
 * 在键盘启动或者切换时调用
 * 获得firstResponder
 * 为不同类型的输入对象加上Delegate
 * 如果键盘有数字类型，切换键盘类型
 */
- (void)firstResponderChanged{
    firstResponder = [UIView findFirstResponderInApplication];
    
    if (firstResponder == nil)
    {
        return;
    }
    
    if ([firstResponder isKindOfClass:[UITextField class]])
    {
        UITextField* tmpTextField = (UITextField *)firstResponder;
        if (tmpTextField.delegate != nil && ![tmpTextField.delegate isKindOfClass:[GDInputView class]]) {
            self.originalResponderDelegate = tmpTextField.delegate;
        }
        [tmpTextField setDelegate:self];
        firstResponderDelegate = tmpTextField;
        if (tmpTextField.keyboardType == UIKeyboardTypeNumberPad || tmpTextField.keyboardType == UIKeyboardTypePhonePad)
        {
            [self changeKeyBoardType:WiFiALinkSDKKeyBoardNumber];
        }
        else if (keyboardSelectedIndex > -1)
        {
            [self changeKeyBoardType:keyboardSelectedIndex];
        }
        else
        {
            [self changeKeyBoardType:WiFiALinkSDKKeyBoardHandWrite];
        }
    }
    else if ([firstResponder isKindOfClass:[UITextView class]])
    {
        UITextView* tmpTextView = (UITextView *)firstResponder;
        if (tmpTextView.delegate != nil && ![tmpTextView.delegate isKindOfClass:[GDInputView class]]) {
            self.originalResponderDelegate = tmpTextView.delegate;
        }
        [tmpTextView setDelegate:self];
        firstResponderDelegate = tmpTextView;
        if (keyboardSelectedIndex > -1)
        {
            [self changeKeyBoardType:keyboardSelectedIndex];
        }
        else
        {
            [self changeKeyBoardType:WiFiALinkSDKKeyBoardHandWrite];
        }
    }
    else
    {
        UISearchBar* tmpSearchBar = (UISearchBar *)firstResponder;
        if (tmpSearchBar.delegate != nil && ![tmpSearchBar.delegate isKindOfClass:[GDInputView class]]) {
            self.originalResponderDelegate = tmpSearchBar.delegate;
        }
        [tmpSearchBar setDelegate:self];
        UITextField* tmpTextField = [tmpSearchBar valueForKey:@"searchField"];
        firstResponderDelegate = tmpTextField;
        if (keyboardSelectedIndex > -1)
        {
            [self changeKeyBoardType:keyboardSelectedIndex];
        }
        else
        {
            if (keyboardSelectedIndex == -1)
            {
                [self changeKeyBoardType:WiFiALinkSDKKeyBoardHandWrite];
            }else
            {
                [self changeKeyBoardType:keyboardSelectedIndex];
            }
        }
    }
}

- (void)show:(NSNumber *)offset{
    [self firstResponderChanged];
    
    [self resetFrame:[WiFiALinkSDKkeyBoardView getKeyboardHeight] withOffset:[offset floatValue]];
    
    //这个变更插入屏幕的方式
    [[[self getCurrentRootViewController] view] addSubview:self];
    
    self.isShowed = YES;
    
    //键盘显示通知事件
    [[NSNotificationCenter defaultCenter] postNotificationName:GDKeyboardDidShowNotification object:[NSValue valueWithCGRect:self.frame]];
}

- (void)hide{
    //清理正在显示的键盘状态
    if (keyboardShowIndex!=-1) {
        [[self.keyboardList objectAtIndex:keyboardShowIndex] outKeyboard];
    }
    keyboardShowIndex = -1;
    //keyboardSelectedIndex = -1;
    [self removeFromSuperview];
    self.isShowed = NO;
    
    //键盘隐藏通知事件
    [[NSNotificationCenter defaultCenter] postNotificationName:GDKeyboardDidHideNotification object:nil];
}

/**
 * 切换键盘类型
 * 需要隐藏的键盘调用outKeyboard
 * 需要显示的键盘调用inKeyboard
 * keyboardSelectedIndex，在手写、首拼、拼音、英文中循环，当切换到数字时，值不变
 * keyboardShowIndex，是当前显示的键盘
 */
- (void)changeKeyBoardType:(long)keyboardType
{
    NSLog(@"%ld",(long)keyboardType);
    if (keyboardShowIndex == keyboardType)
    {
        //如果当前切换的控件是搜索栏，且键盘类型是首拼，则清空文本框
        if ([firstResponder isKindOfClass:[UISearchBar class]] && keyboardSelectedIndex == WiFiALinkSDKKeyBoardLetter && keyboardShowIndex == WiFiALinkSDKKeyBoardLetter) {
            UISearchBar *searchBar = (UISearchBar *)firstResponder;
            [searchBar setText:@""];
        }
        [[self.keyboardList objectAtIndex:keyboardType] renewButtonStatus];
        return;
    }
    if (keyboardShowIndex > -1)
    {
        [[self.keyboardList objectAtIndex:keyboardShowIndex] outKeyboard];
    }
    
    [[self.keyboardList objectAtIndex:keyboardType] inKeyboard];
    keyboardShowIndex = keyboardType;
    if (keyboardType == WiFiALinkSDKKeyBoardHandWrite ||
        keyboardType == WiFiALinkSDKKeyBoardLetter ||
        keyboardType == WiFiALinkSDKKeyBoardPinyin ||
        keyboardType == WiFiALinkSDKKeyBoardEnglish)
    {
        keyboardSelectedIndex = keyboardType;
    }
    else if (keyboardSelectedIndex == -1)
    {
        keyboardSelectedIndex = WiFiALinkSDKKeyBoardHandWrite;
    }
    //如果当前切换的控件是搜索栏，且键盘类型是首拼，则清空文本框
    if ([firstResponder isKindOfClass:[UISearchBar class]] && keyboardSelectedIndex == WiFiALinkSDKKeyBoardLetter && keyboardShowIndex == WiFiALinkSDKKeyBoardLetter) {
        UISearchBar *searchBar = (UISearchBar *)firstResponder;
        [searchBar setText:@""];
    }
}

/**
 * 根据当前显示的键盘重置当前键盘位置与尺寸
 */
- (void)resetFrame:(CGFloat)keyboardHeight withOffset:(CGFloat)offset{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float versionNo = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat screenWidth = screenRect.size.width < screenRect.size.height ? screenRect.size.width : screenRect.size.height;
    CGFloat screenHeight = screenRect.size.width > screenRect.size.height ? screenRect.size.width : screenRect.size.height;
    if (versionNo >= 7.0)
    {
        [self setFrame:CGRectMake(0, screenWidth - keyboardHeight - offset, screenHeight, keyboardHeight)];
    }
    else
    {
        [self setFrame:CGRectMake(0, screenWidth - keyboardHeight - 20 - offset, screenHeight, keyboardHeight)];
    }
}


/**
 * 获得程序当前的ViewController
 */
-(UIViewController *)getCurrentRootViewController {
    UIViewController* result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    UIWindow* topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray* windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView* rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
    {
        result = topWindow.rootViewController;
    }
    else
    {
        NSAssert(NO, @"ShareKit: Could not find a root view controller.");
    }
    if (result.presentedViewController) {
        if ([result.presentedViewController isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController *)result.presentedViewController).visibleViewController;
            return result;
        }
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = ((UINavigationController *)result).visibleViewController;
    }
    return result;
}

- (void)dealloc
{
    SAFE_ARC_RELEASE(self.originalResponderDelegate);
    SAFE_ARC_RELEASE(self.keyboardList);
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark - WiFiALinkSDKkeyBoardViewProtocol 实现方法

-(void)onCursorMovedLeft:(UIView *)sender{
    if (firstResponderDelegate != nil && [firstResponderDelegate respondsToSelector:@selector(moveCursorToLeft)]) {
        [firstResponderDelegate performSelector:@selector(moveCursorToLeft)];
    }
}

-(void)onCursorMovedRight:(UIView *)sender{
    if (firstResponderDelegate != nil && [firstResponderDelegate respondsToSelector:@selector(moveCursorToRight)]) {
        [firstResponderDelegate performSelector:@selector(moveCursorToRight)];
    }
}

//-(void)onKeyBoardViewChanged:(UIView *)sender
//{
//    //切换输入键盘
//    if (sender.tag == WiFiALinkSDKKeyBoardEnglish)
//    {
//        [self changeKeyBoardType:WiFiALinkSDKKeyBoardHandWrite];
//    }
//    else
//    {
//        [self changeKeyBoardType:(sender.tag + 1)];
//    }
//}

-(void)onNumberKeyBoardViewSelected:(UIView *)sender
{
    //切换到数字输入键盘
    [self changeKeyBoardType:WiFiALinkSDKKeyBoardPublicNumber];
}

-(void)onNumberKeyBoardViewReturned:(UIView *)sender
{
    //从数字键盘返回
    if (keyboardSelectedIndex == -1)
    {
        keyboardSelectedIndex = WiFiALinkSDKKeyBoardHandWrite;
    }
    [self changeKeyBoardType:keyboardSelectedIndex];
}

-(void)onChangeKeyBoardView:(UIView *)sender atIndex:(long)keyboardType
{
    //切换到指定的键盘
    [self changeKeyBoardType:keyboardType];
}

- (BOOL)hasText{
    //firstResponder是否有输入内容
    if (firstResponderDelegate != nil)
    {
        return [firstResponderDelegate hasText];
    }
    return NO;
}

- (void)insertText:(NSString *)text{
    //向firstResponder输入内容，在这里加入输入前和输入后需要出发的事件
    if (firstResponderDelegate != nil)
    {
        if ([firstResponder isKindOfClass:[UITextField class]])
        {
            UITextField* tmpTextField = (UITextField *)firstResponder;
            if (tmpTextField.delegate != nil && [tmpTextField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
            {
                if (![tmpTextField.delegate textField:tmpTextField shouldChangeCharactersInRange:tmpTextField.selectedRange replacementString:text])
                {
                    return;
                };
            }
        }
        [firstResponderDelegate insertText:text];
    }
}

- (void)deleteBackward
{
    //向firstResponder删除内容，在这里加入删除前和删除后需要出发的事件
    if (firstResponderDelegate != nil)
    {
        if ([firstResponder isKindOfClass:[UITextField class]])
        {
            UITextField* tmpTextField = (UITextField *)firstResponder;
            if (tmpTextField.delegate != nil && [tmpTextField.delegate  respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
            {
                NSRange range = tmpTextField.selectedRange;
                if (range.length == 0) {
                    range = NSMakeRange(tmpTextField.text.length - 1, 1);
                }
                if (![tmpTextField.delegate textField:tmpTextField shouldChangeCharactersInRange:range replacementString:@""])
                {
                    return;
                };
            }
        }
        [firstResponderDelegate deleteBackward];
    }
}

#pragma mark - UITextFieldDelegate UITextViewDelegate UISearchBarDelegate 实现方法 在控件编辑结束之后，触发重新查找firstResponder和检测键盘类型的工作，主要实现在输入控件切换时，触发键盘刷新自身状态，同时，对于系统原有对于控件监视的delegate，需要给予恢复

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.originalResponderDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.originalResponderDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.originalResponderDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setDelegate:self.originalResponderDelegate];
    firstResponder = nil;
    firstResponderDelegate = nil;
    self.originalResponderDelegate = nil;
    
    if (textField.delegate != nil && [textField.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [textField.delegate textFieldDidEndEditing:textField];
    }
    
    [self performSelector:@selector(firstResponderChanged) withObject:nil afterDelay:0.05];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.originalResponderDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.originalResponderDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.originalResponderDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark - UITextViewDelegate 事件转发

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.originalResponderDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.originalResponderDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.originalResponderDelegate textViewDidBeginEditing:textView];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView setDelegate:self.originalResponderDelegate];
    firstResponder = nil;
    firstResponderDelegate = nil;
    self.originalResponderDelegate = nil;
    
    if (textView.delegate != nil && [textView.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [textView.delegate textViewDidEndEditing:textView];
    }
    
    [self performSelector:@selector(firstResponderChanged) withObject:nil afterDelay:0.05];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.originalResponderDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.originalResponderDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.originalResponderDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.originalResponderDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.originalResponderDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

#pragma mark - UISearchBarDelegate 事件转发

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [self.originalResponderDelegate searchBarShouldBeginEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.originalResponderDelegate searchBarTextDidBeginEditing:searchBar];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.originalResponderDelegate searchBarShouldEndEditing:searchBar];
    }
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setDelegate:self.originalResponderDelegate];
    firstResponder = nil;
    firstResponderDelegate = nil;
    self.originalResponderDelegate = nil;
    
    if (searchBar.delegate != nil && [searchBar.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [searchBar.delegate searchBarTextDidEndEditing:searchBar];
    }
    
    [self performSelector:@selector(firstResponderChanged) withObject:nil afterDelay:0.05];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.originalResponderDelegate searchBar:searchBar textDidChange:searchText];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [self.originalResponderDelegate searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.originalResponderDelegate searchBarSearchButtonClicked:searchBar];
    }
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)]) {
        [self.originalResponderDelegate searchBarBookmarkButtonClicked:searchBar];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [self.originalResponderDelegate searchBarCancelButtonClicked:searchBar];
    }
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2){
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBarResultsListButtonClicked:)]) {
        [self.originalResponderDelegate searchBarResultsListButtonClicked:searchBar];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0){
    if (self.originalResponderDelegate != nil && [self.originalResponderDelegate respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)]) {
        [self.originalResponderDelegate searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
    }
}

@end
