//
//  XPMagnifierLayer.h
//  pandora_p
//
//  Created by 王飞 on 2018/12/20.
//  Copyright © 2018 wang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/**
 放大镜快照layer
 */
@interface XPMagnifierLayer : CALayer

/**
 快照参考点
 */
@property (nonatomic, assign) CGPoint shotPoint;

@end
