//
//  UITextView+InputEmoji.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (InputEmoji)
/**
*  判断字符串中是否存在emoji  系统键盘自带的表情
* @param string 字符串
* @return YES(含有表情)
*/
BOOL stringContainsEmoji(NSString * string);

/**
*  判断字符串中是否存在emoji  第三方键盘
* @param string 字符串
* @return YES(含有表情)
*/
BOOL hasEmoji(NSString* string);


/**
* 判断 字母、数字、中文
*/
BOOL isInputRuleAndNumber(NSString * str);

/**
判断是不是九宫格
@param string  输入的字符
@return YES(是九宫格拼音键盘)
*/
BOOL isNineKeyBoard(NSString * string);


//-----过滤字符串中的emoji
NSString *disable_emoji(NSString*text);

/**
 * MARK:将字符串连带emoji 转成utf8
 * utf8->string    stringByRemovingPercentEncoding
 */
NSString *stringReplaceUTF8(NSString*text);
@end

NS_ASSUME_NONNULL_END
