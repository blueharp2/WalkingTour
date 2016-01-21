//
//  TourSelectionViewController.m
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "ParseLoginViewController.h"
#import "ParseSignUpViewController.h"
#import "TourSelectionViewController.h"

@interface TourSelectionViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonTopConstraint;

@end

@implementation TourSelectionViewController

- (IBAction)logoutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
        NSLog(@"User is Logged Out");
    if (!currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        if ([navController.viewControllers.firstObject isKindOfClass:[ParseLoginViewController class]]) {
            ParseLoginViewController *loginVC = (ParseLoginViewController *)navController.viewControllers.firstObject;
            loginVC.completion = ^ {
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.view.frame.size.height < 500.0) {
        self.selectButtonTopConstraint.constant -= 40;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        if ([navController.viewControllers.firstObject isKindOfClass:[ParseLoginViewController class]]) {
            ParseLoginViewController *loginVC = (ParseLoginViewController *)navController.viewControllers.firstObject;
            loginVC.completion = ^ {
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}

- (IBAction)shareButton:(UIBarButtonItem *)sender {
    
    NSString *text = @"Checkout this Tour on Walkabout Tours in the App Store";

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text]
                                                                             applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop,
                                         ];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
