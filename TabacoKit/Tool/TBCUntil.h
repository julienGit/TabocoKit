//
//  TBCUntil.h
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import <CommonCrypto/CommonDigest.h>
@class  TBCUntil;
NS_ASSUME_NONNULL_BEGIN

//定义宏（限制输入内容）
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."

static const int EXPIRETIME = 604800;

#define IsOSVersionAtLeastiOS7() (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)//版本号

@interface TBCUntil : NSObject
+(TBCUntil *)initUtil;
 
/**
 * 判断字符串是否为空
 * @param string 字符串
 */
+(BOOL)isBlankString:(NSString *)string;


/**
 *  getSafeString
 *
 *  @param object object
 *
 *  @return string
 */
NSString * getSafeString(id object);

/**
 *验证手机号码
 * @param mobile 手机号码
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 *验证邮箱
 * @param email 邮箱
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 *验证身份证号码
 * @param ID 手机号码
 */
+ (BOOL) validateCodeID:(NSString *)ID;

/**
 *弹框
 * @param message 提示消息
 */
+(void)myAlertView:(NSString *)message;

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

/**
 *设置导航栏图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 * @param strPhone 电话号码
 */
+(NSString *)byReplacing:(NSString *)strPhone;
/**
 * MD5加密
 * @param inPutText 加密的字符串
 */
+(NSString *) md5: (NSString *) inPutText;
/**
 * 拨打号码
 * @param phoneNumber 手机号码
 * @param myViewController 视图控制器
 */
//+(void)dialTelPhone:(NSString *)phoneNumber withViewController:(UIViewController *)myViewController;
/**
 *拨打电话 无弹框
 * @param phoneNumber 手机号码
 */
+(void)dialTelPhone:(NSString *)phoneNumber;


/**
 *评分
 * @param ID 商品id
 */
//评价853590884
+(void)BuyEvaluationProject:(NSString *)ID;

/**
 *链接跳转appstore
 */
+(void)BuyEvaluationLink:(NSString *)strLink;

/*!
 * @brief 是否禁止系统自带侧滑
 * @param flag Yes:不禁止 No:禁止
 * @param viewCon 视图控制器
 */
+(void)noSideslip:(BOOL)flag withViewControll:(UIViewController *)viewCon;

/*!
 * @brief 得到当前日期
 *
 */
+(NSString *)getCurrentDate;

/**
 *!brief 获取时间戳
 *
 */
+(NSString *)getUnixtimestamp;

//生成随机数
+(NSString *)createRandom:(NSInteger)index;

/*!
 *  @brief 创建星星
 * @param strGrade 评分分数
 * @param scoreView 添加视图
 * @param x x坐标
 * @param y y坐标
 * @param w 宽度
 * @param h 高度
 */
+(void)createImageViewGrade:(NSString *)strGrade andView:(UIView *)scoreView imageX:(NSInteger)x imageY:(NSInteger)y imageW:(NSInteger)w imageH:(NSInteger)h;

/*!
 * brief 字典排序
 * @param arrayData 数组
 */
+(void)arraySort:(NSMutableArray *)arrayData;

/*!breif
 *获取当前app版本号
 */
+(NSString *)getVersion;


/*!breif
 *  限制文本输入框输入长度
 *@param string 输入的字符串
 *@param textField 当前文本输入框
 *@param range
 *@param legth 允许输入的长度
 */
+(BOOL)verificationTextFiledString:(NSString *)string withText:(UITextField *)textField withRange:(NSRange)range withLength:(NSInteger)legth;

/*!breif
 * 检测单个文件的大小
 *@param filePath 文件路径
 */
+(float)fileSizeAtPath:(NSString *)filePath;
/*!breif
 *保持原来的长宽比，生成一个缩略图
 *@param image 图片
 *@param asize 图片等比尺寸
 */
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
/*!breif
 * 压缩图片质量
 *@param image 图片
 *@param percent 压缩图片的倍数
 */
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent;
/*!breif
 *压缩图片尺寸
 *@param image 图片
 *@param newSize 图片的宽高
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

//去掉html标签
+(NSString *)filterHTML:(NSString *)html;

/*!breif
 *16进制颜色转RGB
 *@param hexString 16进制字符串
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

/**
 *修改同一字符串的颜色
 *@param string 输入的字符
 *@param range 需要换颜色的范围
 **/
+(NSMutableAttributedString *)updateStr:(NSString *)string withMakeRange:(NSRange)range withColor:(UIColor *)myColor withFontSize:(CGFloat)size;

//根据日期来计算年龄
+ (NSString*)fromDateToAge:(NSDate*)date;

//根据身份证号获取生日
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;

/**
 *替换占位符
 *@param content 输入的字符串
 */
+(NSString *)placeholderSetting:(NSString *)content;

/**
 返回字符串高度
 @param str 字符串
 @param width 要显示的宽度
 @param font 要计算的字体大小
 @returns 字符串的高度
 */
+ (float)getStringHeight:(NSString *)str width:(float)width font:(UIFont *)font;

/*!bref escape()编码
 * @param str 字符串
 */
+(NSString *)escape:(NSString *)str;
/**
 * Escape 解密
 */
+(NSString *)decodeFromPercentEscapeString: (NSString *) input;

/**
 * unicode 解码
 **/
+ (NSString *)logUnicodeDic:(NSDictionary *)dic ;



/**
 * 显示富文本
 *@param html html标签
 *@param width 显示宽度
 **/
+(NSAttributedString *)showAttributedToHtml:(NSString *)html withWidth:(float)width;

/**显示富文本
 *
 */
+(NSMutableAttributedString *)setAttributedString:(NSString *)str;
 

/**
 * !berif 计算富文本高度(图文)
 * @param string 字符串
 * @param width 宽度
 */
+(float)getCellEvaTotalHeight:(NSString *)string withWidth:(float)width;
//计算html字符串高度
+(CGFloat )getHTMLHeightByStr:(NSString *)str;
/**
 * !berif 获取webView中的所有图片URL
 *
 */
+ (NSArray *) getImageurlFromHtml:(NSString *) webString;

/**
 把富文本转为普通的字符串
 */
+ (NSString *)stringFromAttributedString:(NSAttributedString *)attr;
/**
 *  富文本转html字符串
 */
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri;
/**
 获取当前的window，不一定是keywindow
 @return 当前window
 */
+(UIWindow*)mainWindow;

#pragma mark-过滤所有表情
+ (BOOL)stringContainsEmoji:(NSString *)string ;

 
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+(BOOL)isNineKeyBoard:(NSString *)string;
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string;
/**
sha1 计算
*/
+(NSString *)sha1:(NSString *)input;


/**

 获取url中的参数并返回



 @param urlString 带参数的url

 @return @[NSString:无参数url, NSDictionary:参数字典]
 
 */

+ (NSArray*)getParamsWithUrlString:(NSString*)urlString ;

/**
 判断地址是否正确
 */
+ (BOOL)verifyWebUrlAddress:(NSString *)webUrl;

///数组转json
+(NSString *)arrayToString:(NSArray *)array;

/**
 xcode 日志中的unicode转换为中文
 */
+ (NSString *)stringByReplaceUnicode:(NSString *)unicodeStrin;

+(NSString *)changeStringToDate:(NSString *)string;

+ (NSString *)handleTimeStringSlowEightHourWithTimeStr:(NSDate *)date;


+ (BOOL)isAllowTakePhoto;

+ (BOOL)isAllowPhoto;


+(NSString *)getNowTimeTimestamp3;

+(NSString*)getCurrentTimes;

+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp;


+ (NSString *)nullToString:(id)string;


+ (BOOL)dx_isNullOrNilWithObject:(id)object;


+ (NSString *)getDeviceID;
+ (void)removeDeviceID;
@end

NS_ASSUME_NONNULL_END
