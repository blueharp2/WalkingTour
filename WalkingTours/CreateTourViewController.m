//
//  CreateTourViewController.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourViewController.h"



@interface CreateTourViewController()

@property (weak, nonatomic) IBOutlet UITextField *nameOfTourTextField;

@property (weak, nonatomic) IBOutlet UITextField *tourDescriptionTextField;

@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;

- (IBAction)addLocationsButton:(id)sender;


@end

@implementation CreateTourViewController




-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTour:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (IBAction)addLocationsButton:(id)sender {
}
@end
