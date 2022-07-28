//
//  UIView+Shadow.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Shadow)
- (void)removShadowWithColor: (UIColor *)color;
- (void)haveShadowWithColor: (UIColor *)color;
- (void)ViweCircularBead;
- (void)haveShadowAndCirularBeadWithColor: (UIColor *)color;
- (void)topHaveShadowWithColor: (UIColor *)color;
/**
 *  删除当前视图的所有子视图
 */
- (void)removeSubviews;
@end

@interface UIView (MBCategory)
//把View加在Window上
- (void) addToWindow;

@end

@interface UIView (Screenshot)

//View截图
- (UIImage*) screenshot;

//ScrollView截图 contentOffset
- (UIImage*) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

//View按Rect截图
- (UIImage*) screenshotInFrame:(CGRect)frame;

//整个view转成图片
- (UIImage*) convertToImage;


- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner;

- (void)acs_radiusWithRadius:(CGFloat)radius maskedCorner:(CACornerMask)maskCorner corner:(UIRectCorner)corner;
@end

@interface UIView (Animation)

//左右抖动动画
- (void) shakeAnimation;

//旋转180度
- (void) trans180DegreeAnimation;

@end

typedef NS_ENUM(NSUInteger, BLBadgeStyle) {
    BLBadgeStyleRedDot = 0,
    BLBadgeStyleNumber,
};

@interface UIView (Badge)

@property (nonatomic , strong) UILabel * badgeLb;
@property (nonatomic , copy  ) NSString * badgeValue;

- (void)showBadgeWithStyle:(BLBadgeStyle)style;
- (void)showBadge;

@end

NS_ASSUME_NONNULL_END
