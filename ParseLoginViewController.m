//
//  ParseLoginViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseLoginViewController.h"
#import "Parse/Parse.h"

@interface ParseLoginViewController () <UITextFieldDelegate>

@property (readonly, strong, nonatomic, nullable) UITextField *usernameField;
@property (readonly, strong, nonatomic, nullable) UITextField *passwordField;
@property (readonly, strong, nonatomic, nullable) UITextField *emailField;
@property (readonly, strong, nonatomic, nullable) UIButton *signUpButton;


@end

@implementation ParseLoginViewController

- (void)parseLogin {
    PFUser *user = [PFUser user];
    user.username =
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject *Login = [PFObject objectWithClassName:@"UserLogin"];
    Login[@"username"] = @"sampleusername";
    Login[@"password"] = @"samplepassword";
    Login[@"email"] = @"sampleemail";
    [Login saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
//let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//myAlert.addAction(action)
//
//self.presentViewController(myAlert, animated: true, completion:nil)

@end


