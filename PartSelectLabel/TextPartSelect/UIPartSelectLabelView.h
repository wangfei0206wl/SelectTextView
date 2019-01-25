//
//  UIPartSelectLabelView.h
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/16.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPSelectTextContainerView.h"

// 防label的视图
@interface UIPartSelectLabelView : UIView

// 文本
@property (nonatomic, strong, setter=setText:) NSString *text;
// 富文本
@property (nonatomic, strong, setter=setAttributedText:) NSAttributedString *attributedText;
// 字体
@property (nonatomic, strong) UIFont *font;
// 颜色
@property (nonatomic, strong) UIColor *textColor;

/**
 实例化对象
 
 @param frame 尺寸
 @param delegate 代理
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

/**
 设置label的menu
 
 @param arrMenuItems 菜单项
 @param responseObj menu事件处理类
 */
- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj;

@end

// 用于计算label尺寸
@interface UIPartSelectLabelView (Size)

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
