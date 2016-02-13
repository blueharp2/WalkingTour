//
//  AppDelegate.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "TourSelectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"gTNFHvvUfoDGWmSRmn4OkYyRLwsQFbxXaQlzs5hI" clientKey:@"MSGmInhjhYcK8SQ1XMnXpewwiLBHqEiul1py2x8i"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [[Fabric sharedSDK] setDebug: YES];
    [Fabric with:@[[Crashlytics class]]];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *stringUrl = [NSString stringWithFormat:@"%@", url];
//            The url for the cafe tour I created would
//            look like this: walkabouttours://id=hacwySWrn7
    if ([stringUrl containsString:@"walkabouttours://id="]) {
        NSString *tourId = [stringUrl stringByReplacingOccurrencesOfString:@"walkabouttours://id=" withString:@""];
        //Set id to be the loadedId on the homeVC
        if ([self.window.rootViewController isKindOfClass:[TourSelectionViewController class]]) {
            TourSelectionViewController *selectionVC = (TourSelectionViewController *)self.window.rootViewController;
            selectionVC.linkedTour = tourId;
        }
        
    }
    return YES;
}

@end
