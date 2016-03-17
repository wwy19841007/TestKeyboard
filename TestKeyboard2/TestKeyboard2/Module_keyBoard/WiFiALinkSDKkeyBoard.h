//
//  WiFiALinkSDKkeyBoard.h
//  keyboardDemo
//
//  2014-9-25 Wang Weiyang
//  控制系统键盘和自定义键盘的显示
//

#import <Foundation/Foundation.h>

/**
 * 键盘控制类
 */
@interface WiFiALinkSDKkeyBoard : NSObject

/** 键盘显示时，从底部向上的位移量 */
@property (nonatomic, assign) float offsetFromBottom;

/** 是否显示自定义的键盘 */
@property (nonatomic, assign) BOOL allowToShowUDFKeyboard;

+(WiFiALinkSDKkeyBoard *) sharedInstance;

@end
