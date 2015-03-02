//
//  Reccomendations.m
//  Next
//
//  Created by David Manuntag on 2015-02-26.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "Reccomendations.h"

@implementation Reccomendations


-(NSArray*)loadWeekendActivitiesMorning {
    //art, shops, coffee, outdoors, sights, trending, specials, topPicks
    
    self.weekendActivitiesMorning = [NSArray arrayWithObjects:@"shops", @"coffee",@"art" ,@"topPicks", @"specials", nil];

    
    return self.weekendActivitiesMorning;
    
}


-(NSArray*)loadWeekendActivitiesClearWeather {
    //art, shops, coffee, outdoors, sights, trending, specials, topPicks
    
    self.weekendActivitiesClearWeather = [NSArray arrayWithObjects:@"art",@"shops", @"coffee", @"outdoors", @"sights", @"specials", @"topPicks" ,nil];
    
    return self.weekendActivitiesClearWeather;
    
}


-(NSArray*)loadweekendActivitiesNight {
  //drinks, trending, specials, coffee,
    
    self.weekendActivitiesNight = [NSArray arrayWithObjects:@"drinks",@"specials",@"coffee",@"art", nil];
    
    return self.weekendActivitiesNight;
}
-(NSArray*)loadweekdayActivitiesMorning{
   //coffee, topPicks, trending
    
    self.weekdayActivitiesMorning = [NSArray arrayWithObjects:@"coffee",@"topPicks", nil];
    
    return self.weekdayActivitiesMorning;
    
}
-(NSArray*)loadweekdayActivitiesNight {
   //drinks, trending, specials, coffee
    
    self.weekdayActivitiesNight = [NSArray arrayWithObjects:@"drinks", @"specials", @"coffee", nil];
    
    return self.weekdayActivitiesNight;
    
}






@end
