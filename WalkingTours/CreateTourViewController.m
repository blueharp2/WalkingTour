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
#import "LocationTableViewCell.h"
#import "CreateTourDetailViewController.h"
#import "ParseService.h"
#import "Tour.h"




@interface CreateTourViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CreateTourDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameOfTourTextField;
@property (weak, nonatomic) IBOutlet UITextField *tourDescriptionTextField;

@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
- (IBAction)addLocationsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (strong, nonatomic) NSArray<Location *> *locations;
@property (strong, nonatomic) NSArray<UIImage *> *images;



@end

@implementation CreateTourViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupMainViewController];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"View appeared");
    [self.locationTableView reloadData];
}

-(void)setupMainViewController{
    
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
    [self.nameOfTourTextField setDelegate:self];
    [self.tourDescriptionTextField setDelegate:self];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonSelected:)]];
    
    UINib *nib = [UINib nibWithNibName:@"LocationTableViewCell" bundle:nil];
    [[self locationTableView]registerNib:nib forCellReuseIdentifier:@"LocationTableViewCell"];
    
}

- (IBAction)addLocationsButton:(id)sender {
//    [self.navigationController pushViewController:[[CreateTourDetailViewController alloc]init] animated:YES];
}



-(void)saveTourToParse{
    
    Location *startLocation = self.locations.firstObject;
    NSString *name = self.nameOfTourTextField.text;
    NSString *description = self.tourDescriptionTextField.text;
    PFUser *user = [PFUser currentUser];
    

    Tour *tour = [[Tour alloc]initWithNameOfTour:name descriptionText:description startLocation:startLocation.location user:user];
    [ParseService saveToParse: tour locations:self.locations];
    
}


#pragma mark set up TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.locations !=nil) {
        return self.locations.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   LocationTableViewCell *cell = (LocationTableViewCell *)[self.locationTableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell" forIndexPath:indexPath];
    [cell setLocation:self.locations[indexPath.row]];
    [cell setImage:self.images[indexPath.row]];
    return cell;
}

//custom setter on location Array it reloads data

#pragma mark Save to Parse

-(void)saveButtonSelected:(UIBarButtonItem *)sender{
    if (self.nameOfTourTextField.text.length != 0) {
        NSLog(@"We have text!");
    } else {
        UIAlertController *noTextinFieldAlert = [UIAlertController alertControllerWithTitle:@"Please enter the name of your tour" message:@"Thank you" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [noTextinFieldAlert addAction:defaultAction];
        [self presentViewController:noTextinFieldAlert animated:YES completion:nil];
        return;
    }
    if (self.locations.count !=0) {
        NSLog(@"We have a location!");
    } else {
        UIAlertController *noLocationAlert = [UIAlertController alertControllerWithTitle:@"Please add at least one location" message:@"Thank you" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [noLocationAlert addAction:defaultAction];
        [self presentViewController:noLocationAlert animated:YES completion:nil];
        return;
    }
    Tour *tour = [[Tour alloc] initWithNameOfTour:self.nameOfTourTextField.text descriptionText:self.tourDescriptionTextField.text startLocation:self.locations.firstObject.location user:[PFUser currentUser]];
    NSArray *saveArray = [[NSArray alloc] init];
    for (Location *location in self.locations) {
        location.tour = tour;
        if (saveArray.count == 0) {
            saveArray = @[location];
        } else {
            [saveArray arrayByAddingObject:location];
        }
    }
    [ParseService saveToParse:tour locations:saveArray];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"SegueToCreateTourDetailVC"]) {
        if ([segue.destinationViewController isKindOfClass:[CreateTourDetailViewController class]]) {
            CreateTourDetailViewController *detailVC = (CreateTourDetailViewController *)segue.destinationViewController;
            detailVC.createTourDetailDelegate = self;
        }
    }
}

- (void)didFinishSavingLocationWithLocation:(Location *)location image:(UIImage *)image {
    if (self.locations.count > 0) {
        [self.locations arrayByAddingObject:location];
        [self.images arrayByAddingObject:image];
    } else {
        self.locations = @[location];
        self.images = @[image];
    }
    [self.locationTableView reloadData];
}

@end
