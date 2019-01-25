//
//  XPCTLinkModel.h
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/17.
//  Copyright © 2019 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPCTRunModel.h"

/**
 链接类型

 - XPCTLinkTypeUrl: url
 - XPCTLinkTypeTel: 电话
 - XPCTLinkTypeEmail: 电子邮箱
 */
typedef NS_ENUM(NSUInteger, XPCTLinkType) {
    XPCTLinkTypeUrl = 0,
    XPCTLinkTypeTel,
    XPCTLinkTypeEmail,
};

/**
 链接model
 */
@interface XPCTLinkModel : NSObject

// 链接类型
@property (nonatomic, assign) XPCTLinkType type;
// 链接在整个字符串中的range
@property (nonatomic, assign) NSRange range;
// 对应的文本
@property (nonatomic, strong) NSString *text;
// 链接开始区域
@property (nonatomic, assign) CGRect startRect;
// 链接中间区域
@property (nonatomic, assign) CGRect middleRect;
// 链接结束区域
@property (nonatomic, assign) CGRect endRect;

/**
 此链接是否包含指定点

 @param point 指定点
 @return YES: 命中; NO: 未命中
 */
- (BOOL)isContainPoint:(CGPoint)point;

/**
 实例化类方法

 @param type 链接类型
 @param range 链接字符串在父字符串中的range
 @param text 链接对应文本
 @param startRect 链接显示开始区域
 @param middleRect 链接显示中间区域
 @param endRect 链接显示结束区域
 @return 实例
 */
+ (instancetype)linkModelWithType:(XPCTLinkType)type
                            range:(NSRange)range
                             text:(NSString *)text
                            start:(CGRect)startRect
                           middle:(CGRect)middleRect
                              end:(CGRect)endRect;

@end
