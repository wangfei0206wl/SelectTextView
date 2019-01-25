//
//  XPMagnifierView.m
//  pandora_p
//
//  Created by 王飞 on 2018/12/20.
//  Copyright © 2018 wang. All rights reserved.
//

#import "XPMagnifierView.h"
#import "XPMagnifierLayer.h"

@interface XPMagnifierView ()

@property (nonatomic, strong) XPMagnifierLayer *magnifierLayer;

@end

@implementation XPMagnifierView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createSubviews];
    }
    
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    // 白色背景
    CALayer *upLayer = [CALayer layer];
    upLayer.frame = CGRectMake(0, 0, 120, 30);
    upLayer.backgroundColor = [UIColor whiteColor].CGColor;
    upLayer.cornerRadius = 5;
    upLayer.borderWidth = 1;
    upLayer.borderColor = [UIColor lightGrayColor].CGColor;
    upLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    upLayer.shadowOffset = CGSizeMake(1, 0);
    upLayer.shadowOpacity = 0.75;
    upLayer.shadowRadius = 0.75;
    [self.layer addSublayer:upLayer];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, 0, 120, 30);
    bottomLayer.backgroundColor = [UIColor whiteColor].CGColor;
    bottomLayer.cornerRadius = 5;
    bottomLayer.borderWidth = 1;
    bottomLayer.borderColor = [UIColor lightGrayColor].CGColor;
    bottomLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomLayer.shadowOffset = CGSizeMake(1, 0);
    bottomLayer.shadowOpacity = 0.75;
    bottomLayer.shadowRadius = 0.75;
    [self.layer addSublayer:bottomLayer];
    
    // 白色小三角
    CALayer *triangleLayer = [CALayer layer];
    triangleLayer.frame = CGRectMake(51, 21.5, 18, 18);
    triangleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    triangleLayer.contentsScale = [[UIScreen mainScreen] scale];
    triangleLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    triangleLayer.shadowOffset = CGSizeMake(0.6, 0.6);
    triangleLayer.shadowOpacity = 0.85;
    triangleLayer.shadowRadius = 0.85;
    [self.layer addSublayer:triangleLayer];
    CATransform3D transform = CATransform3DMakeRotation(M_PI / 4, 0, 0, 1);
    triangleLayer.transform = transform;
    
    CALayer *bottomTriangleLayer = [CALayer layer];
    bottomTriangleLayer.frame = CGRectMake(50, 20, 20, 20);
    bottomTriangleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    bottomTriangleLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:bottomTriangleLayer];
    bottomTriangleLayer.transform = transform;
    
    // 放大绘制layer
    self.magnifierLayer = [XPMagnifierLayer layer];
    self.magnifierLayer.frame = CGRectMake(0, 0, 120, 30);
    self.magnifierLayer.cornerRadius = 5;
    self.magnifierLayer.masksToBounds = YES;
    self.magnifierLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:self.magnifierLayer];
}

- (void)setPointToMagnify:(CGPoint)shotPoint {
    self.magnifierLayer.shotPoint = shotPoint;
    [self.magnifierLayer setNeedsDisplay];
}

- (void)updateMagnifyPoint:(CGPoint)shotPoint postion:(CGPoint)postion {
    self.hidden = NO;
    
    CGPoint center = CGPointMake(postion.x, self.center.y);
    center.y = postion.y - CGRectGetHeight(self.bounds) / 2;
    self.center = center;
    [self setPointToMagnify:shotPoint];
}

@end
