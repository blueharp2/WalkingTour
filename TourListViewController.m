//
//  TourListViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourListViewController.h"
#import "TourDetailViewController.h"
#import "LocationTableViewCell.h"
#import "POIDetailTableViewCell.h"
#import "Tour.h"
#import "ParseService.h"
@import Parse;
@import ParseUI;

@interface TourListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"locationtableviewcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        [tableView registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationtableviewcell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"locationtableviewcell"];
    }
    
    
    return cell;
}
   

        //Segue to POIDetailTableView when cell is selected

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"POIDetailTableViewCell"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        TourDetailViewController *destViewController = segue.destinationViewController;
//        destViewController.locationData = [recipes objectAtIndex:indexPath.row];
//    }
//}

    
@end





//
//+ (void)fetchLocationsWithTourId:(NSString *)tourId completion:(locationsFetchCompletion)completion {
//    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
//    [query whereKey:@"objectId" equalTo:tourId];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@", error.localizedFailureReason);
//            completion(NO, nil);
//        }
//        if (objects) {
//            completion(YES, objects);
//        }
//    }];
//}