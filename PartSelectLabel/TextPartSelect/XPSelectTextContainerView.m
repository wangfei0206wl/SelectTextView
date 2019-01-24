//
//  XPSelectTextContainerView.m
//  pandora_p
//
//  Created by 王飞 on 2019/1/11.
//  Copyright © 2019 搜狗企业IT部. All rights reserved.
//

#import "XPSelectTextContainerView.h"
#import <objc/runtime.h>
#import "XPMagnifierView.h"
#import "XPCoreTextAlgorithm.h"
#import "XPSelectTextRangeView.h"

@interface XPSelectTextContainerView ()

// 父视图view
@property (nonatomic, weak) UIView *parentView;
// 部分选中对应的CTFrame
@property (nonatomic, assign) CTFrameRef ctFrame;
// 文本信息
@property (nonatomic, strong) NSString *text;

// 放大镜
@property (nonatomic, strong) XPMagnifierView *magnifierView;
// 部分选中视图
@property (nonatomic, strong) XPSelectTextRangeView *rangeView;

// lineModels
@property (nonatomic, strong) NSMutableArray *arrLineModels;
// RunModels
@property (nonatomic, strong) NSMutableArray *arrRunModels;
// linkModels
@property (nonatomic, strong) NSMutableArray *arrLinkModels;
// 选中视图开始点
@property (nonatomic, strong) XPCTRunModel *startRunModel;
// 选中视图结束点
@property (nonatomic, strong) XPCTRunModel *endRunModel;
// 当前移动大头针类型
@property (nonatomic, assign) XPPinMoveType moveType;

@end

@implementation XPSelectTextContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame parentView:(UIView *)parentView {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.parentView = parentView;

        [self createSubViews];
    }
    
    return self;
}

- (void)setMenuItems:(NSArray<UIMenuItem *> *)arrMenuItems responseObj:(id)responseObj {
    // 根据外部设置menu item来给textview动态添加方法
    for (UIMenuItem *item in arrMenuItems) {
        Method method = class_getInstanceMethod([responseObj class], item.action);
        class_addMethod([self class], item.action, imp_implementationWithBlock(^{
            [self hide];
            // 这里调用外部定义的方法
            if ([responseObj respondsToSelector:item.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [responseObj performSelector:item.action withObject:[self selectText]];
#pragma clang diagnostic pop
            }
        }), method_getTypeEncoding(method));
        method = class_getInstanceMethod([self class], item.action);
        item.action = method_getName(method);
    }
    
    [UIMenuController sharedMenuController].menuItems = arrMenuItems;
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
}

- (void)updateWithFrame:(CGRect)frame ctFrame:(CTFrameRef)ctFrame text:(NSString *)text {
    self.frame = frame;
    self.ctFrame = ctFrame;
    self.text = text;
}

- (void)show {
    // 需要全选
    self.startRunModel = self.arrRunModels.firstObject;
    self.endRunModel = self.arrRunModels.lastObject;
    
    [self updateSelectRangeView];
    [self.parentView addSubview:self];

    [self showMenuView];
}

- (void)hide {
    [self hideMenuView];
    [self resignFirstResponder];
    [self removeFromSuperview];
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
     优先判断点击的是否是链接，如果是，则响应链接
     否则判断移动大头针类型
     */
    CGPoint point = [[touches anyObject] locationInView:self];
    XPCTLinkModel *linkModel = [XPCoreTextAlgorithm findLinkModel:point linkModels:self.arrLinkModels];
    
    if (linkModel) {
        // 点击了链接
    } else {
        // 根据点击位置判断移动大头针类型
        self.moveType = [XPCoreTextAlgorithm analysisMoveType:point startModel:self.startRunModel endModel:self.endRunModel];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 隐藏放大镜，显示menu
    self.magnifierView.hidden = YES;
    [self showMenuView];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 隐藏放大镜，显示menu
    self.magnifierView.hidden = YES;
    [self showMenuView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideMenuView];
    
    if (self.moveType != XPPinMoveTypeNone) {
        CGPoint point = [[touches anyObject] locationInView:self];
        XPCTRunModel *model = [XPCoreTextAlgorithm findRunModel:point runModels:self.arrRunModels];
        
        if (model) {
            // 只有移动到字符所占区域，才做select view刷新
            NSDictionary *dicResult = [XPCoreTextAlgorithm analysisTouchMove:model startModel:self.startRunModel endModel:self.endRunModel runModels:self.arrRunModels moveType:self.moveType];
            self.startRunModel = dicResult[@"startRun"];
            self.endRunModel = dicResult[@"endRun"];
            self.moveType = [dicResult[@"moveType"] intValue];
            
            // 更新选中区域
            [self updateSelectRangeView];
            // 根据move位置刷新放大镜位置
            [self showMagnifierView:model];
        }
    }
}

- (void)showMagnifierView:(XPCTRunModel *)model {
    CGPoint postion = CGPointZero;
    CGPoint magnifyPoint = CGPointZero;
    
    if (self.moveType == XPPinMoveTypeHead) {
        postion = CGPointMake(model.rect.origin.x, model.rect.origin.y - 10);
        magnifyPoint = CGPointMake(model.actualRect.origin.x, model.actualRect.origin.y + model.actualRect.size.height / 2);
    } else if (self.moveType == XPPinMoveTypeTail) {
        postion = CGPointMake(model.rect.origin.x + model.rect.size.width, model.rect.origin.y - 5);
        magnifyPoint = CGPointMake(model.actualRect.origin.x + model.rect.size.width, model.actualRect.origin.y + model.actualRect.size.height / 2);
    }
    
    magnifyPoint = [self convertPoint:magnifyPoint toView:[UIApplication sharedApplication].keyWindow];
    postion = [self convertPoint:postion toView:[UIApplication sharedApplication].keyWindow];
    [self.magnifierView updateMagnifyPoint:magnifyPoint postion:postion];
}

- (void)updateSelectRangeView {
    // 更新选中区域视图
    NSDictionary *dicInfo = [XPCoreTextAlgorithm caculateSelArea:self startRun:self.startRunModel endRun:self.endRunModel];
    
    [self.rangeView updateWithUpRect:[dicInfo[@"startArea"] CGRectValue] midRect:[dicInfo[@"middleArea"] CGRectValue] downRect:[dicInfo[@"endArea"] CGRectValue]];
}

#pragma mark - menu

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController.menuItems.count > 0) {
        for (UIMenuItem *item in menuController.menuItems) {
            if (action == item.action) {
                return YES;
            }
        }
        
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)showMenuView {
    [self becomeFirstResponder];
    
    CGRect rect = [XPCoreTextAlgorithm caculateMenuRect:self.startRunModel endModel:self.endRunModel viewFrame:self.frame];
    
    [[UIMenuController sharedMenuController] setTargetRect:rect inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)hideMenuView {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - private

- (void)createSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;

    self.rangeView = [[XPSelectTextRangeView alloc] initWithFrame:self.bounds];
    self.rangeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.rangeView];
}

- (XPMagnifierView *)magnifierView {
    if (!_magnifierView) {
        _magnifierView = [[XPMagnifierView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        [[UIApplication sharedApplication].keyWindow addSubview:_magnifierView];
    }
    return _magnifierView;
}

- (NSMutableArray *)arrRunModels {
    if (!_arrRunModels) {
        _arrRunModels = [NSMutableArray array];
    }
    if (!_arrLineModels) {
        _arrLineModels = [NSMutableArray array];
    }
    
    if (_arrRunModels.count == 0) {
        [XPCoreTextAlgorithm caculateCoreText:self ctFrame:self.ctFrame lineModels:_arrLineModels runModels:_arrRunModels];
    }
    
    return _arrRunModels;
}

- (NSMutableArray *)arrLinkModels {
    if (!_arrLinkModels) {
        _arrLinkModels = [NSMutableArray array];
    }
    if (_arrLinkModels.count == 0) {
        [XPCoreTextAlgorithm caculateCoreText:self text:self.text runModels:self.arrRunModels linkModels:_arrLinkModels];
    }
    return _arrLinkModels;
}

- (NSString *)selectText {
    NSString *text = nil;
    XPCTRunModel *startRunModel = self.startRunModel;
    XPCTRunModel *endRunModel = self.endRunModel;

    if (startRunModel && startRunModel.range.location != NSNotFound &&
        endRunModel && endRunModel.range.location != NSNotFound && self.text) {
        CFIndex location = startRunModel.range.location;
        CFIndex length = endRunModel.range.location - startRunModel.range.location + endRunModel.range.length;
        
        text = [self.text substringWithRange:NSMakeRange(location, length)];
    }
    return text;
}

@end
