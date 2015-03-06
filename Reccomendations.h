//
//  Reccomendations.h
//  Next
//
//  Created by David Manuntag on 2015-02-26.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reccomendations : NSObject

@property (nonatomic, strong) NSArray *weekendActivitiesMorning;
@property (nonatomic, strong) NSArray *weekendActivitiesClearWeather;
@property (nonatomic, strong) NSArray *weekendActivitiesNight;
@property (nonatomic, strong) NSArray *weekdayActivitiesMorning;
@property (nonatomic, strong) NSArray *weekdayActivitiesNight;

- (NSArray *)loadWeekendActivitiesMorning;
- (NSArray *)loadweekendActivitiesNight;
- (NSArray *)loadweekdayActivitiesMorning;
- (NSArray *)loadweekdayActivitiesNight;
- (NSArray *)loadWeekendActivitiesClearWeather;




@end
