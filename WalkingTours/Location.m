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
@dynamic video;
@dynamic categories;
@dynamic location;
@dynamic tour;

+(void) load{
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Location";
}

-(id)initWithLocationName:(NSString *)locationName
      locationDescription:(NSString *)locationDescription
                    photo:(PFFile *)photo
                    video:(PFFile *)video
               categories:(NSArray *)categories
                 location:(PFGeoPoint *)location
                     tour:(Tour *)tour{
    
    if ((self = [super init])){
        self.locationName = locationName;
        self.locationDescription = locationDescription;
        self.photo = photo;
        self.video = video;
        self.categories = categories;
        self.location = location;
        self.tour = tour;
    }
    return self;
}

@end
