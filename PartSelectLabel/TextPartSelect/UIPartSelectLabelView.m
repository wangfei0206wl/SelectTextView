//
//  UIPartSelectLabelView.m
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/16.
//  Copyright © 2019 wang. All rights reserved.
//

#import "UIPartSelectLabelView.h"
#import <CoreText/CoreText.h>
#import "XPCoreTextAlgorithm.h"

// 默认行间距
#define kDefaultLineSpacing     (8)

@interface UIPartSelectLabelView ()

@property (nonatomic, strong) XPSelectTextContainerView *selectView;
@property (nonatomic, assign) CTFrameRef ctFrame;

@end

@implementation UIPartSelectLabelView

- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj {
    [self.selectView setMenuItems:arrMenuItems responseObj:responseObj];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectView = [[XPSelectTextContainerView alloc] initWithFrame:self.bounds];
        self.selectView.delegate = delegate;
        [self addSubview:self.selectView];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    NSMutableDictionary *dicAttributes = [NSMutableDictionary dictionary];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:kDefaultLineSpacing];
    [dicAttributes setValue:(__bridge id)fontRef forKey:NSFontAttributeName];
    [dicAttributes setValue:self.textColor forKey:NSForegroundColorAttributeName];
    [dicAttributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CFRelease(fontRef);
    
    _attributedText = [[NSAttributedString alloc] initWithString:text attributes:dicAttributes];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    _text = [_attributedText string];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(self.ctFrame, context);
    
    [self.selectView updateWithCTFrame:self.ctFrame text:self.text];
}

- (void)dealloc {
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

#pragma mark - private

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

@implementation UIPartSelectLabelView (Size)

+ (CGSize)caculateSize:(NSString *)text font:(UIFont *)font restrictSize:(CGSize)restrictSize {
    NSMutableDictionary *dicAttributes = [NSMutableDictionary dictionary];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:kDefaultLineSpacing];
    [dicAttributes setValue:(__bridge id)fontRef forKey:NSFontAttributeName];
    [dicAttributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CFRelease(fontRef);
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:dicAttributes];
    
    return [UIPartSelectLabelView caculateSize:attributedText restrictSize:restrictSize];
}

+ (CGSize)caculateSize:(NSAttributedString *)attributedText restrictSize:(CGSize)restrictSize {
    NSAttributedString *attributedString = [XPCoreTextAlgorithm seperateWordWithString:attributedText];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    
    CFRelease(framesetter);
    return coreTextSize;
}

@end
