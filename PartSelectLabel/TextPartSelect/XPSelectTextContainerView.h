//
//  XPSelectTextContainerView.h
//  pandora_p
//
//  Created by 王飞 on 2019/1/11.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "XPCTRunModel.h"
#import "XPCTLinkModel.h"

@protocol XPSelectTextContainerViewDelegate;

/**
 部分选中容器视图
 */
@interface XPSelectTextContainerView : UIView

/**
 代理(如果未设置代理或未实现代理方法，则使用默认类自己的默认方式处理)
 */
@property (nonatomic, weak) id<XPSelectTextContainerViewDelegate> delegate;

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

// 代理
@protocol XPSelectTextContainerViewDelegate <NSObject>

@optional
// 点击链接时回调
- (void)selectTextContainerView:(XPSelectTextContainerView *)view didClickLink:(XPCTLinkModel *)model;

@end
