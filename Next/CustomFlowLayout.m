//
//  CustomFlowLayout.m
//  Next
//
//  Created by JoLi on 2015-03-04.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *atributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    atributes.center = CGPointMake(atributes.center.x, atributes.center.y - self.collectionView.frame.size.height);
    
    return atributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *atributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    atributes.center = CGPointMake(atributes.center.x + self.collectionView.frame.size.width + 200, atributes.center.y);
    
    return atributes;
}

@end
