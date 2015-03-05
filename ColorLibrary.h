//
//  ColorLibrary.h
//  Next
//
//  Created by David Manuntag on 2015-03-01.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ColorLibrary : NSObject
@property (nonatomic, strong) NSArray * colorArray;

+(UIColor*)randomColor;

//-(instancetype)init;

@end
