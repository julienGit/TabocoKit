//
//  UICollectionView+CollTool.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "UICollectionView+CollTool.h"

@implementation UICollectionView (CollTool)
-(void)registerCustemCalss:(Class)classs {
    [self registerClass:classs forCellWithReuseIdentifier:NSStringFromClass(classs)];
}

-(void)registerHeader:(Class)classs {
    
    [self registerClass:classs forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(classs)];
}

-(id)dequeueHeader:(NSString *)className withPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:className forIndexPath:indexPath];
}
@end
