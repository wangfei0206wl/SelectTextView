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
 设置部分选中的menu

 @param arrMenuItems 菜单项
 @param responseObj menu事件处理类
 */
- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj;

/**
 更新容器信息
 
 @param ctFrame ctFrame
 @param text 文本
 */
- (void)updateWithCTFrame:(CTFrameRef)ctFrame text:(NSString *)text;

@end
