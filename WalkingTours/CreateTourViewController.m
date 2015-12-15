//
//  CreateTourViewController.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourViewController.h"
#import "Location.h"
#import <Parse/Parse.h>
#import "POIDetailTableViewCell.h"



@interface CreateTourViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameOfTourTextField;
@property (weak, nonatomic) IBOutlet UITextField *tourDescriptionTextField;

@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
- (IBAction)addLocationsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (strong, nonatomic) NSArray<Location *> *Location;


@end

@implementation CreateTourViewController

-(void) setLocationTableView:(UITableView *)locationTableView{
    [self.locationTableView reloadData];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupMainViewController];
    

}


- (IBAction)addLocationsButton:(id)sender {
    
    
}

-(void)setupMainViewController{

    [self.locationTableView setDelegate:self];
    [self.locationTableView setDataSource:self];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtionSelected:)]];
    
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTour:)];
    //    self.navigationItem.rightBarButtonItem = saveButton;
    
    UINib *nib = [UINib nibWithNibName:@"POIDetailTableViewCell" bundle:nil];
    [[self locationTableView]registerNib:nib forCellReuseIdentifier:@"POIDetailTableViewCell"];
    
}

#pragma mark set up TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.Location !=nil) {
        return self.Location.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   POIDetailTableViewCell *cell = (POIDetailTableViewCell *)[self.locationTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell" forIndexPath:indexPath];

    
   //cell.location =
    [self.Location objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark Save to Parse

-(void)saveButtionSelected:(UIBarButtonItem *)sender{
    
}

@end
