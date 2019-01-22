//
//  XPCoreTextAlgorithm.h
//  CoreTextTest
//
//  Created by 王飞 on 2019/1/9.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "XPCTLineModel.h"
#import "XPCTRunModel.h"
#import "XPCTLinkModel.h"

/**
 大头针移动类型

 - XPPinMoveTypeNone: 没有移动大头针
 - XPPinMoveTypeHead: 移动头部大头针
 - XPPinMoveTypeTail: 移动尾部大头针
 */
typedef NS_ENUM(NSUInteger, XPPinMoveType) {
    XPPinMoveTypeNone = 0,
    XPPinMoveTypeHead,
    XPPinMoveTypeTail,
};

/**
 CoreText算法计算类
 */
@interface XPCoreTextAlgorithm : NSObject

/**
 根据参考视图、CTFrame计算所有CTLine、CTRun的信息

 @param view 参考视图
 @param ctFrame CoreText的CTFrame
 @param arrLineModels 计算所得的CTLine信息集
 @param arrRunModels 计算所得的CTRun信息集
 */
+ (void)caculateCoreText:(UIView *)view
                 ctFrame:(CTFrameRef)ctFrame
              lineModels:(NSMutableArray<XPCTLineModel *> *)arrLineModels
               runModels:(NSMutableArray<XPCTRunModel *> *)arrRunModels;

/**
 计算出文本信息中所有的LinkModel

 @param view 参考视图
 @param text 文本信息
 @param arrRunModels 已计算所得的文本的CTRun信息集
 @param arrLinkModels 计算所得的CTLink信息集
 */
+ (void)caculateCoreText:(UIView *)view
                    text:(NSString *)text
               runModels:(NSArray<XPCTRunModel *> *)arrRunModels
              linkModels:(NSMutableArray<XPCTLinkModel *> *)arrLinkModels;

/**
 根据起点终点信息，计算选中区域(分startArea, middleArea, endArea 三个区域, startRun为起点CTRun, endRun为终点CTRun)

 @param view 参考视图
 @param startRunModel 起点对应的CTRun信息
 @param endRunModel 终点对应的CTRun信息
 @return 选中区域信息字典
 */
+ (NSDictionary *)caculateSelArea:(UIView *)view
                         startRun:(XPCTRunModel *)startRunModel
                           endRun:(XPCTRunModel *)endRunModel;

/**
 根据点在指定CTRun信息集中查找命中的CTRun信息

 @param point 查找点
 @param arrRunModels CTRun信息集
 @return 命中的CTRun信息
 */
+ (XPCTRunModel *)findRunModel:(CGPoint)point
                     runModels:(NSArray<XPCTRunModel *> *)arrRunModels;

/**
 根据点在指定CTLink信息集中查找命中的CTLink信息

 @param point 查找点
 @param arrLinkModels CTLink信息集
 @return CTLink信息
 */
+ (XPCTLinkModel *)findLinkModel:(CGPoint)point
                      linkModels:(NSArray<XPCTLinkModel *> *)arrLinkModels;

/**
 分析大头针操作类型

 @param point 点击位置点
 @param startRunModel 选中区域开始的CTRun信息
 @param endRunModel 选中区域结束的CTRun信息
 @return 大头针操作类型
 */
+ (XPPinMoveType)analysisMoveType:(CGPoint)point
                       startModel:(XPCTRunModel *)startRunModel
                         endModel:(XPCTRunModel *)endRunModel;

/**
 根据命中CTRun、起始CTRun及大头针操作类型，分析出新的起始CTRun及大头针操作类型
 如果起始CTRun位置互换时，会涉及到大头针操作类型变化

 @param hitPoint 命中CTRun
 @param startRunModel 开始CTRun信息
 @param endRunModel 结束CTRun信息
 @param arrRunModels 供参考的CTRun集合
 @param moveType 大头针操作类型
 @return 新的起始CTRun及大头针操作类型@{@"startRun": @"CTRun", @"endRun": @"CTRun", @"moveType": @(XPPinMoveType)}
 */
+ (NSDictionary *)analysisTouchMove:(XPCTRunModel *)hitPoint
                         startModel:(XPCTRunModel *)startRunModel
                           endModel:(XPCTRunModel *)endRunModel
                          runModels:(NSArray<XPCTRunModel *> *)arrRunModels
                           moveType:(XPPinMoveType)moveType;

/**
 根据起始CTRun及视图尺寸计算menu的rect

 @param startRunModel 开始CTRun信息
 @param endRunModel 结束CTRun信息
 @param frame 视图尺寸
 @return menu的rect
 */
+ (CGRect)caculateMenuRect:(XPCTRunModel *)startRunModel
                  endModel:(XPCTRunModel *)endRunModel
                 viewFrame:(CGRect)frame;

/**
 将富文本中每个字符进行分离设置属性

 @param attributeString 富文本
 @return 每个字符都设置属性后的富文本
 */
+ (NSAttributedString *)seperateWordWithString:(NSAttributedString *)attributeString;

@end

// 部分选中属性名称定义
UIKIT_EXTERN NSAttributedStringKey const NSPartSelectAttributeName;
