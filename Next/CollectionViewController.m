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


static int const NumberOfRequestedObjects = 10;

@interface CollectionViewController ()

@property (nonatomic, strong) Weather *currentWeather;
@property (nonatomic, strong) NSMutableArray *fourSquareObjects;


@end

@implementation CollectionViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
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
    
    // TODO: format rating text/ no reating placeholder, calculate distance,
    
    cell.nameLabel.text = currentObject.name;
    cell.shortDescriptionLabel.text = currentObject.shortDescription;
    cell.ratingLabel.text = [currentObject.rating stringValue];
    cell.distanceLabel.text = @"X minutes";
    cell.weatherDescriptionLabel.text = self.currentWeather.detailDescription;
    
    
    [cell.backgroundImageView setImageWithURL:currentObject.photoUrl];
    
    return cell;
}


#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row <= [self.fourSquareObjects count] -1 ) {
//        
//        [self loadFoursquareObject];
//        NSLog(@"Loading new objects!!!!!!");
//        
//    }

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
