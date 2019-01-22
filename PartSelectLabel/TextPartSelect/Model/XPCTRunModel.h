//
//  XPCTRunModel.h
//  CoreTextTest
//
//  Created by 王飞 on 2019/1/9.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 单个CTRun的数据信息
 */
@interface XPCTRunModel : NSObject

// 所在行索引
@property (nonatomic, assign) int lineIndex;
// 对应的区域(按屏幕统一划块后的区域，非实际字符区域)
@property (nonatomic, assign) CGRect rect;
// 字符占用的真实区域
@property (nonatomic, assign) CGRect actualRect;
// run对应的在整个string中的range
@property (nonatomic, assign) CFRange range;

/**
 实例化类方法

 @param lineIndex run所在的行索引
 @param rect run的区域
 @param range run对应的字符所在字符串中的range
 @return 实例
 */
+ (instancetype)runModelWithIndex:(int)lineIndex rect:(CGRect)rect range:(CFRange)range;

@end
