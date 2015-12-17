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
#import "ParseLoginViewController.h"
#import "ParseSignUpViewController.h"


@interface ParseLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation ParseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (IBAction)loginButton:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.userNameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        
        if (user && self.completion) {
            self.completion();
            
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"Username and/or Password are invalid" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button OK");
            }];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
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





















