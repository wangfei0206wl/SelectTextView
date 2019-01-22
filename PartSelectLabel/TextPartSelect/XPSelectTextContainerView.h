//
//  XPSelectTextContainerView.h
//  pandora_p
//
//  Created by 王飞 on 2019/1/11.
//  Copyright © 2019 搜狗企业IT部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "XPCTRunModel.h"

/**
 部分选中容器视图
 */
@interface XPSelectTextContainerView : UIView

/**
 初始化实例

 @param frame 容器视图尺寸
 @param parentView 父窗口
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame parentView:(UIView *)parentView;

/**
 设置部分选中的menu

 @param arrMenuItems 菜单项
 @param responseObj menu事件处理类
 */
- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj;

/**
 更新容器(show方法调用前使用)

 @param frame 容器视图尺寸
 @param ctFrame ctFrame
 @param text 文本
 */
- (void)updateWithFrame:(CGRect)frame ctFrame:(CTFrameRef)ctFrame text:(NSString *)text;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end
