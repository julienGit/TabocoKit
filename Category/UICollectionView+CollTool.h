//
//  UICollectionView+CollTool.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (CollTool)
-(void)registerCustemCalss:(Class)classs;
-(void)registerHeader:(Class)classs;
-(id)dequeueHeader:(NSString *)className withPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
