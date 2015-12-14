//
//  ParseLoginViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

@import UIKit;
@import Parse;
#import "ParseLoginViewController.h"
#import "ParseUI/ParseUI.h"

@interface ParseLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation ParseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)loginButton:(id)sender {

    NSString *username = _userNameField.text;
    NSString *password = _passwordField.text;
    
    PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                } else {
                    NSString *errorString = [error userInfo][@"error"];
            }
        }];
    
    [PFUser logInWithUsernameInBackground:@"username" password:@"password"
                                    block:^(PFUser *user, NSError *error) {
            if (user != nil) {
                // Do stuff after successful login.
            } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert" message:@"This is an alert." preferredStyle:UIAlertControllerStyleAlert]; // 7
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        
        [alert addAction:defaultAction];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Input data...";
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
                
        }
    }];
}
@end

