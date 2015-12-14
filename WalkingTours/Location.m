//
//  Location.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "Location.h"

@implementation Location

@dynamic locationName;
@dynamic locationDescription;
@dynamic photo;
@dynamic categories;
@dynamic location;
@dynamic tour;

+(void) load{
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Location";
}

@end
