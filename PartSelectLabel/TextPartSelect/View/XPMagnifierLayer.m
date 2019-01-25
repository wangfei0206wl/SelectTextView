//
//  XPMagnifierLayer.m
//  pandora_p
//
//  Created by 王飞 on 2018/12/20.
//  Copyright © 2018 wang. All rights reserved.
//

#import "XPMagnifierLayer.h"
#import <UIKit/UIKit.h>

@implementation XPMagnifierLayer

- (void)drawInContext:(CGContextRef)ctx {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    CGContextTranslateCTM(ctx, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    CGContextScaleCTM(ctx, 1.4, 1.4);
    CGContextTranslateCTM(ctx, -1 * self.shotPoint.x, -1 * self.shotPoint.y);
    [window.layer renderInContext:ctx];
    window.layer.contents = (id)nil;
}

@end
