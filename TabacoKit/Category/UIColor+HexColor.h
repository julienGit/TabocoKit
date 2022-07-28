//
//  UIColor+HexColor.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexColor)

/**
 hex 颜色值 转 uicolor

 @param color hex 颜色值
 @return uicolr 颜色值
 */
+ (UIColor *) colorWithHexString: (NSString *)color;


+ (UIColor*)RandomColor;
@end

NS_ASSUME_NONNULL_END
