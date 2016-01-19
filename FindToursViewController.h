//
//  FindToursViewController.h
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

@import UIKit;
@import MapKit;
@import CoreLocation;
#import "Tour.h"

@protocol TourListViewControllerDelegate <NSObject>

- (void)deletedTourWithTour:(Tour *)tour;

@end

@interface FindToursViewController : UIViewController

@end
