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

@end

NS_ASSUME_NONNULL_END
