//
//  TourSelectionViewController.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseSignUpViewController.h"
#import "ParseLoginViewController.h"
#import "ParseResetPasswordViewController.h"

@interface TourSelectionViewController : UIViewController

@property (strong, nonatomic) NSString *linkedTour;

@end
