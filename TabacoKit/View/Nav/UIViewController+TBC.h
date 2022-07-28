//
//  UIViewController+TBC.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TBC)
@property (nonatomic, assign) IBInspectable BOOL hbd_blackBarStyle;
@property (nonatomic, assign) UIBarStyle hbd_barStyle;
@property (nonatomic, strong) IBInspectable UIColor *hbd_barTintColor;
@property (nonatomic, strong) IBInspectable UIImage *hbd_barImage;
@property (nonatomic, strong) IBInspectable UIColor *hbd_tintColor;
@property (nonatomic, strong) NSDictionary *hbd_titleTextAttributes;
@property (nonatomic, assign) IBInspectable float hbd_barAlpha;
@property (nonatomic, assign) IBInspectable BOOL hbd_barHidden;
@property (nonatomic, assign) IBInspectable BOOL hbd_barShadowHidden;
@property (nonatomic, assign) IBInspectable BOOL hbd_backInteractive;
@property (nonatomic, assign) IBInspectable BOOL hbd_swipeBackEnabled;
@property (nonatomic, assign) IBInspectable BOOL hbd_clickBackEnabled;

// computed
@property (nonatomic, assign, readonly) float hbd_computedBarShadowAlpha;
@property (nonatomic, strong, readonly) UIColor *hbd_computedBarTintColor;
@property (nonatomic, strong, readonly) UIImage *hbd_computedBarImage;

// 这个属性是内部使用的
@property (nonatomic, strong) UIBarButtonItem *hbd_backBarButtonItem;
@property (nonatomic, assign) BOOL hbd_extendedLayoutDidSet;

- (void)hbd_setNeedsUpdateNavigationBar;
@end

NS_ASSUME_NONNULL_END
