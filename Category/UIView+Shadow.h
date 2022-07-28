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

NS_ASSUME_NONNULL_END
