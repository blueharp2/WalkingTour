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
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL) validateEmail: (UITextField *)passwordSignUp {
    NSString *emailString = self.passwordSignUp.text;
    NSString *emailRegex = @"[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter Valid Email Address" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)saveSignUp:(id)sender {

if ([self validateEmail:self.passwordSignUp]) {

    PFUser *user = [PFUser user];
    user.username = _usernameSignUp.text;
    user.password = _passwordSignUp.text;
    user.email = _emailSignUp.text;
    
    if (_usernameSignUp.text.length > 0 && _passwordSignUp.text.length > 0 && _emailSignUp.text.length > 0) {

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([self.navigationController.viewControllers[0] isKindOfClass:[ParseLoginViewController class]]) {
                ParseLoginViewController *loginVC = (ParseLoginViewController *)self.navigationController.viewControllers[0];
                if (loginVC.completion) {
                    loginVC.completion();
                }
            }
        }
    }];
}
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please complete all fields" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];}
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





















