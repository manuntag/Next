//
//  CollectionViewController.m
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CollectionViewCell.h"
#import "CollectionViewController.h"
#import "ColorLibrary.h"
#import "DetailViewController.h"
#import "FourSquareAPIManager.h"
#import "FoursquareObject.h"
#import "LocationManager.h"
#import "SugestionCalculator.h"
#import "Time.h"
#import "FourSquareAPIManager.h"
#import "FoursquareObject.h"
#import "CustomFlowLayout.h"
#import "Weather.h"
#import "CircleAnimation.h"
#import "WeatherAPIMannager.h"

static NSInteger const NumberOfRequestedObjects = 10;

@interface CollectionViewController ()

@property (nonatomic, strong) NSCache *colorCache;

@property (nonatomic, strong) Weather *currentWeather;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allFoursquareObjects; // for duplicity check


@end

@implementation CollectionViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.colorCache = [[NSCache alloc] init];
    
    self.dataSource = [NSMutableArray array];
    self.allFoursquareObjects = [NSMutableArray array];
    
    // check if we are getting location, so we can fetch weather and foursquare objects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchData)
                                                 name:@"didUpdateLocation"
                                               object:[LocationManager sharedInstance]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    UISwipeGestureRecognizer *swipeToDelete = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeToDelete)];
    swipeToDelete.direction =UISwipeGestureRecognizerDirectionUp;
    [self.collectionView addGestureRecognizer:swipeToDelete];
    
    // custom layout for collection view cells
    CustomFlowLayout *flowLayout = (CustomFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(320, 568);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    [self loadSplashScreen];

}


#pragma mark - Helper methods

- (void)handleSwipeToDelete {
    
    // delay collectionview default animation
    [self performSelector:@selector(deleteFoursquareObject) withObject:self afterDelay:1.0];
    
}


- (void)loadSplashScreen {
    
    UIView *splashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+30)];
    
    splashView.backgroundColor = [UIColor whiteColor];
    UIView *circle = [CircleAnimation makeCircleWithCentreX:self.view.bounds.size.width/2 centreY:self.view.bounds.size.height/2];
    [splashView addSubview:circle];
    
    UILabel *nextLabel = [[UILabel alloc]initWithFrame:self.view.bounds];
    nextLabel.textColor = [UIColor whiteColor];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    nextLabel.text = @"Next";
    nextLabel.alpha = 0.0;
    UIFont *nextFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:75];
    [nextLabel setFont:nextFont];
    [splashView addSubview:nextLabel];
    
    [UIView animateWithDuration:3.0 animations:^{
        nextLabel.alpha = 1;
    }];
    
    [self.view addSubview:splashView];
    
    
    [UIView animateWithDuration:3 delay:6 options:UIViewAnimationOptionTransitionNone animations:^{
        splashView.alpha =0;
        
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    } ];

   
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

- (void)fetchData
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[WeatherAPIMannager sharedInstance] getWheatherDescriptionForLocation:[LocationManager sharedInstance].currentLocation completion:^(Weather *weather) {
        self.currentWeather = weather;
        for (NSInteger i = 1; i <= NumberOfRequestedObjects; i++) {
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
    [self loadFoursquareObjectForRandomRecomendation:randomReccomendation];
}

- (void)loadFoursquareObjectForRandomRecomendation:(NSString *)randomReccomendation
{
    // Add Foursquare object to data source array
    [[FourSquareAPIManager sharedInstance] getFoursquareObjectWithLocation:[LocationManager sharedInstance].currentLocation randomReccomendation:randomReccomendation completion:^(FoursquareObject *fourSquareObject) {
        NSAssert([NSThread isMainThread], @"Not on the main thread");
        
        if ([self isFoursquareObjectUnique:fourSquareObject]) {
            [self.dataSource addObject:fourSquareObject];
            [self.allFoursquareObjects addObject:fourSquareObject];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(reloadData) withObject:nil afterDelay:1];
        }
    }];
}

- (void)reloadData {

    [self.collectionView reloadData];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, @(self.dataSource.count));
}


- (BOOL)isFoursquareObjectUnique:(FoursquareObject *)newObject
{
    for (FoursquareObject *object in self.allFoursquareObjects) {
        if ([object.name isEqualToString:newObject.name]) {
            if (self.dataSource.count < NumberOfRequestedObjects) {
                NSAssert([NSThread isMainThread], @"Not on the main thread");
                [self generateRandomRecomendation];
            }
            
            NSLog(@"Duplicate Object");
            return NO;
        }
    }
    return YES;
}


- (CGFloat)calculateWalkingTime:(FoursquareObject*)foursquareObject {
    
    CGFloat minsAway;
    
    // "minutes away calculation" : calculation based on average human walking at 50m /min
    
    CGFloat lat = [LocationManager sharedInstance].currentLocation.coordinate.latitude;
    CGFloat lon = [LocationManager sharedInstance].currentLocation.coordinate.longitude;
    
    CLLocation *currentLocationCoordinate = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    
    CLLocation *foursquareObjectLocation = [[CLLocation alloc]initWithLatitude:[foursquareObject.lat doubleValue]longitude:[foursquareObject.lon doubleValue]];
    
    CLLocationDistance dist = [foursquareObjectLocation distanceFromLocation:currentLocationCoordinate];
    
    // "minutes away calculation" : calculation based on average human walking at 50m /min
    return minsAway = dist/50;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.colorCache removeAllObjects];
    [self.collectionView reloadData];
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
    
    if ([currentObject.rating floatValue] == 0.0) {
        cell.ratingLabel.text = @"N/A";
        
    } else {
        cell.ratingLabel.text = [NSString  stringWithFormat:@"%.1f", [currentObject.rating floatValue]];
    }
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.f minute walk", [self calculateWalkingTime:currentObject]];
    cell.weatherDescriptionLabel.text = self.currentWeather.detailDescription;
    
    [cell.backgroundImageView setImageWithURL:currentObject.photoUrl];

    [cell cutomizeRatingLabel];
    
    UIColor *color = [self.colorCache objectForKey:@(indexPath.item)];
    if (color) {
        cell.imageFilterView.backgroundColor = color;
        
    } else {
        color = [ColorLibrary randomColor];
        cell.imageFilterView.backgroundColor = color;
        [self.colorCache setObject:color forKey:@(indexPath.item)];
    }
    
    return cell;
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
