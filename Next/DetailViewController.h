//
//  DetailViewController.h
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoursquareObject;


@interface DetailViewController : UIViewController

@property (strong, nonatomic) FoursquareObject *detailFoursquareObject;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingHoursLabel;

- (IBAction)backButtonPressed:(id)sender;

@end
