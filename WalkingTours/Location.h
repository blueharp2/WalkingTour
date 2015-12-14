//
//  Location.h
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <Parse/Parse.h>
#import "Tour.h"

@interface Location : PFObject <PFSubclassing>

@property (copy, nonatomic) NSString *locationName;
@property (copy, nonatomic) NSString *locationDescription;
@property (strong, nonatomic) PFFile *photo;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) Tour *tour;




@end
