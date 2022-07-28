//
//  UITextView+InputEmoji.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "UITextView+InputEmoji.h"

@implementation UITextView (InputEmoji)
/**
*  判断字符串中是否存在emoji  系统键盘自带的表情
* @param string 字符串
* @return YES(含有表情)
*/
BOOL stringContainsEmoji(NSString * string) {
   
   __block BOOL returnValue = NO;
   
   [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
    ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
            
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
   
   return returnValue;
}

/**
*  判断字符串中是否存在emoji  第三方键盘
* @param string 字符串
* @return YES(含有表情)
*/
BOOL hasEmoji(NSString* string)
{
   NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
   NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
   BOOL isMatch = [pred evaluateWithObject:string];
   return isMatch;
}

/**
* 判断 字母、数字、中文
*/
BOOL isInputRuleAndNumber(NSString * str)
{
   NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
   unsigned long len=str.length;
   for(int i=0;i<len;i++)
   {
       unichar a=[str characterAtIndex:i];
       if(!((isalpha(a))
            ||(isalnum(a))
//             ||((a=='_') || (a == '-')) //判断是否允许下划线，昵称可能会用上
            ||((a==' '))                 //判断是否允许空格
            ||((a >= 0x4e00 && a <= 0x9fa6))
            ||([other rangeOfString:str].location != NSNotFound)
            ))
           return NO;
   }
   return YES;
}

/**
判断是不是九宫格
@param string  输入的字符
@return YES(是九宫格拼音键盘)
*/
BOOL isNineKeyBoard(NSString * string)
{
   NSString *other = @"➋➌➍➎➏➐➑➒";
   int len = (int)string.length;
   for(int i=0;i<len;i++)
   {
       if(!([other rangeOfString:string].location != NSNotFound))
           return NO;
   }
   return YES;
}


//-----过滤字符串中的emoji
NSString *disable_emoji(NSString*text){
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/**
 * MARK:将字符串连带emoji 转成utf8
 * utf8->string    stringByRemovingPercentEncoding
 */
NSString *stringReplaceUTF8(NSString*text){
    NSCharacterSet*allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:text] invertedSet];
    return [text stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

@end
