//
//  JLTextField.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLTextField : UITextField
@property (nonatomic, copy) void(^block)(void);
@end

NS_ASSUME_NONNULL_END
