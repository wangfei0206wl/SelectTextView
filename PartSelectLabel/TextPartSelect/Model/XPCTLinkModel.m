//
//  XPCTLinkModel.m
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/17.
//  Copyright © 2019 wang. All rights reserved.
//

#import "XPCTLinkModel.h"

@implementation XPCTLinkModel

- (BOOL)isContainPoint:(CGPoint)point {
    return (
            CGRectContainsPoint(self.startRect, point) ||
            CGRectContainsPoint(self.middleRect, point) ||
            CGRectContainsPoint(self.endRect, point)
            );
}

+ (instancetype)linkModelWithType:(XPCTLinkType)type
                            range:(NSRange)range
                             text:(NSString *)text
                            start:(CGRect)startRect
                           middle:(CGRect)middleRect
                              end:(CGRect)endRect {
    XPCTLinkModel *model = [[XPCTLinkModel alloc] init];
    
    model.type = type;
    model.range = range;
    model.text = text;
    model.startRect = startRect;
    model.middleRect = middleRect;
    model.endRect = endRect;
    
    return model;
}

@end
