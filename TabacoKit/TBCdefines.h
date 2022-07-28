//
//  TBCdefines.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#ifndef TBCdefines_h
#define TBCdefines_h

//宽比
#define RATIO_WIDHT750 [UIScreen mainScreen].bounds.size.width/375.0
#define RATIO_HEIGHT750 ([UIScreen mainScreen].bounds.size.height - NAV_STATUS_HEIGHT - TABBAR_HEIGHT)/(667.0-64-49)

#define APP_PF_BOLD_FONT(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize*RATIO_WIDHT750]
#define APP_PF_MEDIUM_FONT(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize*RATIO_WIDHT750]
#define APP_PF_LIGHT_FONT(fontSize) [UIFont fontWithName:@"PingFangSC-Light" size:fontSize*RATIO_WIDHT750]
#define APP_PF_REGULAR_FONT(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize*RATIO_WIDHT750]
#define APP_PF_HKREGULAR_FONT(fontSize) [UIFont fontWithName:@"PingFangHK-Regular" size:fontSize*RATIO_WIDHT750];


//安全运行block
#define BLOCK_SAFE_RUN(block,...) block ? block(__VA_ARGS__) : nil;

//字符串，数组或可变数组为空
#define kStringIsEmpty(string) ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] ? YES : NO)

//字符串不为空
#define kStringNotEmpty(string) ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] ? @"" : string)

//#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define kArrayIsEmpty(array) ([array isKindOfClass:[NSNull class]] || array == nil || array.count == 0 ? YES : NO)
#define kDictionaryIsEmpty(dic) ([dic isKindOfClass:[NSNull class]] || dic == nil || dic.allKeys == 0 ? YES : NO)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define kTabbarHeight self.navigationController.tabBarController.tabBar.frame.size.height

#define kBottomSafeHeight   (CGFloat)(kTopHeight>64?(34):(0))
#define  kmainScreenW [UIScreen mainScreen].bounds.size.width
#define  kmainScreenH [UIScreen mainScreen].bounds.size.height
//状态栏颜色
NS_INLINE void setStatusBarLightContent(BOOL isNeedLight) {
    
    UIApplication * app = [UIApplication sharedApplication];
    if (isNeedLight) {
        if (app.statusBarStyle == UIStatusBarStyleDefault) {
            app.statusBarStyle = UIStatusBarStyleLightContent;
        }
    } else {
        if (app.statusBarStyle == UIStatusBarStyleLightContent) {
            app.statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type)  __strong typeof(type) type = weak##type;

typedef void(^MBUICallback)(id results , NSError * error);

#endif /* TBCdefines_h */


#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif
