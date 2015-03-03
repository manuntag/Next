//
//  CollectionViewController.m
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "LocationManager.h"
#import "WeatherAPIMannager.h"
#import "Weather.h"
#import "SugestionCalculator.h"
#import "Time.h"
#import "FourSquareAPIManager.h"
#import "FoursquareObject.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailViewController.h"
#import "ColorLibrary.h"



@interface CollectionViewController ()

@property (nonatomic, strong) Weather *currentWeather;
@property (nonatomic, strong) NSMutableArray *fourSquareObjects;
@property (nonatomic, strong) LocationManager * locationManager;
@end

@implementation CollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Data source
    self.fourSquareObjects = [NSMutableArray array];
    
    
    self.locationManager = [LocationManager sharedInstance];
    
    [self.locationManager startUpdatingLocation];

    
//    [[LocationManager sharedInstance] startUpdatingLocation];

    
    
    // TODO: we should make sure that locationManager object exist before we call weather api
    [[WeatherAPIMannager sharedInstance] getWheatherDescriptionForLocation:[LocationManager sharedInstance].currentLocation completion:^(Weather *weather) {
        
        self.currentWeather = weather;
        NSLog(@"New Weather: %@, description: %@", self.currentWeather.description , self.currentWeather.detailDescription);
        
        // test objects
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
    
        
        
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        [self loadFoursquareObject];
        
        
     
    }];
    
}

- (void)loadFoursquareObject
{
    SugestionCalculator * sugestionCalculator = [[SugestionCalculator alloc]init];
    NSString * partOfWeek = [Time partOfWeek];
    NSString * sectionOfDay = [Time sectionOfDay];
    
    [sugestionCalculator calculateReccomendationArray:partOfWeek sectionOfDay:sectionOfDay mainWeather:self.currentWeather.mainDescription];
    NSString *randomReccomendation = [sugestionCalculator randomRecomendedSection];
    NSLog(@"Calculated randomReccomendation: %@", randomReccomendation);
    NSLog(@"Weather: %@", self.currentWeather.mainDescription);


    //add foursquare object to data source array
    [[FourSquareAPIManager sharedInstance] getFoursquareObjectWithLocation:[LocationManager sharedInstance].currentLocation randomReccomendation:randomReccomendation completion:^(FoursquareObject *fourSquareObject) {
        
        if ([self isFoursquareobjectUnique:fourSquareObject]) {
            [self.fourSquareObjects addObject:fourSquareObject];
            NSLog(@"Foursquare objetcs array: %@", self.fourSquareObjects);
            NSLog(@"New foursquare objetc name: %@", fourSquareObject.name);
            [self.collectionView reloadData];
        }
    }];

}


- (BOOL)isFoursquareobjectUnique:(FoursquareObject *)newObject
{
    for (FoursquareObject *object in self.fourSquareObjects) {
        if ([object.name isEqualToString:newObject.name]) {
            return NO;
        }
    }
    
    return YES;
}



#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.fourSquareObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    FoursquareObject *currentObject = self.fourSquareObjects[indexPath.row];
    
    // TODO: format rating text/ no reating placeholder, calculate distance,

    
    cell.nameLabel.text = currentObject.name;
    cell.shortDescriptionLabel.text = currentObject.shortDescription;
    
    
    if ([currentObject.rating floatValue]==0.0) {
     cell.ratingLabel.text = @"N/A";
        
    }else {
    cell.ratingLabel.text = [NSString  stringWithFormat:@"%.1f", [currentObject.rating floatValue]];
    }
    
    CLLocation * foursquareObjectLocation = [[CLLocation alloc]initWithLatitude:[currentObject.lat doubleValue]longitude:[currentObject.lon doubleValue]];

//    float lat = [LocationManager sharedInstance].currentLocation.coordinate.latitude;
//    float lon = [LocationManager sharedInstance].currentLocation.coordinate.longitude;
    
    float lat = self.locationManager.currentLocation.coordinate.latitude;
    float lon = self.locationManager.currentLocation.coordinate.longitude;
    
    NSLog(@"\n test lat:%f \n test lon:%f ", lat, lon);
    
    CLLocation * currentLocationCoordinate = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    
    CLLocationDistance dist = [foursquareObjectLocation distanceFromLocation:currentLocationCoordinate];
    
    // "minutes away calculation"
    
    float minsAway = dist/50;
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.f minutes away", minsAway];
    cell.weatherDescriptionLabel.text = self.currentWeather.detailDescription;
    
    // 50m /min
    
    [cell setUpColor];
    [cell cutomizeRatingLabel];
    
    [cell.backgroundImageView setImageWithURL:currentObject.photoUrl];
    
    return cell;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        FoursquareObject *detailFoursquareObject = self.fourSquareObjects[indexPath.row];
        [[segue destinationViewController] setDetailFoursquareObject:detailFoursquareObject];
    }
}




@end
