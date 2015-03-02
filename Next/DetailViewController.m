//
//  DetailViewController.m
//  Next
//
//  Created by JoLi on 2015-02-28.
//  Copyright (c) 2015 Jozef Lipovsky. All rights reserved.
//

#import "DetailViewController.h"
#import "FoursquareObject.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)setDetailFoursquareObject:(FoursquareObject *)detailFoursquareObject
{
    if (_detailFoursquareObject != detailFoursquareObject) {
        _detailFoursquareObject = detailFoursquareObject;
        
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailFoursquareObject) {
        self.tipLabel.text = self.detailFoursquareObject.tip;
        self.openingHoursLabel.text = self.detailFoursquareObject.openingHours;
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
