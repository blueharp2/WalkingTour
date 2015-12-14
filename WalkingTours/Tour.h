//
//  Tour.h
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <Parse/Parse.h>

@interface Tour : PFObject <PFSubclassing>

@property(copy, nonatomic) NSString *nameOfTour;
@property(copy, nonatomic) NSString *descriptionText;
@property(strong, nonatomic)PFGeoPoint *startLocation;
@property(strong, nonatomic)PFUser *user;


-(id)initWithClassName:(NSString *)Tour
            nameOfTour: (NSString *)nameOfTour
       descriptionText:(NSString *)descriptionText
         startLocation:(PFGeoPoint *)startLocation
                  user:(PFUser *)user;


@end
