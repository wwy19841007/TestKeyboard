//
//  WiFiALinkSDKkeyBoardViewProtocol.h
//  TestKeyboard2
//
//  2014-9-25 Wang Weiyang
//  WiFiALinkSDKkeyBoardView的代理，实现输入面板对中间件的回调
//

#import <Foundation/Foundation.h>

@protocol WiFiALinkSDKkeyBoardViewProtocol <NSObject>

@optional
/**
 * 光标向左移动事件
 */
-(void)onCursorMovedLeft:(UIView *)sender;
/**
 * 光标向左移动事件
 */
-(void)onCursorMovedRight:(UIView *)sender;
/**
 * 切换到指定输入面板事件
 */
-(void)onChangeKeyBoardView:(UIView *)sender atIndex:(long)keyboardType;

/**
 * 切换输入面板事件
 */
//-(void)onKeyBoardViewChanged:(UIView *)sender;

/**
 * 切换到数字面板事件
 */
-(void)onNumberKeyBoardViewSelected:(UIView *)sender;

/**
 * 从数字面板返回事件
 */
-(void)onNumberKeyBoardViewReturned:(UIView *)sender;

#pragma mark - 以下几个事件是对输入控件实现的UIKeyInput协议的再封装，用于统一入口，并在输入前和输入后进行统一的事件处理

/**
 * 判断输入控件是否有字符
 */
- (BOOL)hasText;

/**
 * 输入字符
 */
- (void)insertText:(NSString *)text;

/**
 * 删除字符
 */
- (void)deleteBackward;

@end
