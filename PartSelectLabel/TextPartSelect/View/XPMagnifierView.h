//
//  XPMagnifierView.h
//  pandora_p
//
//  Created by 王飞 on 2018/12/20.
//  Copyright © 2018 搜狗企业IT部. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 放大镜视图
 */
@interface XPMagnifierView : UIView

/**
 设置放大镜快照位置

 @param shotPoint 快照位置
 */
- (void)setPointToMagnify:(CGPoint)shotPoint;

/**
 设置放大镜属性

 @param shotPoint 快照位置
 @param postion 放大镜下方三角对齐位置
 */
- (void)updateMagnifyPoint:(CGPoint)shotPoint postion:(CGPoint)postion;

@end
