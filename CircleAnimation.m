//
//  LoadingScreen.m
//  Next
//
//  Created by David Manuntag on 2015-03-04.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "CircleAnimation.h"
#import "ColorLibrary.h"
#import "HexColor.h"

@implementation CircleAnimation


//y568 x320

+(UIView*)makeCircleWithCentreX:(CGFloat)centreX centreY:(CGFloat)centreY {
  
    
    CGRect circleDimension = CGRectMake(centreX-5, centreY-5, 10 ,10);
    
    UIView * circle = [[UIView alloc]initWithFrame:circleDimension];
    
    circle.backgroundColor = [UIColor colorWithHexString:@"#68c4af"];
    circle.alpha = 0.50;
    
    circle.layer.cornerRadius = circle.frame.size.width/2;
    circle.clipsToBounds = YES;
    


    [UIView animateWithDuration:5.0 animations:^{
        
        CGRect newCircleDimension = CGRectMake(centreX-350, centreY-350, 700, 700);
        
        
        [circle setFrame:newCircleDimension];
        
        circle.layer.cornerRadius = circle.frame.size.width/2;
        circle.clipsToBounds = YES;
        circle.alpha = 1.0;
        
        
    }];
    
    
    return circle;
    
}



@end
