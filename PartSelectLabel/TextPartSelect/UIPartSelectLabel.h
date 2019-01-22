//
//  UIPartSelectLabel.h
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/15.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 支持部分选中的label
@interface UIPartSelectLabel : UILabel

/**
 设置label的menu
 
 @param arrMenuItems 菜单项
 @param responseObj menu事件处理类
 */
- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj;

@end

// 用于计算label尺寸
@interface UIPartSelectLabel (Size)

/**
 指定text、font计算label尺寸

 @param text 文本
 @param font 字体
 @param restrictSize 限制尺寸
 @return label尺寸
 */
+ (CGSize)caculateSize:(NSString *)text font:(UIFont *)font restrictSize:(CGSize)restrictSize;

/**
 指定富文本计算label尺寸

 @param attributedText 富文本
 @param restrictSize 限制尺寸
 @return label尺寸
 */
+ (CGSize)caculateSize:(NSAttributedString *)attributedText restrictSize:(CGSize)restrictSize;

@end
