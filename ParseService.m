//
//  ParseService.m
//  WalkingTours
//
//  Created by Lindsey on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseService.h"
#import <Parse/Parse.h>
#import "Tour.h"
#import "Location.h"




@implementation ParseService


+ (void)saveToParse:(Tour *)tour locations:(NSArray *)locations {
    
    NSArray *saveArray = [NSArray arrayWithObjects:tour, locations, nil];
    
    [PFObject saveAllInBackground:saveArray block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"They saved!");
        } else {
            NSLog(@"Something went terribly wrong.");
        }
    }];
}

//- (void)addTestModelsToParse:(PFFile *)media {
//    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(47.623544, -122.336224);
//    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
//    Tour *tour1 = [[Tour alloc] initWithClassName:@"Tour" nameOfTour:@"Tour 2." descriptionText:@"This is the tour description" startLocation:geoPoint user:nil];
//    Location *location1 = [[Location alloc] initWithClassName:@"Location" locationName:@"Code Fellows" locationDescription:@"This is where we practically live" photo:media categories:@[@"School", @"Education"] location:geoPoint tour:tour1];
//    PFGeoPoint *geoPoint2 = [PFGeoPoint geoPointWithLatitude:47.627825 longitude:-122.337412];
//    Location *location2 = [[Location alloc] initWithClassName:@"Location" locationName:@"The Park" locationDescription:@"I remember what the sun was like..." photo:media categories:@[@"Park", @"Not Coding"] location:geoPoint2 tour:tour1];
//    NSArray *objectArray = [NSArray arrayWithObjects:tour1, location1, location2, nil];
//    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"They saved!");
//        } else {
//            NSLog(@"Something went terribly wrong.");
//        }
//    }];
//}

@end
