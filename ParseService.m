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

+ (void)saveToParse:(Tour *)tour locations:(NSArray *)locations completion:(tourSaveCompletion)completion {
    NSArray *saveArray = [NSArray arrayWithObjects:tour, locations, nil];
    [PFObject saveAllInBackground:saveArray block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            completion(YES, nil);
        } else {
            completion(NO, error);
        }
    }];
}

+ (void)fetchLocationsWithTourId:(NSString *)tourId completion:(locationsFetchCompletion)completion
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"tour" equalTo:[PFObject objectWithoutDataWithClassName:@"Tour" objectId:tourId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedFailureReason);
            completion(NO, nil);
        }
        if (objects) {
            completion(YES, objects);
        }
    }];
}

+ (void)fetchToursNearLocation:(CLLocationCoordinate2D)location completion:(toursFetchCompletion)completion {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
    PFQuery *query = [PFQuery queryWithClassName:@"Tour"];
    [query whereKey:@"startLocation" nearGeoPoint:geoPoint];
//    [query whereKey:@"startLocation" nearGeoPoint:geoPoint withinMiles:2.0];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedFailureReason);
            completion(NO, nil);
        }
        if (objects) {
            completion(YES, objects);
        }
    }];
}

@end
