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


#import <React/RCTConvert.h>


@interface Location() {
  NSArray *_arr;
  NSArray *_dic;
  NSUserDefaults *defaults;
}
@end

@implementation Location

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

- (instancetype)init
{
  self = [super init];
  
  self.locationManager = [[CLLocationManager alloc]init]; // inicializando locationManager
  self.locationManager.delegate = self; // delegando locationManager para a classe vigente.
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  //[locationManager requestWhenInUseAuthorization];
  [self.locationManager requestAlwaysAuthorization];
  
  defaults = [NSUserDefaults standardUserDefaults];
  //UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
  //UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
  //[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
  
  
  
  //if it is iOS 8
//  @available(iOS: )
  if ([UIApplication respondsToSelector:@selector(registerUserNotificationSettings:)])
  {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  }
  else // if iOS 7
  {
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
  }
  
  return self;
}


//- (void) viewDidLoad{
//  defaults = [NSUserDefaults standardUserDefaults];
//  UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//  UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//  [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//  
//}

//  [self.bridge.eventDispatcher sendDeviceEventWithName:@"locationUpdated" body:locationEvent];

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  NSLog(@"MapViewController - didEnterRegion");
  NSLog(@"MVC - didEnterRegion - region.radius = %.2f", ((CLCircularRegion *)region).radius);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"entered region..." message:@"You have Entered the Location." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles: nil];
  alert.tag = 2;
  [alert show];
  
  [defaults setBool:YES forKey:@"notificationIsActive"];
  [defaults synchronize];
  
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  localNotification.alertBody = @"Enter region";
  localNotification.timeZone = [NSTimeZone defaultTimeZone];
  localNotification.soundName = UILocalNotificationDefaultSoundName;
  [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
  
  CLLocationCoordinate2D center = ((CLCircularRegion *)region).center;
  NSString *latitude = [NSString stringWithFormat:@"%f", center.latitude];
  NSString *longitude = [NSString stringWithFormat:@"%f", center.longitude];
  
  NSDictionary *payload = @{@"latitude": latitude, @"longitude": longitude};
  
  [self.bridge.eventDispatcher sendDeviceEventWithName:@"mov/geo/enterLocation" body:payload];
  
  
  //[self showLocalNotification:[NSString stringWithFormat:@"Enter Fence"] withDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  NSLog(@"MapViewController - didExitRegion");
  NSLog(@"MVC - didExitRegion - region.radius = %.2f", ((CLCircularRegion *)region).radius);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"exit region..." message:@"You have Exit the Location." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles: nil];
  alert.tag = 2;
  [alert show];
  
  [defaults setBool:YES forKey:@"notificationIsActive"];
  [defaults synchronize];
  
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  localNotification.alertBody = @"Exit region";
  localNotification.timeZone = [NSTimeZone defaultTimeZone];
  localNotification.soundName = UILocalNotificationDefaultSoundName;
  [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
  
  //[self.bridge.eventDispatcher sendDeviceEventWithName:@"CheckInExit" body:@"Saiu da Geofence"];
  
  //[self showLocalNotification:[NSString stringWithFormat:@"exit region"] withDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

//-(void)showLocalNotification:(NSString*)notificationBody withDate:(NSDate*)notificationDate
//{
//  UIApplication *app                = [UIApplication sharedApplication];
//  UILocalNotification *notification = [[UILocalNotification alloc] init];
//
//  notification.fireDate  = notificationDate;
//  notification.timeZone  = [NSTimeZone defaultTimeZone];
//  notification.alertBody = notificationBody;
//  notification.soundName = UILocalNotificationDefaultSoundName;
//  //notification.applicationIconBadgeNumber = badgeCount;
//
//  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//  //[userInfo setValue:eventType forKey:@"event_type"];
//  [notification setUserInfo:userInfo];
//  [app scheduleLocalNotification:notification];
//}



//RCT_EXPORT_METHOD(squareMe:(int)number:(RCTResponseSenderBlock)callback){
//  callback(@[[NSNull null], [NSNumber numberWithInt:(number*number)]]);
//}

//- (NSArray<NSString*> *)supportedEvents {
//  return @[@"CheckInEnter", @"CheckInExit"];
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
    if (latitude && longitude && num) {
      double lat = [latitude doubleValue];
      double lng = [longitude doubleValue];
      int numR = [num intValue];
      CLLocationCoordinate2D geofenceRegionCenter = CLLocationCoordinate2DMake(lat, lng);
      NSString *name = [[NSString alloc] initWithFormat:@"Regiao %d", numR];
      CLCircularRegion *geofenceRegion =[[CLCircularRegion alloc] initWithCenter:geofenceRegionCenter radius:10.0 identifier:name];
      geofenceRegion.notifyOnExit = YES;
      geofenceRegion.notifyOnEntry = YES;
      [self.locationManager startMonitoringForRegion:geofenceRegion];
    }
  }
}

RCT_EXPORT_METHOD(setPlist){
  NSLog(@"Teste sayuri clenilton");
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"agencias.plist"];
  NSLog(@"%@",plistPath);
  _dic = [[NSArray alloc] initWithContentsOfFile:plistPath];
  
  
  //criando geofences
  for (NSDictionary *dic in _dic) {
    id latitude = [dic valueForKey:@"latitude"];
    id longitude = [dic valueForKey:@"longitude"];
    id num = [dic valueForKey:@"id"];
    if (latitude && longitude && num) {
      double lat = [latitude doubleValue];
      double lng = [longitude doubleValue];
      int numR = [num intValue];
      CLLocationCoordinate2D geofenceRegionCenter = CLLocationCoordinate2DMake(lat, lng);
      NSString *name = [[NSString alloc] initWithFormat:@"Regiao %d", numR];
      CLCircularRegion *geofenceRegion =[[CLCircularRegion alloc] initWithCenter:geofenceRegionCenter radius:10.0 identifier:name];
      geofenceRegion.notifyOnExit = YES;
      geofenceRegion.notifyOnEntry = YES;
      [self.locationManager startMonitoringForRegion:geofenceRegion];
    }
  }
  
  
  
  
}


@end



