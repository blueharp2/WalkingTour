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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *stringUrl = [NSString stringWithFormat:@"%@", url];
    NSLog(@"This is the url: %@", url);
    
    if ([stringUrl containsString:@"walkabouttours://"]) {
        
            //Do something with the url
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *param1 = [self valueForKey:@"param1" fromQueryItems:queryItems];
        
        NSLog(@"%@", param1);
        NSLog(@"url recieved: %@", url);
        NSLog(@"query string: %@", [url query]);
        NSLog(@"host: %@", [url host]);
        NSLog(@"url path: %@", [url path]);
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSLog(@"query dict: %@", dict);
        }
    
    return YES;

    }

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
            NSURLQueryItem *queryItem = [[queryItems
                                          filteredArrayUsingPredicate:predicate]
                                         firstObject];
            return queryItem.value;
        }
        

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"walkabouttours"]) {
        NSString *query = [url query];
        if (query.length > 0) {
            NSArray *components = [query componentsSeparatedByString:@"&"];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            for (NSString *component in components) {
                NSArray *subcomponents = [component componentsSeparatedByString:@"="];
                [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                               forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            return YES;
        }
    }
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
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


