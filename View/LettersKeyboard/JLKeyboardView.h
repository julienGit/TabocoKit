//
//  JLKeyboardView.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLKeyboardView : UIView
@property (nonatomic, copy) void(^block)(NSString *str);

@property (nonatomic, copy) void(^sureBlock)(void);

@property (nonatomic, copy) void(^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
