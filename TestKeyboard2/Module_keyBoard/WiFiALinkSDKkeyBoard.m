#import "WiFiALinkSDKkeyBoard.h"
#import <UIKit/UIKit.h>
#import "GDInputView.h"
#import "ARCMacros.h"

@interface WiFiALinkSDKkeyBoard()
{
    /** 系统键盘页面 */
    UIView*                 g_aLinkKeyboard;
}

/** 自定义键盘 */
@property (SAFE_ARC_PROP_RETAIN, nonatomic) GDInputView* g_gdInputView;

@end

static WiFiALinkSDKkeyBoard* keyBoard;
@implementation WiFiALinkSDKkeyBoard

+(WiFiALinkSDKkeyBoard *) sharedInstance{

    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            keyBoard = [[self alloc] init];
            keyBoard.allowToShowUDFKeyboard = YES;
            [keyBoard addKeyboardNotification];
        });
    }
    return keyBoard;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (keyBoard == nil)
        {
            keyBoard = [super allocWithZone:zone];
            return keyBoard;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone;{
    return self; //确保copy对象也是唯一
}

#if __has_feature(objc_arc)
#else
-(id)retain{
    return self; //确保计数唯一
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //这样打印出来的计数永远为-1
}

- (id)autorelease
{
    return self;//确保计数唯一
}

- (oneway void)release
{
    //重写计数释放方法
}
#endif


- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)setOffsetFromBottom:(float)offsetFromBottom{
    _offsetFromBottom = offsetFromBottom;
    if (self.g_gdInputView) {
        [self.g_gdInputView resetFrame:self.g_gdInputView.frame.size.height withOffset:offsetFromBottom];
    }
}

- (void)setAllowToShowUDFKeyboard:(BOOL)allowToShowUDFKeyboard{
    _allowToShowUDFKeyboard = allowToShowUDFKeyboard;
    float versionNo = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (allowToShowUDFKeyboard) {
        if (g_aLinkKeyboard) {
            if (versionNo >= 8.0)
            {
                [g_aLinkKeyboard setHidden:YES];
            } else {
                [g_aLinkKeyboard setAlpha:0];
            }
        }
        if (nil != self.g_gdInputView) {
            [self.g_gdInputView show:[NSNumber numberWithFloat:self.offsetFromBottom]];
        }
    }else{
        if (g_aLinkKeyboard) {
            if (versionNo >= 8.0) {
                [g_aLinkKeyboard setHidden:NO];
            }
            else {
                [g_aLinkKeyboard setAlpha:1];
            }
        }
        if (nil != self.g_gdInputView) {
            [self.g_gdInputView hide];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.allowToShowUDFKeyboard) {
        return;
    }
    NSArray* windows = [[UIApplication sharedApplication] windows];
    float versionNo = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (versionNo >= 9.0){
        for (UIWindow* window in windows)
        {
            if ([[window description] hasPrefix:@"<UIRemoteKeyboardWindow"])
            {
                g_aLinkKeyboard = window;
                [g_aLinkKeyboard setAlpha:0];
                [g_aLinkKeyboard setHidden:YES];
                break;
            }
        }
    }
    else if (versionNo >= 8.0)
    {
        BOOL isViewFind = NO;
        for (UIWindow* window in windows)
        {
            for (UIView* view in window.subviews)
            {
                if ([[view description] hasPrefix:@"<UIInputSetContainerView"])
                {
                    g_aLinkKeyboard = view;
                    [g_aLinkKeyboard setHidden:YES];
                    isViewFind = YES;
                    break;
                }
            }
            if (isViewFind)
            {
                break;
            }
        }
    }
    else
    {
        for (UIWindow* window in windows)
        {
            if ([[window description] hasPrefix:@"<UITextEffectsWindow"])
            {
                g_aLinkKeyboard = window;
                [g_aLinkKeyboard setAlpha:0];
                break;
            }
        }
    }
    if (self.g_gdInputView == nil)
    {
        self.g_gdInputView = [[GDInputView alloc] init];
    }
    if (!self.g_gdInputView.isShowed)
    {
        [self.g_gdInputView performSelectorOnMainThread:@selector(show:) withObject:[NSNumber numberWithFloat:self.offsetFromBottom] waitUntilDone:YES];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if (!self.allowToShowUDFKeyboard) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.allowToShowUDFKeyboard) {
        return;
    }
    float versionNo = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (versionNo >= 8.0)
    {
    }
    else
    {
        [g_aLinkKeyboard setAlpha:0];
    }
    if (nil != self.g_gdInputView)
    {
        [self.g_gdInputView hide];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    if (!self.allowToShowUDFKeyboard) {
        return;
    }
    float versionNo = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (versionNo >= 9.0)
    {
        [g_aLinkKeyboard setAlpha:1];
        [g_aLinkKeyboard setHidden:NO];
    }else if (versionNo >= 8.0)
    {
        [g_aLinkKeyboard setHidden:NO];
    }
    else
    {
        [g_aLinkKeyboard setAlpha:1];
    }
    g_aLinkKeyboard = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_ARC_RELEASE(self.g_gdInputView);
    SAFE_ARC_RELEASE(keyBoard);
    SAFE_ARC_SUPER_DEALLOC();
}


@end
