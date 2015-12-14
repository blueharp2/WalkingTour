//
//  ParseLoginViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseLoginViewController.h"
#import "Parse/Parse.h"
#import <ParseUI/ParseUI.h>


@interface ParseLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginButton:(id)sender;

@end

@implementation ParseLoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self signUp];
    [self login];
}

- (IBAction)loginButton:(id)sender {

    NSString *username = _userNameField.text;
    NSString *password = _passwordField.text;
    
    PFUser *user = [PFUser user];
        user.username = @"my name";
        user.password = @"my pass";
        user.email = @"email@example.com";
        
        // other fields can be set just like with PFObject
        user[@"phone"] = @"415-392-0202";
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {   // Hooray! Let them use the app now.
            } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            }
        }];
    }
    
    [PFUser logInWithUsernameInBackground:@"username" password:@"password"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
    } else {
        // show the signup or login screen
    }

    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser]; // this will now be nil

    }
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

//    var userEmail = userEmailAddressTextField.text!
//    var userPassword = userPasswordTextField.text!
//    
//    if (userEmail.isEmpty || userPassword.isEmpty) {
//        return
//    }
//    
//    PFUser.logInWithUsernameInBackground(userEmail, password: userPassword) { (user, error) -> Void in
//        
//        var userMessage = "Welcome!"
//        
//        if(user != nil) {
//            
//            let userName:String? = user?.username
//            
//            NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
//            NSUserDefaults.standardUserDefaults().synchronize()
//            
//            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
//            
//            let mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
//            
//            let mainPageNav = UINavigationController(rootViewController: mainPage)
//            
//            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            
//            appDelegate.window?.rootViewController = mainPageNav
//            
//        } else {
//            
//            userMessage = error!.localizedDescription
//        }
//        
//        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
//        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//        myAlert.addAction(action)
//        
//        self.presentViewController(myAlert, animated: true, completion:nil)
//    }
//}
