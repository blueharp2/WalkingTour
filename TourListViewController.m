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
    //Setup tableView
    [self.tourListTableView setDelegate:self];
    [self.tourListTableView setDataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"LocationTableViewCell" bundle:nil];
    [[self tourListTableView] registerNib:nib forCellReuseIdentifier:@"LocationTableViewCell"];
}

#pragma mark - TABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.locationsFromParse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationTableViewCell *cell = (LocationTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell"];
    [cell setLocation:[self.locationsFromParse objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tourId = self.locationsFromParse[indexPath.row].objectId;
    [self performSegueWithIdentifier:@"TourDetailViewController" sender:tourId];
}

@end











