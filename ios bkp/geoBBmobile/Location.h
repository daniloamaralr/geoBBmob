//
//  Location.h
//  geoBBmobile
//
//  Created by Danilo Amaral Ribeiro on 6/25/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <RCTBridgeModule, CLLocationManagerDelegate> {
  
  NSString *latitude;
  NSString *longitude;
  CLLocationManager *locationManager;
  
}

@end
