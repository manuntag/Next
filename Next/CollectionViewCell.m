//
//  CollectionViewCell.m
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "CollectionViewCell.h"
#import "ColorLibrary.h"

@implementation CollectionViewCell



//-(instancetype)init{
//    
//    if(self = [super init] ) {
//        
//        ColorLibrary * colorLibrary = [[ColorLibrary alloc]init];
//        
//        [colorLibrary loadColors];
//        
//        UIColor * randomColor = [colorLibrary randomColor];
//        
//        self.imageFilterView.backgroundColor = randomColor;
//
//    }
//    
//    return self;
//}


- (void)cutomizeRatingLabel {
    
    self.ratingLabel.layer.cornerRadius = self.ratingLabel.frame.size.width/2;
    self.ratingLabel.clipsToBounds = YES;
    
}

 - (void)setUpColor {

     ColorLibrary * colorLibrary = [[ColorLibrary alloc]init];

             [colorLibrary loadColors];
     
             UIColor * randomColor = [colorLibrary randomColor];
     
             self.imageFilterView.backgroundColor = randomColor;
     
}

@end
