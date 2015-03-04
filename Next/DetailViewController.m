//
//  DetailViewController.m
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "DetailViewController.h"
#import "FoursquareObject.h"
#import "HexColor.h"


@interface DetailViewController ()


@end

@implementation DetailViewController

MKRoute * routeDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    
    self.fourSquareObjectMapView.delegate = self;
    self.fourSquareObjectMapView.showsUserLocation = true;
    
    [self addDirectionsToFourSquareObject];
    
    [self setUpGestureRecognizers];
   
    self.directionsTextView.text = self.allSteps;
    
    self.view.layer.cornerRadius = 10;
    self.view.clipsToBounds = YES;
    
    self.directionsView.layer.cornerRadius = 10;
   
    
    
}


-(void)setUpGestureRecognizers {
    
    UISwipeGestureRecognizer * swipeUpToRevealMap = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slideUpToRevealMap:)];
    swipeUpToRevealMap.direction =UISwipeGestureRecognizerDirectionUp;
    [self.directionsView addGestureRecognizer:swipeUpToRevealMap];
    
    
    UISwipeGestureRecognizer *swipeDownToHideMap = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDownToHideMapAction:)];
    swipeDownToHideMap.direction=UISwipeGestureRecognizerDirectionDown;
    [self.directionsView addGestureRecognizer:swipeDownToHideMap];

    UISwipeGestureRecognizer * swipeDownToDismissModal = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDownToDismissModal:)];
    swipeDownToDismissModal.direction =UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownToDismissModal];
    
    UISwipeGestureRecognizer * swipeRightToPhone = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(phoneContact:)];
    swipeRightToPhone.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contactView addGestureRecognizer:swipeRightToPhone];
    
    
    
    
    
}



-(void)phoneContact:(UIGestureRecognizer*)gestureRecognizer {
    
    
//    NSString * phoneNumber =  self.detailFoursquareObject.phoneNumber;
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:7787897171"]];
    
    
    
}


-(void)swipeDownToDismissModal:(UIGestureRecognizer*)gestureRecognizer {
    
  [UIView animateWithDuration:1.0 animations:^{
      
      self.view.frame = CGRectOffset(self.view.frame, 0, 250);
      
  }];
    
    
    [self performSelector:@selector(dismissModalView) withObject:self afterDelay:1.0];
    
}

-(void)dismissModalView {
    
  [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(void)swipeDownToHideMapAction:(UIGestureRecognizer*)gestureRecognizer {
    
    [UIView animateWithDuration:1.0 animations:^{
        
        if (self.directionsView.frame.origin.y<=520) {
            
             self.directionsView.frame = CGRectOffset(self.directionsView.frame, 0, 200);

        }
        
        
    }];
}


-(void)slideUpToRevealMap:(UIGestureRecognizer*)gestureRecognizer {
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.directionsTextView.text = self.allSteps;
        
        if (self.directionsView.frame.origin.y>=415) {
        
            self.directionsView.frame = CGRectOffset(self.directionsView.frame, 0, -200);
            
        }
        
    }];
    

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if (!self.currentLocation) {
        
        self.currentLocation = userLocation.location;
        
        MKCoordinateRegion region;
        region.center = mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.015, 0.015);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        
        MKPointAnnotation * marker = [[MKPointAnnotation alloc]init];
        CLLocationCoordinate2D foursquareObject;

        foursquareObject.latitude =[self.detailFoursquareObject.lat doubleValue];
        foursquareObject.longitude = [self.detailFoursquareObject.lon doubleValue];
        marker.coordinate = foursquareObject;
        marker.title = self.detailFoursquareObject.name;
        
        [self.fourSquareObjectMapView addAnnotation:marker];
    

    }

}


-(void)addDirectionsToFourSquareObject {
    
    CLLocationCoordinate2D destinationCoordinates =  CLLocationCoordinate2DMake([self.detailFoursquareObject.lat doubleValue], [self.detailFoursquareObject.lon doubleValue]);
    
    MKPlacemark * fourSquareObjectplaceMark = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinates addressDictionary:nil];
    
    MKDirectionsRequest * directionsRequest = [[MKDirectionsRequest alloc]init];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc]initWithPlacemark:fourSquareObjectplaceMark]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    
    MKDirections * directions = [[MKDirections alloc]initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        
        if (error) {
            
            NSLog(@"Error %@", error.description);
            
        }else {
            
            routeDetails = response.routes.lastObject;
            [self.fourSquareObjectMapView addOverlay:routeDetails.polyline];
            NSLog(@"\n%f", routeDetails.distance);
            
            self.allSteps = @"";
            for (NSInteger i = 0; i < routeDetails.steps.count; i++) {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                
                NSLog(@"\n\n%@", self.allSteps);
                
            }
            
        }
        
    }];

}


- (void)setDetailFoursquareObject:(FoursquareObject *)detailFoursquareObject
{
    if (_detailFoursquareObject != detailFoursquareObject) {
        _detailFoursquareObject = detailFoursquareObject;
        
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailFoursquareObject) {
        self.tipLabel.text = self.detailFoursquareObject.tip;
        self.openingHoursLabel.text = self.detailFoursquareObject.openingHours;
    }
}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.alpha = 0.7;
    renderer.lineWidth = 4.0;
    
    return renderer;
}



- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
