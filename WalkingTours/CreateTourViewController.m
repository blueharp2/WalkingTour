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

@interface CreateTourViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CreateTourDetailViewControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameOfTourTextField;
@property (weak, nonatomic) IBOutlet UITextField *tourDescriptionTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addLocationButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
- (IBAction)addLocationsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;

@end

@implementation CreateTourViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupMainViewController];
    self.addLocationButton.layer.cornerRadius = self.addLocationButton.frame.size.width / 2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.locations.count == 0) {
        self.addLocationButtonBottomConstraint.constant = (self.view.frame.size.height / 2) - 10;
    } else {
        self.addLocationButtonBottomConstraint.constant = 10;
    }
    if (self.tour != nil) {
        self.nameOfTourTextField.text = self.tour.nameOfTour;
        self.tourDescriptionTextField.text = self.tour.descriptionText;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.locations.count > 0) {
        self.addLocationButtonBottomConstraint.constant = 30;
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)setupMainViewController{
    
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
    self.navigationController.delegate = self;
    [self.nameOfTourTextField setDelegate:self];
    [self.tourDescriptionTextField setDelegate:self];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonSelected:)]];
    
    UINib *nib = [UINib nibWithNibName:@"LocationTableViewCell" bundle:nil];
    [[self locationTableView]registerNib:nib forCellReuseIdentifier:@"LocationTableViewCell"];
    
}

- (IBAction)addLocationsButton:(id)sender {
    [self.nameOfTourTextField resignFirstResponder];
    [self.tourDescriptionTextField resignFirstResponder];
}

#pragma mark - Set up TableView

#pragma mark - UITableView protocol functions.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.locations.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   LocationTableViewCell *cell = (LocationTableViewCell *)[self.locationTableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell" forIndexPath:indexPath];
    [cell setLocation:self.locations[indexPath.section]];
    [cell setImage:self.images[indexPath.section]];
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = editButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.locations removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    CreateTourDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateTourDetailViewController"];
//    [detailVC setLocationToEdit:self.locations[indexPath.section]];
    detailVC.locationToEdit = self.locations[indexPath.section];
    NSLog(@"locationToEdit's objectid == %@", self.locations[indexPath.section].objectId);
    detailVC.image = self.images[indexPath.section];
    detailVC.createTourDetailDelegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)editButtonTapped:(UIButton *)sender event:(UIEvent *)event {
    NSSet *touches = event.allTouches;
    UITouch *touch = touches.anyObject;
    CGPoint currentTouchPosition = [touch locationInView:self.locationTableView];
    NSIndexPath *indexPath = [self.locationTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        [self tableView:self.locationTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

//custom setter on location Array it reloads data

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == 0) {
        [self.tourDescriptionTextField becomeFirstResponder];
    }
    return YES;
}

#pragma mark - Save to Parse

-(void)saveButtonSelected:(UIBarButtonItem *)sender{
    if (self.nameOfTourTextField.text.length == 0 || self.tourDescriptionTextField.text.length == 0) {
        UIAlertController *noTextinFieldAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Missing Text", comment: nil) message:NSLocalizedString(@"Please enter the name and description for your tour", comment nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [noTextinFieldAlert addAction:defaultAction];
        [self presentViewController:noTextinFieldAlert animated:YES completion:nil];
        return;
    }
    if (self.locations.count == 0) {
        UIAlertController *noLocationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Missing Locations", comment: nil) message:NSLocalizedString(@"Please add at least one location.", comment: nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", comment: nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [noLocationAlert addAction:defaultAction];
        [self presentViewController:noLocationAlert animated:YES completion:nil];
        return;
    }
    if ([self.navigationController.viewControllers[0] isKindOfClass:[CreateTourViewController class]]) {
        NSMutableArray *saveArray = [NSMutableArray arrayWithObject:self.tour];
        int i = 0;
        for (Location *location in self.locations) {
            location.tour = self.tour;
            location.orderNumber = i++;
            [saveArray addObject:location];
        }
        [PFObject saveAllInBackground:saveArray block:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Unable to save objects: %@", error.localizedFailureReason);
            }
            if (succeeded) {
                if (self.editToursCompletion != nil) {
                    self.editToursCompletion();
                }
            }
        }];
    } else {
        Tour *tour = [[Tour alloc] initWithNameOfTour:self.nameOfTourTextField.text descriptionText:self.tourDescriptionTextField.text startLocation:self.locations.firstObject.location user:[PFUser currentUser]];
        NSMutableArray *saveArray;
        int i = 0;
        for (Location *location in self.locations) {
            location.tour = tour;
            location.orderNumber = i++;
            if (saveArray.count == 0) {
                saveArray = [NSMutableArray arrayWithObject:location];
            } else {
                [saveArray addObject:location];
            }
        }
        
        [ParseService saveToParse:tour locations:saveArray completion:^(BOOL success, NSError *error) {
            if (success) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                NSLog(@"Error saving: %@", error.localizedFailureReason);
            }
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"SegueToCreateTourDetailVC"]) {
        if ([segue.destinationViewController isKindOfClass:[CreateTourDetailViewController class]]) {
            CreateTourDetailViewController *detailVC = (CreateTourDetailViewController *)segue.destinationViewController;
            detailVC.createTourDetailDelegate = self;
        }
    }
}

- (void)didFinishSavingLocationWithLocation:(Location *)location image:(UIImage *)image newLocation:(BOOL)newLocation {
    if (newLocation) {
        if (self.locations.count > 0) {
            [self.locations addObject:location];
            [self.images addObject:image];
        } else {
            self.locations = [NSMutableArray arrayWithObject:location];
            self.images = [NSMutableArray arrayWithObject:image];
        }
        [self.locationTableView reloadData];
    } else {
        __block int index;
        [self.locations indexOfObjectPassingTest:^BOOL(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"obj.objectid == %@, location.objectId == %@", obj.objectId, location.objectId);
            if (obj.objectId == location.objectId) {
                index = (int)idx;
                *stop = YES;
            } else {
                index = -1;
            }
            return 0;
        }];
        if (index >= 0) {
            self.locations[index] = location;
            self.images[index] = image;
            [self.locationTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController.viewControllers[0] isKindOfClass:[CreateTourViewController class]]) {
        UIBarButtonItem *undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoButtonPressed)];
        self.navigationItem.leftBarButtonItem = undoButton;
    }
}

- (void)undoButtonPressed {
    if (self.editToursCompletion) {
        self.editToursCompletion();
    }
}

@end
