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


static int const NumberOfRequestedObjects = 10;

@interface CollectionViewController ()

@property (nonatomic, strong) Weather *currentWeather;
@property (nonatomic, strong) NSMutableArray *fourSquareObjects;


@end

@implementation CollectionViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Data source
    self.fourSquareObjects = [NSMutableArray array];
    
    [[LocationManager sharedInstance] startUpdatingLocation];
    
    
    // check if we are getting location, so we can fetch weather and foursquare objects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchData)
                                                 name:@"didUpdateLocation"
                                               object:[LocationManager sharedInstance]];
}


-(void)fetchData
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];


    [[WeatherAPIMannager sharedInstance] getWheatherDescriptionForLocation:[LocationManager sharedInstance].currentLocation completion:^(Weather *weather) {
        
        self.currentWeather = weather;
        NSLog(@"New Weather: %@, description: %@", self.currentWeather.description , self.currentWeather.detailDescription);
        
        
        for (int i = 1; i <= NumberOfRequestedObjects; i++) {
            [self generateRandomRecomendation];
        }
        
    }];
}


- (void)generateRandomRecomendation
{
    SugestionCalculator * sugestionCalculator = [[SugestionCalculator alloc]init];
    NSString * partOfWeek = [Time partOfWeek];
    NSString * sectionOfDay = [Time sectionOfDay];
    
    [sugestionCalculator calculateReccomendationArray:partOfWeek sectionOfDay:sectionOfDay mainWeather:self.currentWeather.mainDescription];
    NSString *randomReccomendation = [sugestionCalculator randomRecomendedSection];
    NSLog(@"Calculated randomReccomendation: %@", randomReccomendation);
    
    [self loadFoursquareObjectForRandomRecomendation:randomReccomendation];
    
    
}

- (void)loadFoursquareObjectForRandomRecomendation:(NSString *)randomReccomendation
{

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
            NSLog(@"Duplicate Object");
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
    
    cell.nameLabel.text = currentObject.name;
    cell.shortDescriptionLabel.text = currentObject.shortDescription;
    
    
    if ([currentObject.rating floatValue]==0.0) {
     cell.ratingLabel.text = @"N/A";
        
    }else {
    cell.ratingLabel.text = [NSString  stringWithFormat:@"%.1f", [currentObject.rating floatValue]];
    }
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.f minute walk", [self calculateWalkingTime:currentObject]];
    cell.weatherDescriptionLabel.text = self.currentWeather.detailDescription;
    
    [cell setUpColor];
    [cell cutomizeRatingLabel];
    
    [cell.backgroundImageView setImageWithURL:currentObject.photoUrl];
    
    return cell;
}



-(float)calculateWalkingTime:(FoursquareObject*)foursquareObject {
    
    float minsAway;

    // "minutes away calculation" : calculation based on average human walking at 50m /min
    
    float lat = [LocationManager sharedInstance].currentLocation.coordinate.latitude;
    float lon = [LocationManager sharedInstance].currentLocation.coordinate.longitude;
    
    CLLocation * currentLocationCoordinate = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    
    CLLocation * foursquareObjectLocation = [[CLLocation alloc]initWithLatitude:[foursquareObject.lat doubleValue]longitude:[foursquareObject.lon doubleValue]];
    
    CLLocationDistance dist = [foursquareObjectLocation distanceFromLocation:currentLocationCoordinate];
    
    return minsAway = dist/50;
    
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
