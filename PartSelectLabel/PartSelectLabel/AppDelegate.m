//
//  AppDelegate.m
//  PartSelectLabel
//
//  Created by 王飞 on 2019/1/15.
//  Copyright © 2019 wang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)forTest {
    NSString *text = @"iOS增强服务号消息(www.baidu.com)定制样式(18910434126)支持功能(wangfei0206wl@163.com)实现，以前同事0554-5678257已实现此功能。";
    NSError *error = nil;
    NSTextCheckingTypes types = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:types error:&error];
    NSArray<NSTextCheckingResult *> *arrMatches = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *result in arrMatches) {
        switch (result.resultType) {
            case NSTextCheckingTypeLink: {
                NSString *url = [result.URL absoluteString];
                NSLog(@"-----url:%@, range: (%lu, %lu)", url, (unsigned long)result.range.location, (unsigned long)result.range.length);
            }
                break;
            case NSTextCheckingTypePhoneNumber: {
                NSString *phone = result.phoneNumber;
                NSLog(@"-----phone:%@, range: (%lu, %lu)", phone, (unsigned long)result.range.location, (unsigned long)result.range.length);
            }
                break;
            default:
                break;
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self forTest];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
