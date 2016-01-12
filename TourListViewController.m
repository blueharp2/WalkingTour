//
//  TourListViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourListViewController.h"
#import "TourDetailViewController.h"
#import "TourMapViewController.h"
#import "LocationTableViewCell.h"
#import "POIDetailTableViewCell.h"
#import "FindToursViewController.h"
#import "Tour.h"
#import "ParseService.h"
@import UIKit;
@import Parse;
@import ParseUI;
@import QuartzCore;

@interface TourListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray <Location*> *locationsFromParse;
@property (weak, nonatomic) IBOutlet UITableView *tourListTableView;
@property (strong, nonatomic) NSArray <Tour*> *toursFromParse;


@end

@implementation TourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)setCurrentTour:(NSString*)currentTour {
    _currentTour = currentTour;
    
    [ParseService fetchLocationsWithTourId:currentTour completion:^(BOOL success, NSArray *results) {
        if (success) {
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"orderNumber" ascending:YES];
            self.locationsFromParse = [results sortedArrayUsingDescriptors:@[descriptor]];
            [self.tourListTableView reloadData];
        }
    }];
}

- (void)setupViewController
{
    [self.tourListTableView setDelegate:self];
    [self.tourListTableView setDataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"LocationTableViewCell" bundle:nil];
    [[self tourListTableView] registerNib:nib forCellReuseIdentifier:@"LocationTableViewCell"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"TourDetailViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[TourDetailViewController class]]) {
            TourDetailViewController *tourDetailVC = (TourDetailViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[Location class]]) {
                Location *location = (Location *)sender;
                [tourDetailVC setLocation:location];
            }
        }
    }
}

#pragma mark - TABLEVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.locationsFromParse.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationTableViewCell *cell = (LocationTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell"];
    [cell setLocation:[self.locationsFromParse objectAtIndex:indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Location *location = self.locationsFromParse[indexPath.section];
    [self performSegueWithIdentifier:@"TourDetailViewController" sender:location];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Location *locationToDelete = [self.locationsFromParse objectAtIndex:indexPath.section];
        NSArray *arrayToDelete = [NSArray arrayWithObject:locationToDelete];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.locationsFromParse];
        [tempArray removeObjectAtIndex:indexPath.section];
        self.locationsFromParse = [NSArray arrayWithArray:tempArray];
        if (self.locationsFromParse.count == 0) {
            Tour *tourToDelete = locationToDelete.tour;
            arrayToDelete = [arrayToDelete arrayByAddingObject:tourToDelete];
        }
        [PFObject deleteAllInBackground:arrayToDelete block:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Unable to delete location: %@", error.localizedFailureReason);
            }
            if (succeeded) {
                if (self.locationsFromParse.count > 0) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [tableView reloadData];
                    }];
                } else {
                    if (self.delegate) {
                        [self.delegate deletedTourWithTour:locationToDelete.tour];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

@end











