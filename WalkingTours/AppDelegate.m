//
//  AppDelegate.m
//  WalkingTours
//
//  Created by Lindsey on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        NSString *stringUrl = [NSString stringWithFormat:@"%@", url];
        NSLog(@"This is the url: %@", url);
    if ([stringUrl containsString:@"walkabouttours://"]) {
        
            NSLog(@"Full URL: %@", [url absoluteString]);
            NSLog(@"Scheme: %@", [url scheme]);
            NSLog(@"Query String: %@", [url query]);
            NSLog(@"host: %@", [url host]);
            NSLog(@"url path: %@", [url path]);
            NSDictionary *dict = [self parseQueryString:[url query]];
            NSLog(@"query dict: %@", dict);
        
        }
    return YES;
}

- (BOOL)schemeAvailable:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:scheme];

        NSLog(@"Full URL: %@", [url absoluteString]);
        NSLog(@"Scheme: %@", [url scheme]);
        NSLog(@"Query String: %@", [url query]);
        NSLog(@"host: %@", [url host]);
        NSLog(@"url path: %@", [url path]);
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSLog(@"query dict: %@", dict);
    
    return [application canOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    NSString *sourceApplication = [NSString stringWithFormat:@"%@", url];
//    NSLog("Called By: %@", [url sourceApplication]);
    NSLog(@"Scheme: %@", [url scheme]);
    NSLog(@"Query String: %@", [url query]);
    
    if (!url) {  return NO; }
    
    NSString *URLString = [url absoluteString];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"There's no URL", nil)
                          message:URLString
                          delegate:self
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];

    return YES;
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
            NSURLQueryItem *queryItem = [[queryItems
                                          filteredArrayUsingPredicate:predicate]
                                         firstObject];
            return queryItem.value;
        }


- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (IBAction)getTest:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"myappscheme://test_page/one?token=12345&domain=foo.com"]];
}


@end


