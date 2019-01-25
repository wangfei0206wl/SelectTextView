//
//  XPSelectTextRangeView.m
//  pandora_p
//
//  Created by 王飞 on 2018/12/20.
//  Copyright © 2018 wang. All rights reserved.
//

#import "XPSelectTextRangeView.h"

#define kXInterval      (5)
#define kYInterval      (10)

@interface XPSelectTextRangeView ()

// 上半部分选中区域
@property (nonatomic, assign) CGRect upRect;
// 中间部分选中区域
@property (nonatomic, assign) CGRect midRect;
// 下半部分选中区域
@property (nonatomic, assign) CGRect downRect;

@end

@implementation XPSelectTextRangeView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = CGRectMake(-kXInterval, -kYInterval, CGRectGetWidth(frame) + 2 * kXInterval, CGRectGetHeight(frame) + 2 * kYInterval);
    
    return [super initWithFrame:rect];
}

- (void)updateWithUpRect:(CGRect)upRect midRect:(CGRect)midRect downRect:(CGRect)downRect {
    if (!CGRectIsEmpty(midRect) || (!CGRectIsEmpty(upRect) && !CGRectIsEmpty(downRect))) {
        self.upRect = CGRectOffset(upRect, kXInterval, kYInterval);
        self.midRect = CGRectOffset(midRect, kXInterval, kYInterval);
        self.downRect = CGRectOffset(downRect, kXInterval, kYInterval);

        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *backColor = [UIColor colorWithRed:0 green:84/255.0 blue:166/255.0 alpha:0.2];
    [backColor set];

    if ((CGRectIsEmpty(self.upRect) || CGRectIsEmpty(self.downRect)) && !CGRectIsEmpty(self.midRect)) {
        // 没有上下区域，只有中间区域，则是一行绘制
        CGContextAddRect(ctx, self.midRect);
        CGContextFillPath(ctx);
        
        // 绘制首尾大头针
        [self drawPinLayer:ctx point:self.midRect.origin height:self.midRect.size.height isStart:YES];
        [self drawPinLayer:ctx point:CGPointMake(self.midRect.origin.x + self.midRect.size.width, self.midRect.origin.y) height:self.midRect.size.height isStart:NO];
    } else if (!CGRectIsEmpty(self.upRect) && !CGRectIsEmpty(self.downRect)) {
        // 此为多行绘制
        CGContextAddRect(ctx, self.upRect);
        if (!CGRectIsEmpty(self.midRect)) {
            CGContextAddRect(ctx, self.midRect);
        }
        CGContextAddRect(ctx, self.downRect);
        CGContextFillPath(ctx);
        
        // 绘制首尾大头针
        [self drawPinLayer:ctx point:self.upRect.origin height:self.upRect.size.height isStart:YES];
        [self drawPinLayer:ctx point:CGPointMake(self.downRect.origin.x + self.downRect.size.width, self.downRect.origin.y) height:self.downRect.size.height isStart:NO];
    }
}

- (void)drawPinLayer:(CGContextRef)ctx point:(CGPoint)point height:(CGFloat)height isStart:(BOOL)bStart {
    UIColor *color = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
    CGRect roundRect = CGRectMake(point.x - 5, bStart?(point.y - 10):(point.y + height), 10, 10);
    
    CGContextAddEllipseInRect(ctx, roundRect);
    [color set];
    CGContextFillPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x, point.y + height);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    
    CGContextStrokePath(ctx);
}

@end
