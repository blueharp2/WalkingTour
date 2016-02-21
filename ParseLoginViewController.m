//
//  ParseLoginViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

@import UIKit;
@import Parse;
@import ParseUI;
@import Fabric;
@import Crashlytics;
#import "ParseLoginViewController.h"
#import "ParseSignUpViewController.h"


@interface ParseLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation ParseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

}

- (IBAction)loginButton:(id)sender {
    [self logInUser];
}

- (void)logInUser {
    [PFUser logInWithUsernameInBackground:self.userNameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        
        if (user && self.completion) {
            [self logUser];
            self.completion();
            
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"Username and/or Password are invalid" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
}

- (void)logUser {
    [CrashlyticsKit setUserIdentifier:[PFUser currentUser].objectId];
}

#pragma TextField Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [self.passwordField becomeFirstResponder];
    }
    if (textField.tag == 1) {
        [self logInUser];
    }
    return YES;
}

@end





















