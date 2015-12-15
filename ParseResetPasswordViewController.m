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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendResetPassword:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];
}
@end
