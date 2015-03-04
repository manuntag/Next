//
//  SugestionCalculator.m
//  Next
//
//  Created by David Manuntag on 2015-02-25.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "SugestionCalculator.h"
#import "Reccomendations.h"

@implementation SugestionCalculator

-(void)calculateReccomendationArray:(NSString*)partOfWeek sectionOfDay:(NSString*)sectionOfDay mainWeather:(NSString*)mainWeather{
  
    Reccomendations * reccomendation = [[Reccomendations alloc]init];

    if ([partOfWeek isEqualToString:@"weekend"] && [sectionOfDay isEqualToString:@"morning"] && [mainWeather isEqualToString:@"Clear"]) {
        
        self.calculatedReccomendationArray =  [NSArray arrayWithArray:[reccomendation loadWeekendActivitiesClearWeather]];
        
        
    }else if ([partOfWeek isEqualToString:@"weekday"] && [sectionOfDay isEqualToString:@"morning"]) {
    
        self.calculatedReccomendationArray =  [NSArray arrayWithArray:[reccomendation loadweekdayActivitiesMorning]];
        
        
    }else if ([partOfWeek isEqualToString:@"weekday"] && [sectionOfDay isEqualToString:@"night"]) {
    
        self.calculatedReccomendationArray = [reccomendation loadweekdayActivitiesNight];

        
    }else if ([partOfWeek isEqualToString:@"weekend"] && [sectionOfDay isEqualToString:@"morning"]) {
    
        self.calculatedReccomendationArray = [reccomendation loadWeekendActivitiesMorning];
    
    }else if ([partOfWeek isEqualToString:@"weekend"] && [sectionOfDay isEqualToString:@"night"] ) {
    
        self.calculatedReccomendationArray = [reccomendation loadweekendActivitiesNight];
    
    }

}

-(NSString *)randomRecomendedSection {

    NSInteger randomNumber = arc4random() % self.calculatedReccomendationArray.count;
    
    NSString *randomRecomendation = [self.calculatedReccomendationArray objectAtIndex:randomNumber];

    return randomRecomendation;

}



@end
