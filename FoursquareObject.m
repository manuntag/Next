//
//  FoursquareObject.m
//  Next
//
//  Created by David Manuntag on 2015-02-26.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "FoursquareObject.h"

@implementation FoursquareObject


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    
    if (self = [super init]) {
        
        _name = dictionary[@"venue"][@"name"];
        _lat = dictionary[@"venue"][@"location"][@"lat"];
        _lon = dictionary[@"venue"][@"location"][@"lng"];
        
        //short description
        NSArray * shortDescriptionArray = dictionary[@"venue"][@"categories"];
        NSDictionary *shortDescriptionDictionary= [shortDescriptionArray firstObject];
        _shortDescription = shortDescriptionDictionary[@"shortName"];
    
        _rating = dictionary[@"venue"][@"rating"];
        _openingHours = dictionary[@"venue"][@"hours"][@"status"];
        
        //tip
        NSArray *tipArray = dictionary[@"tips"];
        NSDictionary *tipDictionary = [tipArray firstObject];
        _tip = tipDictionary[@"text"];
        
        //photo
        NSArray * photosGroupArray =dictionary[@"venue"][@"photos"][@"groups"];
        NSDictionary * photosItemsDictionary = [photosGroupArray firstObject];
        NSArray * photoItemsArray =photosItemsDictionary[@"items"];
        
        NSDictionary * photoItemDictionary = [photoItemsArray firstObject];
        
        NSString * photoPrefix = photoItemDictionary[@"prefix"];
        NSString * photoSuffix = photoItemDictionary[@"suffix"];
        NSString * photoResolution = @"300x300";
        NSString * photoUrlString = [NSString stringWithFormat:@"%@%@%@", photoPrefix,photoResolution,photoSuffix];
        _photoUrl = [NSURL URLWithString:photoUrlString];
         
        _phoneNumber = dictionary[@"venue"][@"contact"][@"phone"]; //formattedPhone ??
        _address = dictionary[@"venue"][@"location"][@"address"]; 
        
    }
    
    return self;
}


@end
