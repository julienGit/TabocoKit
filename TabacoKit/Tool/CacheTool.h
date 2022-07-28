//
//  CacheTool.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheTool : NSObject

/**
 得到缓存大小

 @return 大小
 */
-(CGFloat)readCacheSize;

/**
 清除缓存
 */
- (void)clearFile;
@end

NS_ASSUME_NONNULL_END
