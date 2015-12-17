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
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];

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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma TextField Delegate
        
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}


@end





















