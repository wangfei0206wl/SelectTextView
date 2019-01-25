//
//  ViewController.m
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/15.
//  Copyright © 2019 wang. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "UIPartSelectLabel.h"
#import "XPCoreTextAlgorithm.h"
#import "UIPartSelectLabelView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self partSelectLabelTest];
    [self partSelectLabelViewTest];
}

- (void)partSelectLabelTest {
    // 基于label
#if 0
    // 普通文本
    NSString *text = [self testString];
    CGSize size = [UIPartSelectLabel caculateSize:text font:[UIFont systemFontOfSize:16] restrictSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 30, CGFLOAT_MAX)];
    UIPartSelectLabel *label = [[UIPartSelectLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = [self testString];
    [label setMenuItems:[self selectTextContrainMenus] responseObj:self];
    [self.view addSubview:label];
#else
    // 富文本
    NSAttributedString *text = [self attributedString];
    CGSize size = [UIPartSelectLabel caculateSize:text restrictSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 30, CGFLOAT_MAX)];
    UIPartSelectLabel *label = [[UIPartSelectLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
    label.center = self.view.center;
    label.numberOfLines = 0;
    label.attributedText = text;
    [label setMenuItems:[self selectTextContrainMenus] responseObj:self];
    [self.view addSubview:label];
#endif
}

- (void)partSelectLabelViewTest {
    // 基于view
#if 0
    // 普通文本
    NSString *text = [self testString];
    CGSize size = [UIPartSelectLabelView caculateSize:text font:[UIFont systemFontOfSize:16] restrictSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 30, CGFLOAT_MAX)];
    UIPartSelectLabelView *label = [[UIPartSelectLabelView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.text = [self testString];
    [label setMenuItems:[self selectTextContrainMenus] responseObj:self];
    [self.view addSubview:label];
#else
    // 富文本
    NSAttributedString *text = [self attributedString];
    CGSize size = [UIPartSelectLabelView caculateSize:text restrictSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 30, CGFLOAT_MAX)];
    UIPartSelectLabelView *label = [[UIPartSelectLabelView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.attributedText = [self attributedString];
    [label setMenuItems:[self selectTextContrainMenus] responseObj:self];
    [self.view addSubview:label];
#endif
}

- (NSArray<UIMenuItem *> *)selectTextContrainMenus {
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")];
    UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:NSSelectorFromString(@"zhuanfaText:")];
    
    return @[copyItem, forwardItem];
}

- (void)copyText:(id)sender {
    NSString *selectText = sender;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = selectText;
}

- (void)zhuanfaText:(id)sender {
    
}

#pragma mark - XPSelectTextContainerViewDelegate

//- (void)selectTextContainerView:(XPSelectTextContainerView *)view didClickLink:(XPCTLinkModel *)model {
//    // 根据link类型进行处理
//}

- (NSAttributedString *)attributedString {
    NSMutableDictionary *dicAttributes = [NSMutableDictionary dictionary];
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:16];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [dicAttributes setValue:(__bridge id)fontRef forKey:NSFontAttributeName];
    CFRelease(fontRef);
    // 颜色
    [dicAttributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    // 行间距
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [dicAttributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[self testString] attributes:dicAttributes];
    font = [UIFont systemFontOfSize:28];
    fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attrString addAttribute:NSFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(20, 12)];
    CFRelease(fontRef);
    
    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:16];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(40, 12)];
    
    return attrString;
}

- (NSString *)testString {
    return @"春节，即农历新年，test logging，一年之岁首(18910434126)，传统上的“年节”。俗称新春、新岁、新年、新禧、年禧、大年等，口头上又称度岁、庆岁、过年、过大年。春节历史悠久，由上古时代岁首祈年祭祀演变而来。hello world(www.baidu.com)，万物本乎天、人本乎祖，祈年祭祀、敬天法祖，报本反始也。春节的起源蕴含着深邃的文化内涵，在传承发展中承载了丰厚的历史文化(wangfei0206wl@163.com)。在春节期间，全国各地均有举行各种庆贺新春活动，热闹喜庆气氛洋溢(0554-5678298)；这些活动均以除旧布新、迎禧接福、拜神祭祖、祈求丰年为主要内容，形式丰富多彩，带有浓郁的各地域特色。";
}

@end
