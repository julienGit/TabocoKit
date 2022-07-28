//
//  UITableView+SectionPath.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (SectionPath)
/**
 * MARK: 每个分区绘制圆角
 */
- (void)sectionBezierPathCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * MARK: 切上方方俩个角
 */
- (void)sectionBezierTopPathCell:(UITableViewCell *)cell
            forRowAtIndexPath:(NSIndexPath *)indexPath
                       withMagin:(CGFloat)magin;
/**
 * MARK: 切下方俩个角
 */
- (void)sectionBezierBottomPathCell:(UITableViewCell *)cell
            forRowAtIndexPath:(NSIndexPath *)indexPath
                          withMagin:(CGFloat)magin;
/**
 * MARK: 随访复诊单特制只绘制下俩个圆角
 */
- (void)sectionBezierPathCell:(UITableViewCell *)cell
            forRowAtIndexPath:(NSIndexPath *)indexPath
                    withMagin:(CGFloat)magin;
@end

NS_ASSUME_NONNULL_END
