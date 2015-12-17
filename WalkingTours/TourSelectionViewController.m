//
//  TourSelectionViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseLoginViewController.h"
#import "ParseSignUpViewController.h"
#import "TourSelectionViewController.h"
@import Parse;



@interface TourSelectionViewController ()

@end

@implementation TourSelectionViewController

- (IBAction)selectTour:(id)sender {
    
}

- (IBAction)createTour:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
    } else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        if ([navController.viewControllers.firstObject isKindOfClass:[ParseLoginViewController class]]) {
            ParseLoginViewController *loginVC = (ParseLoginViewController *)navController.viewControllers.firstObject;
            loginVC.completion = ^ {
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}

@end
