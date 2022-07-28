//
//  NSData+PCM.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (PCM)

// 为pcm文件写入wav头
+(NSData*) writeWavHead:(NSData *)audioData;
@end

NS_ASSUME_NONNULL_END
