//
//  TourMapViewController.h
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tour.h"
@import CoreLocation;

@interface TourMapViewController : UIViewController

@property (strong, nonatomic) NSString *currentTour;

- (void)setCurrentTour:(NSString*)currentTour;

@end
