//
//  WiFiALinkSDKkeyBoardView.h
//  TestKeyboard2
//
//  2014-9-25 Wang Weiyang
//  本类为输入面板的父类，用于定义通用的方法，并实现通用方法
//

#import <UIKit/UIKit.h>
#import "WiFiALinkSDKkeyBoardViewProtocol.h"
#import "ARCMacros.h"

@interface WiFiALinkSDKkeyBoardView : UIView
{
    @protected
    /** 每种键盘都有的删除按钮 */
    UIButton* deleteBtn;
    /** 长按事件计时器 */
    NSTimer *moveCursorTimer;
    /** 识别长按事件计时器，0.5秒后，如果还没被取消，则启动moveCursorTimer */
    NSTimer *recognizeMoveCursorLongClickTimer;
}

@property (assign, nonatomic) id<WiFiALinkSDKkeyBoardViewProtocol> delegate;

/**
 * 父类方法，长按按钮的按下事件
 */
- (IBAction)touchDown:(id)sender;

/**
 * 父类方法，长按按钮的松开事件
 */
- (IBAction)touchUp:(id)sender;

/**
 * 父类方法，向左移动光标
 */
- (IBAction)moveCursorToLeftButtonPressed:(id)sender;

/**
 * 父类方法，向右移动光标
 */
- (IBAction)moveCursorToRightButtonPressed:(id)sender;

/**
 * 父类方法，子类实现，键盘显示时触发
 */
- (void)inKeyboard;

/**
 * 父类方法，子类实现，键盘隐藏时触发
 */
- (void)outKeyboard;

/**
 * 父类方法，更新删除按钮的状态
 */
- (void)renewButtonStatus;

/**
 * 父类方法，子类实现，获得键盘高度
 */
+ (CGFloat)getKeyboardHeight;

/**
 * 父类方法，一般性字符填入事件
 */
- (IBAction)charButtonPressed:(id)sender;

/**
 * 父类方法，删除按钮事件
 */
- (IBAction)deleteButtonPressed:(id)sender;

/**
 * 父类方法，切换输入面板事件
 */
//- (IBAction)changeKeyboardButtonPressed:(id)sender;

/**
 * 父类方法，切换数字面板事件
 */
- (IBAction)changeNumberKeyboardButtonPressed:(id)sender;

/**
 * 父类方法，从数字面板返回事件
 */
- (IBAction)returnFromNumberKeyboardButtonPressed:(id)sender;

/**
 * 跳转指定的输入面板
 */
- (void)changeKeyBoardFlag:(UIButton *)btn;

/**
 * 隐藏输入选择面板
 */
- (void)hiddenChooseBtn;

/**
 * 显示输入选择面板
 */
- (IBAction)selectKeyboardButtonPressed:(id)sender;

/**
 * 父类方法，将一般的键盘按钮初始化写在一起
 */
+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame enable:(BOOL)enable target:(id)target action:(SEL)action;

/**
 * 父类方法，将一般的键盘按钮初始化写在一起（没有事件的初始化）
 */
+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame enable:(BOOL)enable;

@end
