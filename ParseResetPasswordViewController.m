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

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];


}


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
