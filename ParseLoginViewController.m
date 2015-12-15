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

}

- (IBAction)loginButton:(id)sender {
    
[PFUser logInWithUsernameInBackground:@"username" password:@"password" block:^(PFUser * _Nullable user, NSError * _Nullable error) {
    
        if (user) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TourSelectionViewController" bundle:[NSBundle mainBundle]];
            UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"TourSelectionViewController"];
            [self presentViewController:myController animated:YES completion:nil];
            
//            let mainPageNav = UINavigationController(rootViewController: mainPage)
//            
//            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
//            appDelegate.window?.rootViewController = mainPageNav

            [self performSegueWithIdentifier:@"TourSelectionVeiwController" sender:nil];
            
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
@end





















