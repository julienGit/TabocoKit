//
//  TBCUntil.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "TBCUntil.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>

#define ISios7 [[[UIDevice currentDevice] systemVersion]floatValue]



#define MB_KEY_DEVICE  @"MB_KEY_DEVICE"

@interface MBKeyChain : NSObject

+ (void)saveData:(id)data forKey:(NSString *)key;

+ (id)loadForKey:(NSString *)key;

+ (void)deleteKeyData:(NSString *)key;

@end


@implementation MBKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
             key, (id)kSecAttrService,
             key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

+ (void)saveData:(id)data forKey:(NSString *)key {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];

    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);

    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];

    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)loadForKey:(NSString *)key {

    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];

    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];

    CFDataRef keyData = NULL;

    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"???????????????key-- %@  exception-- %@", key, e);
        } @finally {
        }
    }

    if (keyData) {
      CFRelease(keyData);
    }

    return ret;
}

+ (void)deleteKeyData:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end


@implementation TBCUntil
//?????????
static TBCUntil *util=nil;
+(TBCUntil *)initUtil{
    if (util==nil) {
        util=[[TBCUntil alloc] init];
    }
    return util;
}



/**
 * ???????????????????????????
 * @param string ?????????
 */
+(BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL || string==Nil ) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    
    
    return NO;
}



/**
 *  getSafeString
 *
 *  @param object object
 *
 *  @return string
 */
NSString * getSafeString(id object)
{
    NSString *string = nil;
    if ([object isKindOfClass:[NSNull class]]||object==nil||[[NSString stringWithFormat:@"%@",object] isEqualToString:@"(null)"] || [[NSString stringWithFormat:@"%@",object] isEqualToString:@"Null"] ) {
        string = @"";
    }else
    {
        string = [NSString stringWithFormat:@"%@",object];
    }

    return string;
}


/**
 *??????????????????
 * @param mobile ????????????
 */
+ (BOOL) validateMobile:(NSString *)mobile
{
    //????????????13??? 15???18??????????????? \d ????????????
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}
/**
 *?????????????????????
 * @param ID ????????????
 */
+ (BOOL) validateCodeID:(NSString *)ID
{
    //????????????????????????????????????????????????????????????15???????????????18????????????????????????????????????
    NSString *codeRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:ID];
}
/**
 *??????
 * @param mesage ????????????
 */
+(void)myAlertView:(NSString *)message{
    UIAlertView *myAlert=[[UIAlertView alloc] initWithTitle:@"????????????" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"??????", nil];
    [myAlert show];
}


/**
 *  ?????????????????????
 * @param alpha ?????????
 * @param image ??????
 */
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

///?????????????????????
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

/**
 * @param strPhone ????????????
 */
+(NSString *)byReplacing:(NSString *)strPhone{
    strPhone=[strPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    NSLog(@"--strphone--%@",strPhone);
    return strPhone;
}

/**
 * MD5??????
 * @param inPutText ??????????????????
 */
+(NSString *) md5: (NSString *) inPutText
{
    
    NSLog(@"input1:%@",inPutText);
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    
    NSLog(@"result1:%@",resultStr);
    return [resultStr lowercaseString];
    
}


/**
 * ????????????
 * @param phoneNumber ????????????
 * @param myViewController ???????????????
 */
//+(void)dialTelPhone:(NSString *)phoneNumber withViewController:(UIViewController *)myViewController{

//}


/**
 *???????????? ?????????
 * @param phoneNumber ????????????
 * 10.2????????????????????? ?????????????????????????????????
 */
+(void)dialTelPhone:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/**
 *??????
 * @param ID ??????id
 */
//??????853590884
+(void)BuyEvaluationProject:(NSString *)ID{
    if (ISios7 ==7.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",ID]]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",ID]]];
    }
}

/**
 *????????????appstore
 */
+(void)BuyEvaluationLink:(NSString *)strLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLink]];
}
/*!
 * @brief ??????????????????????????????
 * @param flag Yes:????????? No:??????
 * @param viewCon ???????????????
 */
+(void)noSideslip:(BOOL)flag withViewControll:(UIViewController *)viewCon{
    if ([viewCon.navigationController  respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        viewCon.navigationController.interactivePopGestureRecognizer.enabled=flag;
    }
}

/*!
 * @brief ??????????????????
 *
 */
+(NSString *)getCurrentDate{
    //??????????????????
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:senddate];
}

/**
 *!brief ???????????????
 *
 */
+(NSString *)getUnixtimestamp{
    
   /* NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    return timeString;*/
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//???????????????
    
    ;
    
    return timeString;
}
/**
 *@brief ???????????????
 *@param index ???????????????
 */
+(NSString *)createRandom:(NSInteger)index{
    NSString *strRandom=@"";
    for (int i=0; i<index; i++) {
        strRandom= [strRandom stringByAppendingString:[NSString stringWithFormat:@"%u",arc4random()%10]];
    }
    NSLog(@"---^%@",strRandom);
    return strRandom;
}

/*!
 *  @brief ????????????
 * @param strGrade ????????????
 * @param scoreView ????????????
 * @param x x??????
 * @param y y??????
 * @param w ??????
 * @param h ??????
 */
+(void)createImageViewGrade:(NSString *)strGrade andView:(UIView *)scoreView imageX:(NSInteger)x imageY:(NSInteger)y imageW:(NSInteger)w imageH:(NSInteger)h{
    UIImageView *imageScore=[[UIImageView alloc] init];
    double grade=[strGrade doubleValue];
    for (int i=0; i<5; i++) {
        imageScore =[[UIImageView alloc] initWithFrame:CGRectMake(x+(w+2)*i, y, w, h)];
        if (grade-1>=0) {
            grade--;
            imageScore.image=[UIImage imageNamed:@"health_rate"];//?????????
        }else if (grade-1>-1 && grade-1<0){
            grade--;
            imageScore.image=[UIImage imageNamed:@"health_ban"];//?????????
        }else{
            imageScore.image=[UIImage imageNamed:@"health_zore"];//??????
        }
        [scoreView addSubview:imageScore];
    }
}


/*!
 * brief ????????????
 * @param arrayData ??????
 */
+(void)arraySort:(NSMutableArray *)arrayData{
    [arrayData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSDictionary *array1=(NSDictionary *)obj1;
        NSDictionary *array2=(NSDictionary *)obj2;
        float aNum=[[array1 objectForKey:@"down_rate"] floatValue];
        float bNum=[[array2 objectForKey:@"down_rate"] floatValue];
        if(aNum>bNum){
            return  NSOrderedAscending;
        }else if (aNum<bNum){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
}


/*!breif
 *????????????app?????????
 */
+(NSString *)getVersion{
    
    NSString *versionKey=[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    return versionKey;
}

/*!breif
 *  ??????????????????????????????????????????????????????
 *@param string ??????????????????
 *@param textField ?????????????????????
 *@param range
 *@param legth ?????????????????????
 */
+(BOOL)verificationTextFiledString:(NSString *)string withText:(UITextField *)textField withRange:(NSRange)range withLength:(NSInteger)legth{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];//??????????????????????????????????????????
    if(basic==YES){
        
        if ([string isEqualToString:@"\n"]) {//?????????????????????
            return YES;
        }
        NSString *toBeString=[textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSLog(@"bes---%@",toBeString);
        if ([toBeString length]>legth) {
            textField.text=[toBeString substringToIndex:legth];
            return NO;
        }
    }else{
        return NO;
    }
    
    return YES;
}

/*!breif
 * ???????????????????????????
 *@param filePath ????????????
 */
+(float)fileSizeAtPath:(NSString *)filePath{
    float imageFloat=0.0f;
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        imageFloat= [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024*1024);
    }
    NSLog(@"imageFloat--%f",imageFloat);
    return imageFloat;
}

/*!breif
 *????????????????????????????????????????????????
 *@param image ??????
 *@param asize ??????????????????
 */
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;//???????????????
        CGRect rect;//??????????????????
        if (asize.width/asize.height > oldsize.width/oldsize.height) {//??????????????????>?????????????????????
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
/*!breif
 * ??????????????????
 *@param image ??????
 *@param percent ?????????????????????
 */
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

/*!breif
 *??????????????????
 *@param image ??????
 *@param newSize ???????????????
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    //????????????bitmap???context?????????????????????????????????????????????context
    UIGraphicsBeginImageContext(newSize);
    // ???????????????????????????
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // ?????????context????????????????????????????????????
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // ????????????context?????????
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//??????html??????
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //???????????????????????????
        [scanner scanUpToString:@"<" intoString:nil];
        //???????????????????????????
        [scanner scanUpToString:@">" intoString:&text];
        //????????????
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


/*!breif
 *16???????????????RGB
 *@param hexString 16???????????????
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


/**
 *??????????????????????????????
 *@param string ???????????????
 *@param range ????????????????????????
 **/
+(NSMutableAttributedString *)updateStr:(NSString *)string withMakeRange:(NSRange)range withColor:(UIColor *)myColor withFontSize:(CGFloat)size{
    //????????????????????????
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:string];
    //??????
    [str addAttribute:NSForegroundColorAttributeName value:myColor range:range];
    //????????????
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:size] range:range];
    
    
    return str;
}

//???????????????????????????
+ (NSString*)fromDateToAge:(NSDate*)date{
    
    
    NSDate *myDate = date;
    
    NSDate *nowDate = [NSDate date];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    unsigned int unitFlags = NSYearCalendarUnit;
    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    
    
    NSInteger year = [comps year];
    
    NSLog(@"yea--%ld",(long)year);
    return [NSString stringWithFormat:@"%ld",(long)year];
    
    
}

//??????????????????????????????
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //**?????????14???
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**?????????14?????????????????????;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

/*
 *???????????????
 */
+(NSString *)placeholderSetting:(NSString *)content{
    
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    content = [content stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&cent;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&pound;" withString:@"??"];
    content = [content stringByReplacingOccurrencesOfString:@"&yen;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&euro;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&sect;" withString:@"??"];
    content = [content stringByReplacingOccurrencesOfString:@"&copy;" withString:@"??"];
    content = [content stringByReplacingOccurrencesOfString:@"&reg;" withString:@"??"];
    content = [content stringByReplacingOccurrencesOfString:@"&trade;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&times;" withString:@"??"];
    content = [content stringByReplacingOccurrencesOfString:@"&divide;" withString:@"??"];
    content = [content stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"???"];
    content = [content stringByReplacingOccurrencesOfString:@"&ne;" withString:@"???"];
    content=[content stringByReplacingOccurrencesOfString:@"&lt;/p>&lt;p>" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"&lt;p>" withString:@"      "];
    content=[content stringByReplacingOccurrencesOfString:@"&lt;/p>" withString:@""];
    
    return content;
}


/**
 ?????????????????????
 @param str ?????????
 @param width ??????????????????
 @param font ????????????????????????
 @returns ??????????????????
 */
+ (float)getStringHeight:(NSString *)str width:(float)width font:(UIFont*)font{
    
    CGSize contentSize;
    CGSize rectSize = CGSizeMake(width,MAXFLOAT);
    if (IsOSVersionAtLeastiOS7() >= 7.0) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        contentSize = [str boundingRectWithSize:CGSizeMake(rectSize.width, rectSize.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        contentSize = [str sizeWithFont:font
                      constrainedToSize:CGSizeMake(rectSize.width, rectSize.height)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    return contentSize.height;
}

/*!bref escape()??????
 * @param str ?????????
 */
+(NSString *)escape:(NSString *)str
{
    NSArray *hex = [NSArray arrayWithObjects:
                    @"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"0A",@"0B",@"0C",@"0D",@"0E",@"0F",
                    @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"1A",@"1B",@"1C",@"1D",@"1E",@"1F",
                    @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"2A",@"2B",@"2C",@"2D",@"2E",@"2F",
                    @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"3A",@"3B",@"3C",@"3D",@"3E",@"3F",
                    @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"4A",@"4B",@"4C",@"4D",@"4E",@"4F",
                    @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"5A",@"5B",@"5C",@"5D",@"5E",@"5F",
                    @"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"6A",@"6B",@"6C",@"6D",@"6E",@"6F",
                    @"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"7A",@"7B",@"7C",@"7D",@"7E",@"7F",
                    @"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"8A",@"8B",@"8C",@"8D",@"8E",@"8F",
                    @"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"9A",@"9B",@"9C",@"9D",@"9E",@"9F",
                    @"A0",@"A1",@"A2",@"A3",@"A4",@"A5",@"A6",@"A7",@"A8",@"A9",@"AA",@"AB",@"AC",@"AD",@"AE",@"AF",
                    @"B0",@"B1",@"B2",@"B3",@"B4",@"B5",@"B6",@"B7",@"B8",@"B9",@"BA",@"BB",@"BC",@"BD",@"BE",@"BF",
                    @"C0",@"C1",@"C2",@"C3",@"C4",@"C5",@"C6",@"C7",@"C8",@"C9",@"CA",@"CB",@"CC",@"CD",@"CE",@"CF",
                    @"D0",@"D1",@"D2",@"D3",@"D4",@"D5",@"D6",@"D7",@"D8",@"D9",@"DA",@"DB",@"DC",@"DD",@"DE",@"DF",
                    @"E0",@"E1",@"E2",@"E3",@"E4",@"E5",@"E6",@"E7",@"E8",@"E9",@"EA",@"EB",@"EC",@"ED",@"EE",@"EF",
                    @"F0",@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8",@"F9",@"FA",@"FB",@"FC",@"FD",@"FE",@"FF", nil ,nil];
    
    NSMutableString *result = [NSMutableString stringWithString:@""];
    int strLength = str.length;
    for (int i=0; i<strLength; i++) {
        int ch = [str characterAtIndex:i];
        if (ch == ' ')
        {
            [result appendFormat:@"%C",'+'];
        }
        else if ('A' <= ch && ch <= 'Z')
        {
            [result appendFormat:@"%C",(char)ch];
            
        }
        else if ('a' <= ch && ch <= 'z')
        {
            [result appendFormat:@"%C",(char)ch];
        }
        else if ('0' <= ch && ch<='9')
        {
            [result appendFormat:@"%C",(char)ch];
        }
        else if (ch == '-' || ch == '_'
                 || ch == '.' || ch == '!'
                 || ch == '~' || ch == '*'
                 || ch == '\'' || ch == '('
                 || ch == ')')
        {
            [result appendFormat:@"%C",(char)ch];
        }
        else if (ch <= 0x007F)
        {
            [result appendFormat:@"%%",'%'];
            [result appendString:[hex objectAtIndex:ch]];
        }
        else
        {
            [result appendFormat:@"%%",'%'];
            [result appendFormat:@"%C",'u'];
            [result appendString:[hex objectAtIndex:ch>>8]];
            [result appendString:[hex objectAtIndex:0x00FF & ch]];
        }
    }
    return result;
}


/**
 * Escape ??????
 */
+(NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}


/**
 * unicode ??????
 **/
+ (NSString *)logUnicodeDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


///???????????????
+(NSAttributedString *)showAttributedToHtml:(NSString *)html withWidth:(float)width{
    
    NSString *newString = [html stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",width]];
    
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    
    return attributeString;
    
}

///???????????????
+(NSMutableAttributedString *)setAttributedString:(NSString *)str
{
    //?????????????????????\n?????????<br/>
    //??????????????????????????????
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    //??????HTML???????????????
    str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",[UIScreen mainScreen].bounds.size.width,str];
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    //???????????????????????????
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, htmlString.length)];
    //???????????????
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
    
    return htmlString;
}


+ (NSString *)stringFromAttributedString:(NSAttributedString *)attr{
    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:attr];
    // ??????????????????????????????????????????????????????????????????replace??????????????????????????????range????????????????????????
    [attr enumerateAttributesInRange:NSMakeRange(0, attr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSTextAttachment * textAtt = attrs[@"NSAttachment"]; // ?????????????????????????????????
        if (textAtt)
        {
            UIImage * image = textAtt.image;
            [resutlAtt replaceCharactersInRange:range withString:[self stringWithImage:image]];
        }
    }];
    return resutlAtt.string;
}

/**
 ??*?? ????????????html?????????
 ??*/
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri{
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)documentAttributes:tempDic error:nil];
    return [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
}



+ (NSString *)stringWithImage:(UIImage *)image
{
    NSString *result = @"";
    /**
     *  ???????????????????????????????????????
     **/
    return result;
}
/**
 ?????????????????????
 
 @param string ?????????
 @param width ??????
 @return ??????
 */
//+(float)getCellEvaTotalHeight:(NSString *)string withWidth:(float)width{
//    float introHeight=0.f;
//    if(string){
//        // ????????????????????????
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//        NSAttributedString * attributedStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:kFont13,NSParagraphStyleAttributeName:paragraphStyle } documentAttributes:nil error:nil];
//
//        UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0,width, 1)];
//        UITextView * lab = [[UITextView alloc] initWithFrame:Rect(0, 0, width, 1)];
//        [view addSubview:lab];
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.trailing.equalTo(view);
//        }];
//        lab.attributedText = attributedStr;
//
//        [lab sizeToFit];
//        [view layoutIfNeeded];
//        introHeight = lab.contentSize.height;
//    }
//
//    return introHeight;
//}

//??????html???????????????
//+(CGFloat )getHTMLHeightByStr:(NSString *)str
//{
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
//    str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",[UIScreen mainScreen].bounds.size.width,str];
//
//    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
//    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, htmlString.length)];
//    //???????????????
//    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:5];
//    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [htmlString length])];
//
//    CGSize contextSize = [htmlString boundingRectWithSize:(CGSize){WIDTH, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//    return contextSize.height ;
//
//}

/**
 * !berif ??????webView??????????????????URL
 *
 */
+(NSArray *) getImageurlFromHtml:(NSString *) webString
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:webString options:NSMatchingReportCompletion range:NSMakeRange(0, webString.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [webString substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
}

/**
 ???????????????window???????????????keywindow
 @return ??????window
 */
+(UIWindow*)mainWindow{
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        NSLog(@"wind:%@",[appDelegate window]);
        return [appDelegate window];
    }
    
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    
    return nil;
}

#pragma mark-??????????????????
+ (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

/**
 ????????????????????????
 @param string  ???????????????
 @return YES(????????????????????????)
 */
+(BOOL)isNineKeyBoard:(NSString *)string
{
     NSString* match = @"^[A-Za-z0-9-+/=_????????????????????????\u4e00-\u9fa5]+$";

    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];

        return [predicate evaluateWithObject:string];
}
/**
 *  ??????????????????????????????emoji
 * @param string ?????????
 * @return YES(????????????)
 */
+ (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 sha1 ??????
 */
+(NSString *)sha1:(NSString *)input{
    
    NSData *data=[input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *outPut=[NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outPut appendFormat:@"%02x",digest[i]];
    }
    
    return outPut;
    
}



/**

 ??????url?????????????????????



 @param urlString ????????????url

 @return @[NSString:?????????url, NSDictionary:????????????]
 
 */

+ (NSArray*)getParamsWithUrlString:(NSString*)urlString {
    
    if(urlString.length==0) {
        
        NSLog(@"???????????????");
        
        return @[@"",@{}];
        
    }
    
    
    
    //???????????????
    
    NSArray*allElements = [urlString componentsSeparatedByString:@"?"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//???set???????????????
    
    
    
    if(allElements.count==2) {
        
        //????????????????????????????
        
        NSString*myUrlString = allElements[0];
        
        NSString*paramsString = allElements[1];
        
        
        
        //???????????????
        
        NSArray*paramsArray = [paramsString componentsSeparatedByString:@"&"];
        
        
        
        if(paramsArray.count>=2) {
            
            
            
            for(NSInteger i =0; i < paramsArray.count; i++) {
                
                
                
                NSString*singleParamString = paramsArray[i];
                
                NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                
                
                
                if(singleParamSet.count==2) {
                    
                    NSString*key = singleParamSet[0];
                    
                    NSString*value = singleParamSet[1];
                    
                    
                    
                    if(key.length>0|| value.length>0) {
                        
                        [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                        
                    }
                    
                }
                
            }
            
        }else if(paramsArray.count==1) {
            
            //??? &???url??????????????????????
            
            NSString*singleParamString = paramsArray[0];
            
            NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            
            
            
            if(singleParamSet.count==2) {
                
                NSString*key = singleParamSet[0];
                
                NSString*value = singleParamSet[1];
                
                
                
                if(key.length>0|| value.length>0) {
                    
                    [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                    
                }
                
            }else{
                
                //???????????????????????? xxxx?  ????????????
                
            }
            
        }
        
        
        
        //??????url?????????
        
        return@[myUrlString,params];
        
    }else if(allElements.count>2) {
        
        NSLog(@"????????????????????????????????????\"?\"");
        
        return @[@"",@{}];
        
    }else{
        
        NSLog(@"????????????????????????");
        
        return@[urlString,@{}];
        
    }
}
/**
 ????????????????????????
 */
+ (BOOL)verifyWebUrlAddress:(NSString *)webUrl
{
    if (!webUrl) {
          return NO;
      }
    return [UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:webUrl]];
}


///?????????json
+(NSString *)arrayToString:(NSArray *)array{
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}
/**
 xcode ????????????unicode???????????????
 */
+ (NSString *)stringByReplaceUnicode:(NSString *)unicodeString
{
    NSMutableString *convertedString = [unicodeString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}



+ (NSString *)nullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (id)string;
    }
}



+ (NSString *)caluateTotalMoneyWithPaterrn:(NSString *)pattern medicineFee:(NSString *)medicineFee otherFee:(NSString *)otherFee processFee:(NSString *)processFee repairFee:(NSString *)repairFee shippingFee:(NSString *)shippingFee consultationFee:(NSString *)consultationFee{
    
    NSString * number = [NSString stringWithFormat:@"%.2f" , [medicineFee floatValue] + [otherFee floatValue] + [processFee floatValue] + [consultationFee floatValue] + [repairFee floatValue]  + [shippingFee floatValue]] ;
    return  getSafeString(number);
    
}



//+ (NSString *)genTestUserSig:(NSString *)identifier
//{
//    CFTimeInterval current = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
//    long TLSTime = floor(current);
//    NSMutableDictionary *obj = [@{@"TLS.ver": @"2.0",
//                                  @"TLS.identifier": identifier,
//                                  @"TLS.sdkappid": @(SDKAPPID),
//                                  @"TLS.expire": @(EXPIRETIME),
//                                  @"TLS.time": @(TLSTime)} mutableCopy];
//    NSMutableString *stringToSign = [[NSMutableString alloc] init];
//    NSArray *keyOrder = @[@"TLS.identifier",
//                          @"TLS.sdkappid",
//                          @"TLS.time",
//                          @"TLS.expire"];
//    for (NSString *key in keyOrder) {
//        [stringToSign appendFormat:@"%@:%@\n", key, obj[key]];
//    }
//    NSLog(@"%@", stringToSign);
//    //NSString *sig = [self sigString:stringToSign];
//    NSString *sig = [self hmac:stringToSign];
//
//    obj[@"TLS.sig"] = sig;
//    NSLog(@"sig: %@", sig);
//    NSError *error = nil;
//    NSData *jsonToZipData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
//    if (error) {
//        NSLog(@"[Error] json serialization failed: %@", error);
//        return @"";
//    }
//
//    const Bytef* zipsrc = (const Bytef*)[jsonToZipData bytes];
//    uLongf srcLen = jsonToZipData.length;
//    uLong upperBound = compressBound(srcLen);
//    Bytef *dest = (Bytef*)malloc(upperBound);
//    uLongf destLen = upperBound;
//    int ret = compress2(dest, &destLen, (const Bytef*)zipsrc, srcLen, Z_BEST_SPEED);
//    if (ret != Z_OK) {
//        NSLog(@"[Error] Compress Error %d, upper bound: %lu", ret, upperBound);
//        free(dest);
//        return @"";
//    }
//    NSString *result = [self base64URL: [NSData dataWithBytesNoCopy:dest length:destLen]];
//    return result;
//}

+ (NSString *)base64URL:(NSData *)data
{
    NSString *result = [data base64EncodedStringWithOptions:0];
    NSMutableString *final = [[NSMutableString alloc] init];
    const char *cString = [result cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0; i < result.length; ++ i) {
        char x = cString[i];
        switch(x){
            case '+':
                [final appendString:@"*"];
                break;
            case '/':
                [final appendString:@"-"];
                break;
            case '=':
                [final appendString:@"_"];
                break;
            default:
                [final appendFormat:@"%c", x];
                break;
        }
    }
    return final;
}


//+ (NSString *)hmac:(NSString *)plainText
//{
//    const char *cKey  = [SECRETKEY cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [plainText cStringUsingEncoding:NSASCIIStringEncoding];
//
//    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
//
//    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//
//    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
//    return [HMACData base64EncodedStringWithOptions:0];
//}


+(NSString *)changeStringToDate:(NSString *)string {
    
    
    //??????T????????????????????????????????????????????????????????????????????????8????????????date????????????8????????????????????????16????????????
    
    NSString *str =[string stringByReplacingOccurrencesOfString:@"T"withString:@" "];
    
    NSString *sss =[str substringToIndex:19];
    
    //    NSString *str1 =[str stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateFromatter setTimeZone:timeZone];
    
    NSDate *date = [dateFromatter dateFromString:sss];
    
    NSDate *newdate = [[NSDate date] initWithTimeInterval:8 * 60 * 60 sinceDate:date];//
    
    NSDate *newdate1 = [[NSDate date] initWithTimeInterval:8 * 60 * 60 sinceDate:newdate];
    
    NSString *newstr =[[NSString stringWithFormat:@"%@",newdate1] substringToIndex:19];
    
    return newstr;
    
}


+ (NSString *)handleTimeStringSlowEightHourWithTimeStr:(NSDate *)date{
    
    NSLog(@"%@" , date);
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +SSSS"];
    
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return [dateFromatter stringFromDate:localeDate] ;
}



+ (BOOL)isAllowTakePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //?????????
        return NO;
    }
    return YES;
}


+ (BOOL)isAllowPhoto
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        //?????????
        return NO;
    }
    return YES;
}



+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYYMMddHHmmssSSS"]; // ----------????????????????????????,hh???HH?????????:????????????12?????????,24?????????
    
    //????????????,??????????????????????????????????????????
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//????????????,???????????????????????????????????????
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}


+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------????????????????????????,hh???HH?????????:????????????12?????????,24?????????
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //????????????,???????????????????????????????????????
    
    NSDate *datenow = [NSDate date];
    
    //----------???nsdate???formatter????????????nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}


#pragma mark ---- ???????????????????????????

+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp{
    
    //?????????????????????????????????NSDate??????
    
    double time = [timestamp doubleValue] / 1000.0;
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //??????????????????
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //???????????????????????????
    
    NSString *timeStr=[formatter stringFromDate:myDate];
    
    return timeStr;
    
}


//+ (NSString *)nullToString:(id)string {
//    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
//        return @"";
//    } else {
//        return (id)string;
//    }
//}


+ (BOOL)dx_isNullOrNilWithObject:(id)object
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}



+ (NSString *)getDeviceID{
    
    //read keychain's store UUID
    NSString * strUUID = (NSString *)[MBKeyChain loadForKey:MB_KEY_DEVICE];
    
    //????????????????????????UUID??????keyChain??????
    if([strUUID isEqualToString:@""] || !strUUID){
        //??????uuid
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
        
        strUUID = [strUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //??????uuid???keychain??????
        [MBKeyChain saveData:strUUID forKey:MB_KEY_DEVICE];
    }
    return strUUID ;
}


+ (void)removeDeviceID{
    
    [MBKeyChain deleteKeyData:MB_KEY_DEVICE];
    
}
@end
