//
//  Location.m
//  geoBBmobile
//
//  Created by Danilo Amaral Ribeiro on 6/25/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Location.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>

@interface Location() {
  NSArray *_arr;
}
@end

@implementation Location

RCT_EXPORT_MODULE()

- (instancetype)init
{
  self = [super init];
  locationManager = [[CLLocationManager alloc]init]; // inicializando locationManager
  locationManager.delegate = self; // delegando locationManager para a classe vigente.
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager requestWhenInUseAuthorization];
  [locationManager startUpdatingLocation];  //updates de local
  
  return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  
  
  //chamar funcao para checkin, passando localizacao atual e array de agencias
  
  
//  for (NSDictionary *dic in _arr) {
//    id latitude = [dic valueForKey:@"latitude"];
//    id longitude = [dic valueForKey:@"longitude"];
//    id num = [dic valueForKey:@"id"];
//    if (latitude && longitude) {
//      double lat = [latitude doubleValue];
//      double lng = [longitude doubleValue];
//      if ((location.coordinate.latitude <= lat + 10 ||
//           location.coordinate.latitude >= lat - 10) &&
//          (location.coordinate.longitude <= lng + 10 ||
//           location.coordinate.longitude >= lng - 10)) {
//            NSLog(@"CHECK IN!!!!!!!");
//
//            CLLocationCoordinate2D geofenceRegionCenter = CLLocationCoordinate2DMake(lat, lng);
//            CLCircularRegion *geofenceRegion =[[CLCircularRegion alloc] initWithCenter:geofenceRegionCenter radius:200 identifier:num];
//
//            geofenceRegion.notifyOnEntry = true;
//
//            [locationManager startMonitoringForRegion:geofenceRegion];
//          }
//    }
  
//  }
//  [self.bridge.eventDispatcher sendDeviceEventWithName:@"locationUpdated" body:locationEvent];
}

- (void) loadAgencias:(NSArray *) locations{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"agencias.plist"];
    //NSLog(@"%@", plistPath);
    _arr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", _arr);
  
    //pegando latitude/longitude atual
    CLLocation *location = [locations lastObject];
    NSDictionary *locationEvent = @{
                                    @"coords": @{
                                        @"latitude": @(location.coordinate.latitude),
                                        @"longitude": @(location.coordinate.longitude),
                                        }
                                    };
  
    NSLog(@" lat: %f, long: %f", location.coordinate.latitude, location.coordinate.longitude);
  
  
  
  
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
 // NSLog(@"MapViewController - didEnterRegion");
  //NSLog(@"MVC - didEnterRegion - region.radius = %f", region.);
//  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"entered region..." message:@"You have Entered the Location." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles: nil];
//  alert.tag = 2;
//  [alert show];
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//  CLLocation *crnLoc = [locations lastObject];
//  latitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
//  //longitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
//  NSLog(latitude);
//}


//- (NSDictionary *) constantsToExport {
//  return @{@"greeting": @"jdiasjdaisdjai"};
//}

//RCT_EXPORT_METHOD(squareMe:(int)number:(RCTResponseSenderBlock)callback){
//  callback(@[[NSNull null], [NSNumber numberWithInt:(number*number)]]);
//}

RCT_EXPORT_METHOD(setAgencias:(NSArray *)array) { //recebendo JSON
  _arr = array;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"agencias.plist"];
  NSLog(@"%@", plistPath);
  [array writeToFile:plistPath atomically: YES];
  
  //criando geofences
  for (NSDictionary *dic in _arr) {
    id latitude = [dic valueForKey:@"latitude"];
    id longitude = [dic valueForKey:@"longitude"];
    id num = [dic valueForKey:@"id"];
    if (latitude && longitude) {
      double lat = [latitude doubleValue];
      double lng = [longitude doubleValue];
      CLLocationCoordinate2D geofenceRegionCenter = CLLocationCoordinate2DMake(lat, lng);
      CLCircularRegion *geofenceRegion =[[CLCircularRegion alloc] initWithCenter:geofenceRegionCenter radius:200 identifier:num];
      geofenceRegion.notifyOnEntry = true;
      [locationManager startMonitoringForRegion:geofenceRegion];
    }
  }
}





@end



