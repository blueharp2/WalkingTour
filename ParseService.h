//
//  ParseService.h
//  WalkingTours
//
//  Created by Lindsey on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tour.h"

typedef void(^locationsFetchCompletion)(BOOL success, NSArray *results);
typedef void(^toursFetchCompletion)(BOOL success, NSArray *results);

@interface ParseService : NSObject

+ (void)saveToParse:(Tour *)tour locations:(NSArray *)locations;
+ (void)fetchLocationsWithTourId:(NSString *)tourId completion:(locationsFetchCompletion)completion;
+ (void)fetchToursNearLocation:(CLLocationCoordinate2D)location completion:(toursFetchCompletion)completion;

@end
