//
//  CreateTourViewController.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourViewController.h"



@interface CreateTourViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameOfTourTextField;
@property (weak, nonatomic) IBOutlet UITextField *tourDescriptionTextField;

@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
- (IBAction)addLocationsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;


@end

@implementation CreateTourViewController

-(void) setLocationTableView:(UITableView *)locationTableView{
    [self.locationTableView reloadData];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupMainViewController];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTour:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}


- (IBAction)addLocationsButton:(id)sender {
}

-(void)setupMainViewController{
    [self.locationTableView setDelegate:self];
    [self.locationTableView setDataSource:self];
    
}



@end
