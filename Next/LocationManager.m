//
//  LocationManager.m
//  Next
//
//  Created by JoLi on 2015-02-24.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+ (LocationManager *)sharedInstance
{
    static LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        if([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            //[self startUpdatingLocation];
            
        } else {
            //TODO: ask David to fix all alert mesages text, also in info.plist
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services disabled"
                                                                message:@"Please turn on location services in iPhone settings"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            
            NSLog(@"Location services turned of by user");
        }
    }
    return self;
}



- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    
}



- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}




#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateLocation" object:self];
    
}



- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location access denied"
                                                                                 message:@"Please open this app's settings and allow location access 'While Using the app'."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                                             }];
        
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                               }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:settingsAction];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        [self stopUpdatingLocation];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location retreiving error"
                                                                                 message:@"Please check your network connection or that you are not in airplane mode!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
        
        [alertController addAction:retryAction];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

    }
}




@end
