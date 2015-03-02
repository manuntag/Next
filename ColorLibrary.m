//
//  ColorLibrary.m
//  Next
//
//  Created by David Manuntag on 2015-03-01.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "ColorLibrary.h"
#import "HexColor.h"

@implementation ColorLibrary

//dark blue : #0A4A82, #3f526f
//grey blue : #30699B, #4F759B, #3e5e6f, #3c566b, #355e68
//purple : #5D5179
//green : #00ab84, #137d79, #247e6f, #21797c
//grey : #485956, #524942


- (void)loadColors {
    
    
    UIColor * darkBlue1 = [UIColor colorWithHexString:@"#0A4A82" alpha:1.0];
    UIColor * darkBlue2 = [UIColor colorWithHexString:@"#3f526f" alpha:1.0];
    
    UIColor * greyBlue1 = [UIColor colorWithHexString:@"#30699B" alpha:1.0];
    UIColor * greyBlue2 = [UIColor colorWithHexString:@"#4F759B" alpha:1.0];
    UIColor * greyBlue3 = [UIColor colorWithHexString:@"#3e5e6f" alpha:1.0];
    UIColor * greyBlue4 = [UIColor colorWithHexString:@"#3c566b" alpha:1.0];
    UIColor * greyBlue5 = [UIColor colorWithHexString:@"#355e68" alpha:1.0];
    
    UIColor * purple1 = [UIColor colorWithHexString:@"#5D5179" alpha:1.0];
    
    UIColor * green1 = [UIColor colorWithHexString:@"#00ab84" alpha:1.0];
    UIColor * green2 = [UIColor colorWithHexString:@"#137d79" alpha:1.0];
    UIColor * green3 = [UIColor colorWithHexString:@"#247e6f" alpha:1.0];
    UIColor * green4 = [UIColor colorWithHexString:@"#21797c" alpha:1.0];
    
    UIColor * grey1 = [UIColor colorWithHexString:@"#485956" alpha:1.0];
    UIColor * grey2 = [UIColor colorWithHexString:@"#524942" alpha:1.0];
    
    self.colorArray = [NSArray arrayWithObjects:darkBlue1,darkBlue2,greyBlue1,greyBlue2 , greyBlue3,greyBlue4, greyBlue5, purple1, green1, green2, green3, green4, grey1, grey2,  nil];
    
}
- (UIColor*)randomColor {
    
    int randomNumber = arc4random()%self.colorArray.count;
    
    UIColor * randomColorFromColorArray = [self.colorArray objectAtIndex:randomNumber];
    
    return randomColorFromColorArray;
    
    
}



@end
