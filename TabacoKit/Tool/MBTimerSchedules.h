//
//  MBTimerSchedules.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBTimerSchedules : NSObject

/**
 生成定时器

 @param delay 延迟时间
 @param interval 时间间隔
 @param block 事件回调
 */
- (void)timerWithDelay:(float)delay    interval:(float)interval  handler:(void(^)(NSInteger index))block;


/**
 启动定时任务
 */
- (void)start;

/**
 取消定时器
 */
- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
