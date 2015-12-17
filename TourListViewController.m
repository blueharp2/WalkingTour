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
#import "Gradient.h"

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
    currentTour = currentTour;
    
    [ParseService fetchLocationsWithTourId:currentTour completion:^(BOOL success, NSArray *results) {
        if (success) {
            self.locationsFromParse = results;
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
    if ([segue.identifier  isEqual: @"TourDetailViewController"]) {
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
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationTableViewCell *cell = (LocationTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell"];
    [cell setLocation:[self.locationsFromParse objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Location *location = self.locationsFromParse[indexPath.row];
    [self performSegueWithIdentifier:@"TourDetailViewController" sender:location];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
}

@end











