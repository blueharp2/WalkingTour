//
//  ParseService.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tour.h"

typedef void(^locationsFetchCompletion)(BOOL success, NSArray *results);
typedef void(^toursFetchCompletion)(BOOL success, NSArray *results);
typedef void(^tourFetchCompletion)(BOOL success, Tour *result);
typedef void(^tourSaveCompletion)(BOOL success, NSError *error);

@interface ParseService : NSObject

+ (void)saveToParse:(Tour *)tour locations:(NSArray *)locations completion:(tourSaveCompletion)completion;

+ (void)fetchTourWithTourId:(NSString *)tourId completion:(tourFetchCompletion)completion;

+ (void)fetchLocationsWithTourId:(NSString *)tourId completion:(locationsFetchCompletion)completion;

//+ (void)fetchLocationsWithCategories:(NSArray *)categories nearLocation:(CLLocationCoordinate2D)location withinMiles:(float)miles completion:(locationsFetchCompletion)completion;

+ (void)fetchToursNearLocation:(CLLocationCoordinate2D)location completion:(toursFetchCompletion)completion;

//+ (void)searchToursNearLocation:(CLLocationCoordinate2D)location withinMiles:(float)miles withSearchTerm:(NSString *)searchTerm completion:(toursFetchCompletion) completion;

+ (void)searchToursNearLocation:(CLLocationCoordinate2D)location withinMiles:(float)miles withSearchTerm:(NSString *)searchTerm categories:(NSArray *)categories completion:(toursFetchCompletion)completion;

+ (void)setFavoritedTourIds:(NSArray<NSString *> *)tourIds forUser:(PFUser *)user;

@end
