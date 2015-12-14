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

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)loginButton:(id)sender;

@end

@implementation ParseLoginViewController



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

- (IBAction)loginButton:(id)sender {
}
@end


