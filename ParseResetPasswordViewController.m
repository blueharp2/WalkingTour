//
//  ParseResetPasswordViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseResetPasswordViewController.h"
#import "ParseSignUpViewController.h"
#import "ParseLoginViewController.h"
@import Parse;
@import ParseUI;

@interface ParseResetPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordReset;

- (IBAction)sendResetPassword:(id)sender;

@end

@implementation ParseResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];


}
//        Test for Valid Email Address

- (BOOL) validateEmail: (UITextField *)passwordReset {
    NSString *emailString = self.passwordReset.text;
    NSString *emailRegex = @"[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter Valid Email Address" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)sendResetPassword:(id)sender {
    [self resetPassword];
}

- (void)resetPassword {
    if ([self validateEmail:self.passwordReset]) {
        [PFUser requestPasswordResetForEmailInBackground:self.passwordReset.text];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resetPassword];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end
