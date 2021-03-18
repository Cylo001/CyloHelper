//
//  CyloHelper.h
//  CyloHelper
//
//  Created by Cylo on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CyloHelper : NSObject



#pragma - mark - 手机号
//手机号脱敏 Phone number desensitization
+(NSString *)getSecretyPhoneNumberString:(NSString *)phoneNumber;
#pragma - mark - Frame

/// 根据宽度求高度
/// @param text 计算的内容
/// @param width 计算的宽度
/// @param fontSize 字体大小
/// @param lineSpacing 行间距
+(CGFloat)getHeightWithLabelText:(NSString *)text LabelWidth:(CGFloat)width FontSize:(NSInteger)fontSize LineSpacing:(CGFloat)lineSpacing;

/// 根据高度度求宽度
/// @param text 计算的内容
/// @param height 计算的高度
/// @param fontSize 字体大小
/// @param lineSpacing 行间距
+ (CGFloat)getWidthWithLabelText:(NSString *)text LabelHeight:(CGFloat)height FontSize:(CGFloat)fontSize LineSpacing:(CGFloat)lineSpacing;

#pragma - mark - 进制转换
/// 10进制转16进制
/// @param tmpid 十进制
/// @param length 最终数据需要的长度 高位补0
/// @param lower 是否小写
+(NSString *)ToHex:(long long int)tmpid Len:(NSInteger)length LowerCase:(BOOL)lower;

/// data转16进制字符串
/// @param data 数据流
/// @param bigEndian 是否大端模式
+(NSString *)byteToString:(NSData*)data BigEndian:(BOOL)bigEndian;

/// 16进制字符串转10进制
/// @param hexString 16进制的字符串
+(NSInteger)hexStringToDecimalism:(NSString *)hexString;

#pragma - mark - MD5

/// MD5加密
/// @param str 文本
/// @param lower 是否小写
/// @param len32 长度是否是32（16）
+(NSString *)MD5:(NSString *)str Lower:(BOOL)lower Len32:(BOOL)len32;

#pragma - mark - 沙盒操作

/// 删除沙盒文件
/// @param path 绝对路径
+(BOOL)deleteFileWithPath:(NSString *)path;
#pragma - mark - 正则校验
/// 数字 字符或符号至少两种
/// @param text 文本
+ (BOOL)verifyTextIsTwoOfNumberCharSybol:(NSString *)text;

/// 校验是否中文、字母、数字
/// @param string 文本
+ (BOOL)verifyTextEngOrCNOrNumber:(NSString *)string;
/// 邮箱校验
/// @param email 邮箱
+ (BOOL)verifyEmail:(NSString *)email;
/// URL验证
/// @param url 链接
+ (BOOL) verifyUrl:(NSString *)url;
/// 全数字校验
/// @param str 字符串
+(BOOL) verifyAllNumber:(NSString *)str;
/// 手机号验证
/// @param mobileNum 手机号
+(BOOL)verifyPhoneNumber:(NSString *)mobileNum;

#pragma - mark - 颜色生成图片

/// 颜色生成图片
/// @param color 颜色
/// @param size 大小
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
