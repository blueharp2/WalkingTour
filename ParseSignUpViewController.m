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

@property (weak, nonatomic) IBOutlet UITextField *usernameSignUp;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUp;
@property (weak, nonatomic) IBOutlet UITextField *emailSignUp;

- (IBAction)saveSignUp:(id)sender;

@end

@implementation ParseSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonPressed:(id)sender {
    UIViewController *vc = [self presentingViewController];
    [self dismissViewControllerAnimated:YES completion: nil];
    
    [[vc presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveSignUp:(id)sender {
}
@end
