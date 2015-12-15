//
//  TourSelectionViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourSelectionViewController.h"
#import "Parse/Parse.h"
#import "ParseLoginViewController.h"
#import "ParseSignUpViewController.h"


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

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"LoggedIn");
        
    } else {

        ParseLoginViewController *loginVC = (ParseLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ParseLoginViewController"];
        loginVC.completion = ^{[self dismissViewControllerAnimated:YES completion:nil];
        };
            [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end




