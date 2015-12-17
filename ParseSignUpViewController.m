//
//  ParseSignUpViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseSignUpViewController.h"
#import "ParseLoginViewController.h"
#import "Parse/Parse.h"
#import <ParseUI/ParseUI.h>


@interface ParseSignUpViewController () <UITextFieldDelegate>

@end

@implementation ParseSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)saveSignUp:(id)sender {
    
    PFUser *user = [PFUser user];
    user.username = _usernameSignUp.text;
    user.password = _passwordSignUp.text;
    user.email = _emailSignUp.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([[self presentingViewController] isKindOfClass:[ParseLoginViewController class]]) {
                ParseLoginViewController *loginVC = (ParseLoginViewController *)[self presentingViewController];
                if (loginVC.completion) {
                    loginVC.completion();
                }
            }
        }
    }];
}

@end





















