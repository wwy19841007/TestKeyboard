//
//  GDInputView.h
//  HWInput
//
//  Created by huiwei.chen on 13-1-10.
//
//  2014-9-25 Wang Weiyang
//  中间件类，用于控制不同输入面板之间的切换
//  同时监听主程序使用中与输入相关的事件，对输入面板进行通知
//

#import <UIKit/UIKit.h>

#import "WiFiALinkSDKkeyBoardViewProtocol.h"

@interface GDInputView : UIView<WiFiALinkSDKkeyBoardViewProtocol, UITextFieldDelegate, UITextViewDelegate, UISearchBarDelegate>

/**
 * 键盘是否有显示
 */
@property (assign) BOOL isShowed;


/**
 * 显示当前键盘
 */
- (void)show:(NSNumber *)offset;

/**
 * 隐藏键盘
 */
- (void)hide;

/**
 *  重置键盘位置，用于offset改变的时候触发
 */
- (void)resetFrame:(CGFloat)keyboardHeight withOffset:(CGFloat)offset;

@end
