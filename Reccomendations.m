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
    //art, shops, coffee, outdoors, sights, trending, food, topPicks
    
    self.weekendActivitiesMorning = [NSArray arrayWithObjects:@"shops", @"coffee",@"art" ,@"topPicks", @"food", nil];

    
    return self.weekendActivitiesMorning;
    
}


-(NSArray*)loadWeekendActivitiesClearWeather {
    //art, shops, coffee, outdoors, sights, trending, specials, topPicks
    
    self.weekendActivitiesClearWeather = [NSArray arrayWithObjects:@"art",@"shops", @"coffee", @"outdoors", @"sights", @"food", @"topPicks" ,nil];
    
    return self.weekendActivitiesClearWeather;
    
}


-(NSArray*)loadweekendActivitiesNight {
  //drinks, trending, food, coffee,
    
    self.weekendActivitiesNight = [NSArray arrayWithObjects:@"drinks",@"food",@"coffee",@"art", nil];
    
    return self.weekendActivitiesNight;
}
-(NSArray*)loadweekdayActivitiesMorning{
   //coffee, topPicks, food
    
    self.weekdayActivitiesMorning = [NSArray arrayWithObjects:@"coffee",@"topPicks",@"food", nil];
    
    return self.weekdayActivitiesMorning;
    
}
-(NSArray*)loadweekdayActivitiesNight {
   //drinks, food, coffee
    
    self.weekdayActivitiesNight = [NSArray arrayWithObjects:@"drinks", @"food", @"coffee", nil];
    
    return self.weekdayActivitiesNight;
    
}






@end
