//
//  MBTimerSchedules.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "MBTimerSchedules.h"

@interface MBTimerSchedules ()

{
    dispatch_source_t timer;
}

@end

@implementation MBTimerSchedules


- (void)timerWithDelay:(float)delay    interval:(float)interval  handler:(void(^)(NSInteger index))block{
    
   /**
    创建定时器

    @param DISPATCH_SOURCE_TYPE_TIMER 定时器类型
    @param 2 unkonwn
    @param 3 unkonwn
    @param 4 定时器队列
    @return void
    */
   timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0 ));
    
    
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        static int gcd_index = 0 ;
        
        block(gcd_index++);
    });
    
}


- (void)start{
    if(timer)
    dispatch_resume(timer);
}



- (void)invalidate{
    dispatch_source_cancel(timer);
//    dispatch_suspend(timer);
//    dispatch_cancel(time);
}
@end
