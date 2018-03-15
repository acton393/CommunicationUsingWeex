//
//  WXCustomEventModule.m
//  WeexSampleApplication
//
//  Created by zifan.zx on 2018/3/13.
//  Copyright © 2018年 zifan.zx. All rights reserved.
//

#import "WXCustomEventModule.h"
#import "WeexDemoViewController.h"

@implementation WXCustomEventModule

@synthesize weexInstance;

#pragma GCC diagnostic ignored "-Wundeclared-selector"
WX_EXPORT_METHOD(@selector(showParams:callback:)) // expose method to JavaScript

- (void)showParams:(NSString*)inputParam callback:(WXModuleKeepAliveCallback)callback
{
    if (!inputParam){
        return;
    }
    if (callback) {
        callback(@{@"message":@{@"raw":inputParam,@"filter":inputParam.uppercaseString}}, NO);
    }
}

- (void)openURL:(NSString*)url
{
    if (!url) {
        return;
    }
    
    WeexDemoViewController * viewController = [WeexDemoViewController new];
    viewController.url = [NSURL URLWithString:url];
    [[weexInstance.viewController navigationController] pushViewController:viewController animated:YES];
    
}

@end
