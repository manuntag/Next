//
//  FoursquareObject.h
//  Next
//
//  Created by David Manuntag on 2015-02-26.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *openingHours;
@property (nonatomic, strong) NSURL *photoUrl;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString * address;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary; 


@end
