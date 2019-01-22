//
//  XPCTLineModel.h
//  CoreTextTest
//
//  Created by 王飞 on 2019/1/9.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 单个CTline的数据信息
 */
@interface XPCTLineModel : NSObject

// 行索引
@property (nonatomic, assign) int index;
// 行区域
@property (nonatomic, assign) CGRect rect;

/**
 实例化类方法

 @param index 行索引
 @param rect 行的区域
 @return 实例
 */
+ (instancetype)lineModelWithIndex:(int)index rect:(CGRect)rect;

@end
