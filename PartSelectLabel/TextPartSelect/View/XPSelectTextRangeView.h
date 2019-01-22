//
//  XPSelectTextRangeView.h
//  pandora_p
//
//  Created by 王飞 on 2018/12/20.
//  Copyright © 2018 搜狗企业IT部. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选中区域视图
 */
@interface XPSelectTextRangeView : UIView

/**
 更新选中区域视图

 @param upRect 上方区域
 @param midRect 中间区域
 @param downRect 下方区域
 */
- (void)updateWithUpRect:(CGRect)upRect midRect:(CGRect)midRect downRect:(CGRect)downRect;

@end
