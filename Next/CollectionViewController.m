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
#import "CustomFlowLayout.h"


static int const NumberOfRequestedObjects = 5;

@interface CollectionViewController ()

@property (nonatomic, strong) Weather *currentWeather;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allFoursquareObjects; // for duplicity check


@end

@implementation CollectionViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.dataSource = [NSMutableArray array];
    self.allFoursquareObjects = [NSMutableArray array];
    
    
    //[[LocationManager sharedInstance] startUpdatingLocation];
    
    
    // check if we are getting location, so we can fetch weather and foursquare objects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchData)
                                                 name:@"didUpdateLocation"
                                               object:[LocationManager sharedInstance]];
    

    
    
    UISwipeGestureRecognizer *swipeToDelete = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeToDelete)];
    swipeToDelete.direction =UISwipeGestureRecognizerDirectionUp;
    [self.collectionView addGestureRecognizer:swipeToDelete];
    
    
    CustomFlowLayout *flowLayout = (CustomFlowLayout *)self.collectionView.collectionViewLayout;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(320, 448);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    
}




- (void)handleSwipeToDelete {

    // delay collectionview default animation
    [self performSelector:@selector(deleteFoursquareObject) withObject:self afterDelay:1.0];
    

    
    
    
}


- (void)deleteFoursquareObject {
    NSArray *visibleItem = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = [visibleItem firstObject];
    
    NSInteger row = [indexPath row];
    
    [self.dataSource removeObjectAtIndex:row];
    
    NSArray *objectToDelete = @[indexPath];
    [self.collectionView deleteItemsAtIndexPaths:objectToDelete];
    
    [self generateRandomRecomendation];
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
            [self.dataSource addObject:fourSquareObject];
            [self.allFoursquareObjects addObject:fourSquareObject];
            NSLog(@"Foursquare objetcs array: %@", self.dataSource);
            NSLog(@"New foursquare objetc name: %@", fourSquareObject.name);

            [self.collectionView reloadData];
            
        }
    }];

}




- (BOOL)isFoursquareobjectUnique:(FoursquareObject *)newObject
{
    for (FoursquareObject *object in self.allFoursquareObjects) {
        if ([object.name isEqualToString:newObject.name]) {
            
            if (self.dataSource.count < NumberOfRequestedObjects) {
                [self generateRandomRecomendation];
            }
            
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

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    

    
    FoursquareObject *currentObject = self.dataSource[indexPath.row];
    
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
    
    float lat = [LocationManager sharedInstance].currentLocation.coordinate.latitude;
    float lon = [LocationManager sharedInstance].currentLocation.coordinate.longitude;
    
    CLLocation * currentLocationCoordinate = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    
    CLLocation * foursquareObjectLocation = [[CLLocation alloc]initWithLatitude:[foursquareObject.lat doubleValue]longitude:[foursquareObject.lon doubleValue]];
    
    CLLocationDistance dist = [foursquareObjectLocation distanceFromLocation:currentLocationCoordinate];
    
    // "minutes away calculation" : calculation based on average human walking at 50m /min
    return minsAway = dist/50;
    
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        FoursquareObject *detailFoursquareObject = self.dataSource[indexPath.row];
        [[segue destinationViewController] setDetailFoursquareObject:detailFoursquareObject];
    }
}




@end
