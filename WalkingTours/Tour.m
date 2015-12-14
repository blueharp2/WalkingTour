//
//  Tour.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "Tour.h"

@implementation Tour

@dynamic nameOfTour;
@dynamic descriptionText;
@dynamic startLocation;
@dynamic user;



+(void) load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Tour";
}



@end
