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
#import "CreateTourDetailViewController.h"
#import "ParseService.h"
#import "Tour.h"




@interface CreateTourViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

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

}

-(void)setupMainViewController{

    [self.locationTableView setDelegate:self];
    [self.locationTableView setDataSource:self];
    [self.nameOfTourTextField setDelegate:self];
    [self.tourDescriptionTextField setDelegate:self];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonSelected:)]];
    
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTour:)];
    //    self.navigationItem.rightBarButtonItem = saveButton;
    
    UINib *nib = [UINib nibWithNibName:@"POIDetailTableViewCell" bundle:nil];
    [[self locationTableView]registerNib:nib forCellReuseIdentifier:@"POIDetailTableViewCell"];
    
}

- (IBAction)addLocationsButton:(id)sender {
    [self.navigationController pushViewController:[[CreateTourDetailViewController alloc]init] animated:YES];
}



-(void)saveTourToParse{
    
    Location *startLocation = self.location.firstObject;
    NSString *name = self.nameOfTourTextField.text;
    NSString *description = self.tourDescriptionTextField.text;
    PFUser *user = [PFUser currentUser];
    

    Tour *tour = [[Tour alloc]initWithNameOfTour:name descriptionText:description startLocation:startLocation.location user:user];
    [ParseService saveToParse: tour locations:self.location];
    
}


#pragma mark set up TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.location !=nil) {
        return self.location.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   POIDetailTableViewCell *cell = (POIDetailTableViewCell *)[self.locationTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell" forIndexPath:indexPath];

    
   //cell.location =
    [self.location objectAtIndex:indexPath.row];
    
    return cell;
}

//custom setter on location Array it reloads data

#pragma mark Save to Parse

-(void)saveButtonSelected:(UIBarButtonItem *)sender{

    if (self.nameOfTourTextField.text.length != 0) {
        // [ParseService saveToParse:<#(Tour *)#> locations:<#(NSArray *)#>]
    }else {
        UIAlertController *noTextinFieldAlert = [UIAlertController alertControllerWithTitle:@"Please enter the name of your tour" message:@"Thank you" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [noTextinFieldAlert addAction:defaultAction];
        [self presentViewController:noTextinFieldAlert animated:YES completion:nil];
    }
    
    if (self.location.count !=0) {
        
        UIAlertController *noLocationAlert = [UIAlertController alertControllerWithTitle:@"Please add at least one location" message:@"Thank you" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [noLocationAlert addAction:defaultAction];
        [self presentViewController:noLocationAlert animated:YES completion:nil];
    }
    
//check if there is text and at least one location
    //if not present Alert and do not save
    
    
   // [ParseService saveToParse:<#(Tour *)#> locations:<#(NSArray *)#>]
    
}

@end
