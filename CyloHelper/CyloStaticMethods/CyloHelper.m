//
//  CyloHelper.m
//  CyloHelper
//
//  Created by Cylo on 2021/3/15.
//

#import "CyloHelper.h"

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


@end
