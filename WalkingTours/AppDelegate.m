//
//  AppDelegate.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"

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

@end
