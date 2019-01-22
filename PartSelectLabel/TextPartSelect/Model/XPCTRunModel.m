//
//  XPCTRunModel.m
//  CoreTextTest
//
//  Created by 王飞 on 2019/1/9.
//  Copyright © 2019 wang. All rights reserved.
//

#import "XPCTRunModel.h"

@implementation XPCTRunModel

+ (instancetype)runModelWithIndex:(int)lineIndex rect:(CGRect)rect range:(CFRange)range {
    XPCTRunModel *model = [[XPCTRunModel alloc] init];
    
    model.lineIndex = lineIndex;
    model.rect = rect;
    model.actualRect = rect;
    model.range = range;
    
    return model;
}

@end
