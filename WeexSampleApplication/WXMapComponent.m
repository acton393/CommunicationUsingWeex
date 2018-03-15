//
//  WXMapComponent.m
//  WeexSampleApplication
//
//  Created by zifan.zx on 2018/3/13.
//  Copyright © 2018年 zifan.zx. All rights reserved.
//

#import "WXMapComponent.h"
#import <WeexSDK/WeexSDK.h>

@interface WXMapComponent()
@property(nonatomic, assign)BOOL showsTraffic;
@property(nonatomic, assign)BOOL mapLoaded;
@end

@implementation WXMapComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    if(self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        
        if (attributes[@"showsTraffic"]) {
            _showsTraffic = [WXConvert BOOL: attributes[@"showsTraffic"]];
        }
    }
    return self;
}

- (UIView *)loadView
{
    return [MKMapView new];
}

- (void)viewDidLoad
{
    MKMapView *mapView = ((MKMapView*)self.view);
    mapView.showsTraffic = _showsTraffic;
    mapView.delegate = self;
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"mapLoaded"]) {
        _mapLoaded = YES;
    }
}

- (void)removeEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"mapLoaded"]) {
        _mapLoaded = NO;
    }
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"showsTraffic"]) {
        _showsTraffic = [WXConvert BOOL: attributes[@"showsTraffic"]];
        ((MKMapView*)self.view).showsTraffic = _showsTraffic;
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if (_mapLoaded) {
        [self fireEvent:@"mapLoaded" params:@{@"customKey":@"customValue"} domChanges:nil];
    }
}

@end
