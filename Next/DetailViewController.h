//
//  DetailViewController.h
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "ColorLibrary.h"

@class FoursquareObject;


@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *fourSquareObjectMapView;
@property (strong, nonatomic) LocationManager * locationManager;
@property (strong, nonatomic) CLLocation * currentLocation;

@property (strong, nonatomic) FoursquareObject *detailFoursquareObject;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingHoursLabel;

@property (strong, nonatomic) IBOutlet UIView *directionsView;

@property (strong, nonatomic) IBOutlet UITextView *directionsTextView;

@property (strong, nonatomic) IBOutlet UIView *contactView;

@property (nonatomic, strong) NSString *allSteps;

@property (weak, nonatomic) IBOutlet UIImageView *directionArrowImageView;


- (IBAction)backButtonPressed:(id)sender;

@end
