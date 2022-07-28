//
//  UIView+Shadow.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "UIView+Shadow.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIColor+HexColor.h""

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


@implementation UIView (MBCategory)



-(void) addToWindow
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)])
    {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}


@end


@implementation UIView (Screenshot)

- (UIImage*) screenshot {
    
//    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
    
}

- (UIImage *) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset {
    UIGraphicsBeginImageContext(self.bounds.size);
    //need to translate the context down to the current visible portion of the scrollview
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -contentOffset.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.55);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIImage*) screenshotInFrame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), frame.origin.x, frame.origin.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

-(UIImage *) convertToImage {
    CGSize viewSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 **/
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner{
    
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
//    shapeLayer.fillColor = UIColor.themeDeepGreen.CGColor ;
//    shapeLayer.strokeColor
    shapeLayer.fillColor = UIColor.redColor.CGColor ; 
    self.layer.mask = shapeLayer;
  
}


/**
 圆角
 @param radius 圆角尺寸
 @param maskCorner 圆角位置列如：kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner
 @param corner 圆角位置列如：UIRectCornerTopRight|UIRectCornerTopLeft
 */
- (void)acs_radiusWithRadius:(CGFloat)radius maskedCorner:(CACornerMask)maskCorner corner:(UIRectCorner)corner {
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = maskCorner;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

@end

@implementation UIView (Animation)

- (void) shakeAnimation {
    
    CALayer* layer = [self layer];
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 8.0f, position.y);
    CGPoint x = CGPointMake(position.x + 8.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

- (void) trans180DegreeAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }];
}

@end

static const void * kBLBadgeLbKey = @"kBLBadgeLbKey";
static const void * kBLBadgeKey = @"kBLBadgeKey";
@implementation UIView (Badge)


- (UILabel *)badgeLb{
    
    return objc_getAssociatedObject(self, &kBLBadgeLbKey);
}

- (void)setBadgeLb:(UILabel *)badgeLb{
    objc_setAssociatedObject(self, &kBLBadgeLbKey, badgeLb, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)badgeValue{
    return objc_getAssociatedObject(self, &kBLBadgeKey);
    
}

- (void)setBadgeValue:(NSString *)badgeValue{
    if(badgeValue){
        objc_setAssociatedObject(self, &kBLBadgeKey, badgeValue, OBJC_ASSOCIATION_COPY);
        [self showBadgeWithStyle:BLBadgeStyleNumber];
    }else{
        [self.badgeLb removeFromSuperview];
    }
   
}

- (UILabel * )createBadgeLabelIWithText:(NSString *)text{
    CGFloat badgeWith = 8 ;
    CGFloat selfWidth = self.frame.size.width;
    
    CGRect frame = CGRectMake(selfWidth - badgeWith / 2, -badgeWith / 2, badgeWith, badgeWith);
    
    UILabel * lb = [[UILabel alloc] initWithFrame:frame];
    lb.layer.cornerRadius = badgeWith / 2 ;
    lb.layer.masksToBounds = NO ;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = text;
    lb.textColor = UIColor.whiteColor;
    lb.layer.backgroundColor = [UIColor colorWithHexString:@"#F86650"].CGColor ;

    lb.font = [UIFont systemFontOfSize:11];
    
    if(text.length > 0 ){
        CGFloat badgeWith = 15 ;
        CGFloat badgeHeight = 15 ;
        lb.layer.cornerRadius = badgeWith / 2;
        [lb sizeToFit];
        if(lb.frame.size.width > badgeWith){
            badgeWith = lb.frame.size.width  + 10 ;
        }
        CGRect frame = CGRectMake(selfWidth - (badgeWith - badgeHeight / 2), -badgeHeight / 2, badgeWith, badgeHeight);
        lb.frame = frame ;
    }
    return lb;
}

- (void)showBadgeWithStyle:(BLBadgeStyle)style{
    switch (style) {
        case BLBadgeStyleRedDot:{
            if(!self.badgeLb){
                self.badgeLb = [self createBadgeLabelIWithText:nil];
            }
        }
            break;
        case BLBadgeStyleNumber:{
            if(!self.badgeLb){
                self.badgeLb = [self createBadgeLabelIWithText:self.badgeValue];
            }
        }
            break;
        default:
            break;
    }
    
    [self addSubview:self.badgeLb];
}

- (void)showBadge{
    [self showBadgeWithStyle:BLBadgeStyleRedDot];
}



@end
