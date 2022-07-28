//
//  TBCNavigationController.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBCNavigationController : UINavigationController

- (void)updateNavigationBarForViewController:(UIViewController *)vc;

@end
@interface UINavigationController(UINavigationBar) <UINavigationBarDelegate>

@end

@protocol TBCNavigationTransitionProtocol <NSObject>

- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)pan;

@end
NS_ASSUME_NONNULL_END
