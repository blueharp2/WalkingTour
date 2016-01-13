//
//  CreateTourDetailViewController.h
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
@import CoreLocation;

@protocol CreateTourDetailViewControllerDelegate <NSObject>

- (void)didFinishSavingLocationWithLocation:(Location *)location image:(UIImage *)image;

@end

@protocol LocationControllerDelegate <NSObject>

-(void)locationControllerDidUpdateLocation:(CLLocation *)location;

@end

@interface CreateTourDetailViewController : UIViewController

@property (strong, nonatomic) id<CreateTourDetailViewControllerDelegate> createTourDetailDelegate;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@property (weak, nonatomic) id<LocationControllerDelegate> delegate;
@property (strong, nonatomic) Location *locationToEdit;

@end
