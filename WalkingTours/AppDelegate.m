//
//  AppDelegate.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
@import CoreLocation;
#import "Tour.h"
#import "Location.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"gTNFHvvUfoDGWmSRmn4OkYyRLwsQFbxXaQlzs5hI"
                  clientKey:@"MSGmInhjhYcK8SQ1XMnXpewwiLBHqEiul1py2x8i"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    [self addTestModelsToParse];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)addTestModelsToParse {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(47.623544, -122.336224);
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
    Tour *tour1 = [[Tour alloc] initWithClassName:@"Tour" nameOfTour:@"Not very exciting." descriptionText:@"This is the tour description" startLocation:geoPoint user:nil];
    Location *location1 = [[Location alloc] initWithClassName:@"Location" locationName:@"Code Fellows" locationDescription:@"This is where we practically live" photo:nil categories:@[@"School", @"Education"] location:geoPoint tour:tour1];
    PFGeoPoint *geoPoint2 = [PFGeoPoint geoPointWithLatitude:47.627825 longitude:-122.337412];
    Location *location2 = [[Location alloc] initWithClassName:@"Location" locationName:@"The Park" locationDescription:@"I remember what the sun was like..." photo:nil categories:@[@"Park", @"Not Coding"] location:geoPoint2 tour:tour1];
    NSArray *objectArray = [NSArray arrayWithObjects:tour1, location1, location2, nil];
    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"They saved!");
        } else {
            NSLog(@"Something went terribly wrong.");
        }
    }];
}

@end
