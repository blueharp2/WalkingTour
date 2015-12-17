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
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];

}

        //Test for Valid Email Address

//- (BOOL) validateEmail: (UITextField *)passwordReset {
//    NSString *emailString = self.passwordReset.text;
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    
////    return [emailTest evaluateWithObject:passwordReset];
//
//    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
//    {
//        UIAlertController *loginalert = [UIAlertController alertControllerWithTitle:@"Email Invalid" message:@"Enter Email in abc@example.com Format" preferredStyle:UIAlertControllerStyleAlert;
//        
//        
//        [loginalert show];
//        return NO;
//    } else {
//        return YES;
////    If email is invalid, it will remind the user with an alert box. 
//    }
//}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendResetPassword:(id)sender {
    
    [PFUser requestPasswordResetForEmailInBackground:self.passwordReset.text];

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
