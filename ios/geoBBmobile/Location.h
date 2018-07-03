//
//  Location.h
//  geoBBmobile
//
//  Created by Danilo Amaral Ribeiro on 6/25/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <CoreLocation/CoreLocation.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

@interface Location : NSObject <RCTBridgeModule, CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
