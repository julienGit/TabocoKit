//
//  UIImage+Color.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

/**
 *  根据颜色生成一张图片
 *  @param color 提供的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGRect)rect;
//圆形图片
- (UIImage *)getRoundImage;


//设置圆角
- (UIImage *)lm_drawRectWithRoundedCorner:(CGFloat)radius
                                     size:(CGSize)size;

/**
 生成一张渐变色的图片
 @param colors 颜色数组
 @param rect 图片大小
 @return 返回渐变图片
 */
+ (UIImage *)gradientImageWithColors:(NSArray *)colors rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
