//
//  UIButton+CountDown.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CountDoneBlock)(UIButton *);
@interface UIButton (CountDown)
- (void)countDownWithTime:(NSInteger)timeLine
                withTitle:(NSString *)title
        andCountDownTitle:(NSString *)subTitle
                hasPrefix:(NSString *)Prefix
           countDoneBlock:(CountDoneBlock)countDoneBlock
            isInteraction:(BOOL)isInteraction;


- (void)countDownWithTime:(NSInteger)timeLine withTitle:(NSString *)title andCountDownTitle:(NSString *)subTitle countDoneBlock:(CountDoneBlock)countDoneBlock isInteraction:(BOOL)isInteraction;


- (void)startCountDownAction;
@end

NS_ASSUME_NONNULL_END
