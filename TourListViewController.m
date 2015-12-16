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

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
                    // This table displays items in the Todo class
        self.parseClassName = @"Location";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
                // If no objects are loaded in memory, we look to the cache
                // first to fill the table and then subsequently do a query
                // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"locationtableviewcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
            // Configure the cell to show todo item with a priority at the bottom
    
//    cell.locationLabel.text = [object objectForKey:@"locationName"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"locatinDescription: %@",
//                                 [object objectForKey:@"locationDescription"]];
//    
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