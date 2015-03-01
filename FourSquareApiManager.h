//
//  FourSquareApiManager.h
//  Next
//
//  Created by David Manuntag on 2015-02-26.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//
#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@class FoursquareObject;

@interface FourSquareAPIManager : AFHTTPSessionManager

@property (nonatomic, strong) NSDictionary * dictionary;

+ (FourSquareAPIManager*)sharedInstance;

- (void)getFoursquareObjectWithLocation:(CLLocation *)location randomReccomendation:(NSString*)randomReccomendation completion:(void (^)(FoursquareObject *))completion;


@end
