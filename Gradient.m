//
//  Gradient.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/16/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "Gradient.h"
@import UIKit;
@import QuartzCore;

@implementation Gradient

+ (CAGradientLayer *)blueGradient
{
    UIColor *colorOne = [UIColor colorWithRed:0/255.0 green:156/255.0 blue:255/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0/255.0 green:110/255.0 blue:187/255.0 alpha:1.0];
    NSArray *colors = [NSArray arrayWithObjects:colorOne.CGColor, colorTwo.CGColor, nil];
   
    NSNumber *stopOne = [NSNumber numberWithFloat:0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}
@end
