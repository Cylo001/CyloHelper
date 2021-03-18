//
//  CyloHelper.m
//  CyloHelper
//
//  Created by Cylo on 2021/3/15.
//

#import "CyloHelper.h"
#import "netdb.h"
#import "arpa/inet.h"
#import<CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@implementation CyloHelper


#pragma - mark - 手机号
//手机号脱敏 Phone number desensitization
+(NSString *)getSecretyPhoneNumberString:(NSString *)phoneNumber{
    if (phoneNumber && phoneNumber.length > 7) {
        phoneNumber = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(phoneNumber.length -8, 4) withString:@"****"];//防止号码有前缀所以使用倒数第8位开始替换
    }
    return phoneNumber;
}

#pragma - mark - Frame
//根据宽度求高度 text 计算的内容  width 计算的宽度 font字体大小
+(CGFloat)getHeightWithLabelText:(NSString *)text LabelWidth:(CGFloat)width FontSize:(NSInteger)fontSize LineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing  = lineSpacing;
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
        NSParagraphStyleAttributeName: paragraph
    };
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithLabelText:(NSString *)text LabelHeight:(CGFloat)height FontSize:(CGFloat)fontSize LineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing  = lineSpacing;
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
        NSParagraphStyleAttributeName: paragraph
    };
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size.width;
}

#pragma - mark - 进制转换
//10进制转16进制
+(NSString *)ToHex:(long long int)tmpid Len:(NSInteger)length LowerCase:(BOOL)lower{
    NSString *strLen=[NSString stringWithFormat:@"%lld",tmpid];
    NSInteger len=strLen.length;
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i =0; i<len; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig){
            case 10:
                nLetterValue = lower?@"a":@"A";break;
            case 11:
                nLetterValue = lower?@"b":@"B";break;
            case 12:
                nLetterValue = lower?@"c":@"C";break;
            case 13:
                nLetterValue = lower?@"d":@"D";break;
            case 14:
                nLetterValue = lower?@"e":@"E";break;
            case 15:
                nLetterValue = lower?@"f":@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    if (str.length<length) {
        NSString *baseStr=[NSString stringWithFormat:@"%@",str];
        for (NSInteger i=0; i<length-baseStr.length; i++) {
            str=[NSString stringWithFormat:@"0%@",str];
        }
    }
    
    return str;
}
//data转16进制字符串
+(NSString *)byteToString:(NSData*)data BigEndian:(BOOL)bigEndian{
    NSMutableString *result=[NSMutableString string];
    const char *bytes = [data bytes];
    //0x00 01 02
    for (int i = 0; i < [data length]; i++){
        if (bigEndian) {//大端 "02 01 00"
            
            [result insertString:[NSString stringWithFormat:@"%02hhx", (unsigned char)bytes[i]] atIndex:0];
        }else{ //"00 01 02"
            [result stringByAppendingString:[NSString stringWithFormat:@"%02hhx", (unsigned char)bytes[i]]];
        }
    }
    return result;
}
//16进制字符串转10进制
+(NSInteger)hexStringToDecimalism:(NSString *)hexString{
    return strtol(hexString.UTF8String, 0, 16);;
}

#pragma - mark - MD5
+(NSString *)MD5:(NSString *)str Lower:(BOOL)lower Len32:(BOOL)len32{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        if (lower) {
            [digest appendFormat:@"%02x", result[i]];
        }else{
            [digest appendFormat:@"%02X", result[i]];
        }
    }
    NSString *finalStr=nil;
    if (len32) {
        finalStr=[NSString stringWithString:digest];
    }else{
        finalStr=[digest substringWithRange:NSMakeRange(8, 16)];
    }
    return finalStr;
}

#pragma - mark - 沙盒操作
+(BOOL)deleteFileWithPath:(NSString *)path{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isExist) {
        NSLog(@"File do not exist in path:%@",path);
        return NO;
    }else{
        BOOL isDel= [fileManager removeItemAtPath:path error:nil];
        NSString *msg=isDel?
        [NSString stringWithFormat:@"Deleted File Success. Path:%@",path]:
        [NSString stringWithFormat:@"Deleted File Fail. Path:%@",path];
        NSLog(@"%@",msg);
        return isDel;
    }
    return NO;
}
#pragma - mark - 正则校验
// 数字 字符或符号至少两种
+ (BOOL)verifyTextIsTwoOfNumberCharSybol:(NSString *)text{
    
    NSString *regex = @"^((?![0-9]+$)(?![a-zA-Z]+$)(?![~!@#$^&|*-_+=.?,]+$))[0-9A-Za-z~!@#$^&|*-_+=.?,]{6,20}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regextestcm evaluateWithObject:[text lowercaseString]];
}
//校验是否中文、字母、数字
+ (BOOL)verifyTextEngOrCNOrNumber:(NSString *)string{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", regex];
    return [predicate evaluateWithObject:string];
}
// 邮箱校验
+ (BOOL)verifyEmail:(NSString *)email {
    NSString *regex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:email];
}
// URL验证

+ (BOOL) verifyUrl:(NSString *)url{
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:url];
}

// 全数字校验
+(BOOL) verifyAllNumber:(NSString *)str{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}

// 手机号验证
+(BOOL)verifyPhoneNumber:(NSString *)mobileNum{
    NSString *AllNUMBER = @"^(1[3-9][0-9])\\d{8}$";
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    //  NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSString *NE = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *regextestAllnumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AllNUMBER];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestNE = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NE];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestAllnumber evaluateWithObject:mobileNum] == YES)
        || ([regextestNE evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
#pragma - mark - 颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
#pragma - mark - - - Method End - -
@end
