//
//  XPCoreTextAlgorithm.m
//  CoreTextTest
//
//  Created by 王飞 on 2019/1/9.
//  Copyright © 2019 wang. All rights reserved.
//

#import "XPCoreTextAlgorithm.h"

// 部分选中属性名称定义
NSAttributedStringKey const NSPartSelectAttributeName = @"partSelectAttributeName";
// 部分选中属性值前缀
NSString * const kPartSelectAttrValuePre = @"PartSelectAttrPre";

@implementation XPCoreTextAlgorithm

+ (void)caculateCoreText:(UIView *)view
                 ctFrame:(CTFrameRef)ctFrame
              lineModels:(NSMutableArray<XPCTLineModel *> *)arrLineModels
               runModels:(NSMutableArray<XPCTRunModel *> *)arrRunModels {
    if (ctFrame != NULL && arrLineModels && arrRunModels) {
        CFArrayRef lines = CTFrameGetLines(ctFrame);
        
        if (lines) {
            CFIndex count = CFArrayGetCount(lines);
            CGPoint origins[count];
            CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
            transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
            
            CGRect oldLineBounds = CGRectZero;
            NSMutableArray *arrRefValues = [NSMutableArray array];
            
            for (int i = 0; i < count; i++) {
                CGPoint linePoint = origins[i];
                CTLineRef line = CFArrayGetValueAtIndex(lines, i);
                
                CGRect lineBounds = [XPCoreTextAlgorithm getLineBounds:line point:linePoint oldLineBounds:oldLineBounds];
                CGRect translatelineBounds = CGRectApplyAffineTransform(lineBounds, transform);
                
                // 这里添加一个lineModel
                [arrLineModels addObject:[XPCTLineModel lineModelWithIndex:i rect:translatelineBounds]];
                
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                CGFloat minY = CGFLOAT_MAX; // 用于记录一行中run最小的y值
                CGFloat maxY = CGFLOAT_MIN; // 用于记录一行中run最大的y值

                for (int j = 0; j < CFArrayGetCount(runs); j++) {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                    CFRange range = CTRunGetStringRange(run);
                    CGRect runBounds = [XPCoreTextAlgorithm getRunBounds:line run:run linePoint:linePoint lineBounds:lineBounds];
                    CGRect translateRunBounds = CGRectApplyAffineTransform(runBounds, transform);
                    
                    // 这里添加一个runModel
                    [arrRunModels addObject:[XPCTRunModel runModelWithIndex:i rect:translateRunBounds range:range]];
                    
                    minY = (minY > translateRunBounds.origin.y)?translateRunBounds.origin.y:minY;
                    maxY = (maxY < (translateRunBounds.origin.y + translateRunBounds.size.height))?(translateRunBounds.origin.y + translateRunBounds.size.height):maxY;
                }
                [arrRefValues addObject:@{@"minY": @(minY), @"maxY": @(maxY)}];
                
                oldLineBounds = lineBounds;
            }
            
            // 调整runbounds(所有runBounds y方向上对齐，并消除与上一行的间隙)
            [XPCoreTextAlgorithm adjustCTRunBounds:arrRunModels refValues:arrRefValues];
        }
    }
}

+ (void)caculateCoreText:(UIView *)view
                    text:(NSString *)text
               runModels:(NSArray<XPCTRunModel *> *)arrRunModels
              linkModels:(NSMutableArray<XPCTLinkModel *> *)arrLinkModels {
    if (arrRunModels.count > 0 && arrLinkModels) {
        // 找到所有link的range，根据range生成linkModel
        NSError *error = nil;
        NSTextCheckingTypes types = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber; // 目前只check链接与电话
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:types error:&error];
        NSArray<NSTextCheckingResult *> *arrMatches = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        
        for (NSTextCheckingResult *result in arrMatches) {
            XPCTLinkType type = XPCTLinkTypeTel;
            XPCTRunModel *startRunModel = [arrRunModels objectAtIndex:result.range.location];
            XPCTRunModel *endRunModel = [arrRunModels objectAtIndex:(result.range.location + result.range.length - 1)];
            NSDictionary *dicResult = [XPCoreTextAlgorithm caculateSelArea:view startRun:startRunModel endRun:endRunModel];
            
            if (result.resultType == NSTextCheckingTypeLink) {
                type = [result.URL.absoluteString hasPrefix:@"mailto:"]?XPCTLinkTypeEmail:XPCTLinkTypeUrl;
            }
            XPCTLinkModel *model = [XPCTLinkModel linkModelWithType:type
                                                              range:result.range
                                                              start:[dicResult[@"startArea"] CGRectValue]
                                                             middle:[dicResult[@"middleArea"] CGRectValue]
                                                                end:[dicResult[@"endArea"] CGRectValue]];
            [arrLinkModels addObject:model];
        }
    }
}

+ (NSDictionary *)caculateSelArea:(UIView *)view
                         startRun:(XPCTRunModel *)startRunModel
                           endRun:(XPCTRunModel *)endRunModel {
    // 这里需要保证startRunModel、endRunModel的顺序不是颠倒的
    NSMutableDictionary *dicDest = [NSMutableDictionary dictionary];
    
    // 如果起点比终点大，计算时需要刨掉起点所在的CTRun
    if (startRunModel && endRunModel) {
        if (startRunModel.lineIndex == endRunModel.lineIndex) {
            // 同一行，只需要设置middleArea即可
            CGRect startRect = startRunModel.rect;
            CGRect endRect = endRunModel.rect;
            
            CGRect middleArea = CGRectZero;
            middleArea.origin = startRect.origin;
            middleArea.size.width = endRect.origin.x - startRect.origin.x + endRect.size.width;
            middleArea.size.height = startRect.size.height;
            
            [dicDest setValue:@(middleArea) forKey:@"middleArea"];
        } else {
            // 不同行，需要设置startArea、endArea，如果中间有隔行，设置middleArea
            CGRect startRect = startRunModel.rect;
            CGRect endRect = endRunModel.rect;
            
            CGRect startArea = CGRectZero;
            startArea.origin = startRect.origin;
            startArea.size.width = view.frame.size.width - startRect.origin.x;
            startArea.size.height = startRect.size.height;
            [dicDest setValue:@(startArea) forKey:@"startArea"];
            
            CGRect endArea = CGRectZero;
            endArea.origin = CGPointMake(0, endRect.origin.y);
            endArea.size.width = endRect.origin.x + endRect.size.width;
            endArea.size.height = endRect.size.height;
            [dicDest setValue:@(endArea) forKey:@"endArea"];
            
            if (startArea.origin.y + startArea.size.height < endArea.origin.y) {
                // 中间有隔行
                CGRect middleArea = CGRectZero;
                middleArea.origin.x = 0;
                middleArea.origin.y = startArea.origin.y + startArea.size.height;
                middleArea.size.width = view.frame.size.width;
                middleArea.size.height = endArea.origin.y - middleArea.origin.y;
                [dicDest setValue:@(middleArea) forKey:@"middleArea"];
            }
        }
   }
    
    return dicDest;
}

+ (XPCTRunModel *)findRunModel:(CGPoint)point runModels:(NSArray<XPCTRunModel *> *)arrRunModels {
    // 在指定runModel集合中查找点所在的runModel
    XPCTRunModel *destModel = nil;
    
    if (!CGPointEqualToPoint(point, CGPointZero) && arrRunModels.count > 0) {
        for (XPCTRunModel *model in arrRunModels) {
            if (CGRectContainsPoint(model.rect, point)) {
                destModel = model;
                break;
            }
        }
    }
    
    return destModel;
}

+ (XPCTLinkModel *)findLinkModel:(CGPoint)point
                      linkModels:(NSArray<XPCTLinkModel *> *)arrLinkModels {
    XPCTLinkModel *destModel = nil;
    
    if (!CGPointEqualToPoint(point, CGPointZero) && arrLinkModels.count > 0) {
        for (XPCTLinkModel *model in arrLinkModels) {
            if ([model isContainPoint:point]) {
                destModel = model;
                break;
            }
        }
    }
    
    return destModel;
}

+ (XPPinMoveType)analysisMoveType:(CGPoint)point
                       startModel:(XPCTRunModel *)startRunModel
                         endModel:(XPCTRunModel *)endRunModel {
    XPPinMoveType type = XPPinMoveTypeNone;
    
    if (startRunModel && endRunModel) {
        if (CGRectContainsPoint(startRunModel.rect, point)) {
            type = XPPinMoveTypeHead;
        } else if (CGRectContainsPoint(endRunModel.rect, point)) {
            type = XPPinMoveTypeTail;
        }
    }
    
    return type;
}

+ (NSDictionary *)analysisTouchMove:(XPCTRunModel *)hitPoint
                         startModel:(XPCTRunModel *)startRunModel
                           endModel:(XPCTRunModel *)endRunModel
                          runModels:(NSArray<XPCTRunModel *> *)arrRunModels
                           moveType:(XPPinMoveType)moveType {
    if (startRunModel && endRunModel) {
        XPCTRunModel *newStart = startRunModel;
        XPCTRunModel *newEnd = endRunModel;
        XPPinMoveType newType = moveType;
        
        if (hitPoint && moveType != XPPinMoveTypeNone) {
            if (moveType == XPPinMoveTypeHead) {
                startRunModel = hitPoint;
            } else {
                endRunModel = hitPoint;
            }
            // 判断startRunModel与endRunModel位置是否颠倒
            BOOL bReverse = [XPCoreTextAlgorithm isCTRunReverse:startRunModel endModel:endRunModel];
            
            if (bReverse) {
                if (moveType == XPPinMoveTypeHead) {
                    // 如果当前在移动头部大头针
                    NSUInteger index = [arrRunModels indexOfObject:endRunModel];
                    
                    newStart = [arrRunModels objectAtIndex:(index + 1)];
                    newEnd = startRunModel;
                } else {
                    //如果当前在移动尾部大头针
                    NSUInteger index = [arrRunModels indexOfObject:startRunModel];
                    
                    newStart = endRunModel;
                    newEnd = [arrRunModels objectAtIndex:(index - 1)];
                }
                newType = (moveType == XPPinMoveTypeHead)?XPPinMoveTypeTail:XPPinMoveTypeHead;
            } else {
                newStart = startRunModel;
                newEnd = endRunModel;
            }
        }
        
        return @{
                 @"startRun": newStart,
                 @"endRun": newEnd,
                 @"moveType": @(newType)
                 };
    }
    return nil;
}

+ (CGRect)caculateMenuRect:(XPCTRunModel *)startRunModel
                  endModel:(XPCTRunModel *)endRunModel
                 viewFrame:(CGRect)frame {
    /*
     1、如果在同一行，则取start、end之间的区域作为rect
     2、如果不在同一行，则取start、frame之间的区域作为rect
     */
    CGRect rect = startRunModel.rect;
    
    if (startRunModel.lineIndex != endRunModel.lineIndex) {
        rect.size.width = CGRectGetWidth(frame) - CGRectGetMinX(rect);
    } else {
        rect.size.width = CGRectGetMaxX(endRunModel.rect) - CGRectGetMinX(rect);
    }
    
    return rect;
}

+ (NSAttributedString *)seperateWordWithString:(NSAttributedString *)attributeString {
    NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeString];
    
    __block int index = 0;
    [tmpString.string enumerateSubstringsInRange:NSMakeRange(0, tmpString.string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        NSString *subString = [NSString stringWithFormat:@"%@_%@", kPartSelectAttrValuePre, @(index)];
        
        [tmpString addAttribute:NSPartSelectAttributeName value:subString range:substringRange];
        index++;
    }];
    
    return tmpString;
}

#pragma mark - private

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point oldLineBounds:(CGRect)oldLineBounds {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = floor((CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading));
    CGFloat height = ascent + descent;
    
    return CGRectMake(point.x, point.y, width, height);
}

+ (CGRect)getRunBounds:(CTLineRef)line run:(CTRunRef)run linePoint:(CGPoint)linePoint lineBounds:(CGRect)lineBounds {
    CGFloat ascent;
    CGFloat descent;
    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    CGFloat height = ascent + descent;
    CGFloat xOffset = linePoint.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    CGFloat yOffset = linePoint.y - descent;
    
    return CGRectMake(xOffset, yOffset, width, height);
}

+ (void)adjustCTRunBounds:(NSMutableArray<XPCTRunModel *> *)arrRunModels refValues:(NSArray *)arrRefValues {
    // 根据参考值(每行最小、最大y方向值)调整runBounds的y与高度
    for (XPCTRunModel *model in arrRunModels) {
        if (model.lineIndex > 0) {
            // 非第一行，则y方向使用上一行最大值，高度使用本行最大值与上一行最大值的差值
            NSDictionary *lastRefValue = arrRefValues[model.lineIndex - 1];
            NSDictionary *refValue = arrRefValues[model.lineIndex];
            CGRect rect = model.rect;
            
            rect.origin.y = [lastRefValue[@"maxY"] doubleValue];
            rect.size.height = [refValue[@"maxY"] doubleValue] - rect.origin.y;
            model.rect = rect;
        } else {
            // 第一行，则y方向使用本行最小值，高度使用本行最大值与最小值的差值
            NSDictionary *refValue = arrRefValues[model.lineIndex];
            CGRect rect = model.rect;
            
            rect.origin.y = [refValue[@"minY"] doubleValue];
            rect.size.height = [refValue[@"maxY"] doubleValue] - rect.origin.y;
            model.rect = rect;
        }
    }
}

+ (BOOL)isCTRunReverse:(XPCTRunModel *)startRunModel endModel:(XPCTRunModel *)endRunModel {
    // 判断起止CTRun是否颠倒了位置
    BOOL bReverse = NO;
    
    if (startRunModel.lineIndex != endRunModel.lineIndex) {
        // 不在同一行时，比较行索引值即可
        bReverse = (startRunModel.lineIndex < endRunModel.lineIndex)?NO:YES;
    } else {
        // 同一行时，比较rect的x值即可
        bReverse = (CGRectGetMinX(startRunModel.rect) <= CGRectGetMinX(endRunModel.rect))?NO:YES;
    }
    
    return bReverse;
}

@end
