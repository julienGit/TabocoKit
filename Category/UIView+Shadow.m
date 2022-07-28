//
//  UIView+Shadow.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)
- (void)haveShadowWithColor: (UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 5;
}

- (void)topHaveShadowWithColor: (UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0,7);
    self.layer.shadowRadius = 5;
}

- (void)removShadowWithColor: (UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(1,1);
}

- (void)ViweCircularBead
{
    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
}

- (void)haveShadowAndCirularBeadWithColor: (UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 5;
    self.layer.cornerRadius = 5;
}

- (void)removeSubviews{
    for(UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}
@end
