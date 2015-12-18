//
//  MyExtension.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/17/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "MyExtension.h"

@implementation MyExtension

@synthesize tourId;
@synthesize coordinate;
@synthesize title;

- (void)setTourId:(NSString *)theTourId {
    self.tourId = theTourId;
}

- (void)setTitle:(NSString *)myTitle {
    self.title = myTitle;
}

@end
