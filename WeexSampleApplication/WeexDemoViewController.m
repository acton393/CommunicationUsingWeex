//
//  ViewController.m
//  WeexSampleApplication
//
//  Created by zifan.zx on 2018/3/13.
//  Copyright © 2018年 zifan.zx. All rights reserved.
//

#import "WeexDemoViewController.h"
#import <WeexSDK/WeexSDK.h>
#import <AudioToolbox/AudioToolbox.h>

@interface WeexDemoViewController ()
@property (nonatomic, strong)WXSDKInstance *sdkInstance;
@property (nonatomic, strong)UIView * wxRootView;
@end

@implementation WeexDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _sdkInstance = [WXSDKInstance new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self render];
}

- (void)dealloc {
    [_sdkInstance destroyInstance];
    _sdkInstance = nil;
}

- (void)render
{
    _sdkInstance.frame = self.view.frame;
    _sdkInstance.viewController = self;
    _sdkInstance.pageName = self.url.absoluteString;
    __weak typeof(self) weakSelf = self;
    _sdkInstance.onCreate = ^(UIView * weexRootView) {
        [weakSelf.wxRootView removeFromSuperview];
        weakSelf.wxRootView = weexRootView;
        [weakSelf.view addSubview:weexRootView];
    };
    [_sdkInstance renderWithURL:_url options:@{@"pageName":_url.absoluteString} data:nil];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_sdkInstance fireGlobalEvent:@"deviceBeganShake" params:@{@"eventName":@"deviceBeganShake",@"timestamp":@(event.timestamp)}];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [_sdkInstance fireGlobalEvent:@"deviceEndShake" params:@{@"eventName":@"deviceEndShake",@"timestamp":@(event.timestamp)}];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [_sdkInstance fireGlobalEvent:@"deviceCancelShake" params:@{@"eventName":@"deviceCancelShake",@"timestamp":@(event.timestamp)}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
