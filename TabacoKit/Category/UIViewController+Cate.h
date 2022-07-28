//
//  UIViewController+Cate.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Cate)
/**
 *  MARK:确认和取消的提示框
 */
-(void)showAlertTitle:(NSString*)title
              withMsg:(NSString *)message
          withSuccess:(void(^)(void))success
           withCancel:(void(^)(void))cancel;
/**
 *   MARK:按钮文字自定义的 确认和取消的提示框
 */
-(void)showAlertTitle:(NSString*)title
              withMsg:(NSString *)message
       withConfrimStr:(NSString *)confrimstr
        withCancelStr:(NSString *)cancelStr
          withSuccess:(void(^)(void))success
           withCancel:(void(^)(void))cancel;
/**
 *   MARK:只有一个按钮的 按钮文字自定义的 确认和取消的提示框
 */
-(void)showAlertTitle:(NSString*)title
              withMsg:(NSString *)message
       withConfrimStr:(NSString *)confrimstr
          withSuccess:(void(^)(void))success;

/**
 *   MARK:sheet 提示框
 */
-(void)showSheetTitle:(NSString *)title
              withMsg:(NSString *)message
             withBtns:(NSArray<NSString *> *)btnTitles
          withSuccess:(void(^)(NSInteger index))success;
@end

NS_ASSUME_NONNULL_END
