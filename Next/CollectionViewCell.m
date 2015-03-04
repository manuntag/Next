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

- (void)cutomizeRatingLabel {
    
    self.ratingLabel.layer.cornerRadius = self.ratingLabel.frame.size.width/2;
    self.ratingLabel.clipsToBounds = YES;
}


@end
