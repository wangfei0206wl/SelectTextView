//
//  XPCTLineModel.m
//  CoreTextTest
//
//  Created by 王飞 on 2019/1/9.
//  Copyright © 2019 wang. All rights reserved.
//

#import "XPCTLineModel.h"

@implementation XPCTLineModel

+ (instancetype)lineModelWithIndex:(int)index rect:(CGRect)rect {
    XPCTLineModel *model = [[XPCTLineModel alloc] init];
    
    model.index = index;
    model.rect = rect;
    
    return model;
}

@end
