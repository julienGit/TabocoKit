//
//  TBCMarqueeLabel.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KJMarqueeLabelType) {
    TBCMarqueeLabelTypeLeft = 0,//向左边滚动
    TBCMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};
@interface TBCMarqueeLabel : UILabel

@property(nonatomic,unsafe_unretained)KJMarqueeLabelType marqueeLabelType;
@property(nonatomic,unsafe_unretained)CGFloat speed;//速度
@property(nonatomic,unsafe_unretained)CGFloat secondLabelInterval;
@property(nonatomic,unsafe_unretained)NSTimeInterval stopTime;//滚到顶的停止时间

@end

NS_ASSUME_NONNULL_END
