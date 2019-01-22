//
//  UIPartSelectLabel.m
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/15.
//  Copyright © 2019 wang. All rights reserved.
//

#import "UIPartSelectLabel.h"
#import <CoreText/CoreText.h>
#import "XPCoreTextAlgorithm.h"
#import "XPSelectTextContainerView.h"

// 默认行间距
#define kDefaultLineSpacing     (8)

@interface UIPartSelectLabel ()

@property (nonatomic, strong) XPSelectTextContainerView *selectView;
@property (nonatomic, assign) CTFrameRef ctFrame;

@end

@implementation UIPartSelectLabel

- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj {
    [self.selectView setMenuItems:arrMenuItems responseObj:responseObj];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupEvents];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    NSMutableDictionary *dicAttributes = [NSMutableDictionary dictionary];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:kDefaultLineSpacing];
    // 这里使用UIFont有问题，结果与CTFontRef效果不同(原因不明)
    [dicAttributes setValue:(__bridge id)fontRef forKey:NSFontAttributeName];
    [dicAttributes setValue:self.textColor forKey:NSForegroundColorAttributeName];
    [dicAttributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CFRelease(fontRef);

    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:dicAttributes];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(self.ctFrame, context);
}

- (void)dealloc {
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

#pragma mark - action

- (void)onTap:(UITapGestureRecognizer *)gesture {
    [self.selectView hide];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gesture {
    [self.selectView updateWithFrame:self.bounds ctFrame:self.ctFrame text:self.text];
    [self.selectView show];
}

#pragma mark - private

- (void)setupEvents {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self addGestureRecognizer:longPress];
    
    self.userInteractionEnabled = YES;
}

- (XPSelectTextContainerView *)selectView {
    if (!_selectView) {
        _selectView = [[XPSelectTextContainerView alloc] initWithFrame:self.bounds parentView:self];
    }
    return _selectView;
}

- (CTFrameRef)ctFrame {
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
    NSAttributedString *attributedString = [XPCoreTextAlgorithm seperateWordWithString:self.attributedText];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize restrictSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.bounds), coreTextSize.height));
    
    _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    return _ctFrame;
}

@end

@implementation UIPartSelectLabel (Size)

+ (CGSize)caculateSize:(NSString *)text font:(UIFont *)font restrictSize:(CGSize)restrictSize {
    NSMutableDictionary *dicAttributes = [NSMutableDictionary dictionary];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:kDefaultLineSpacing];
    [dicAttributes setValue:(__bridge id)fontRef forKey:NSFontAttributeName];
    [dicAttributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CFRelease(fontRef);
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:dicAttributes];
    
    return [UIPartSelectLabel caculateSize:attributedText restrictSize:restrictSize];
}

+ (CGSize)caculateSize:(NSAttributedString *)attributedText restrictSize:(CGSize)restrictSize {
    NSAttributedString *attributedString = [XPCoreTextAlgorithm seperateWordWithString:attributedText];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    
    CFRelease(framesetter);
    return coreTextSize;
}

@end
