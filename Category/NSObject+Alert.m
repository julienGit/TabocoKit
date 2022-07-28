//
//  NSObject+Alert.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "NSObject+Alert.h"
#import <UIKit/UIKit.h>
@implementation NSObject (Alert)
- (void)_showAlertController:(UIAlertController *)aAlert
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [aAlert addAction:okAction];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootViewController = window.rootViewController;
    aAlert.modalPresentationStyle = 0;
    [rootViewController presentViewController:aAlert animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)aMsg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:aMsg preferredStyle:UIAlertControllerStyleAlert];
    [self _showAlertController:alertController];
}

- (void)showAlertWithTitle:(NSString *)aTitle
                   message:(NSString *)aMsg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMsg preferredStyle:UIAlertControllerStyleAlert];
    [self _showAlertController:alertController];
}
@end
