//
//  TourSelectionViewController.h
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseSignUpViewController.h"
#import "ParseLoginViewController.h"
#import "ParseResetPasswordViewController.h"

@interface TourSelectionViewController : UIViewController

@property (strong, nonatomic) NSString *linkedTour;

@end
