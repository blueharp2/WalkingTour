//
//  FourSquareService.m
//  GoTime
//
//  Created by Alberto Vega Gonzalez on 12/31/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "FourSquareService.h"

@import UIKit;

NSString const *foursquareAPIClientID = @"WCL0RABF5CUS0QDEHIJPJEQZEOTI42I4GR0Y0K2CQ4KJGXHA";
NSString const *foursquareAPIClientSecret = @"G0GCYUZBQU1ZLRICJGNJFOZNOMPHLTY1CKTDV23DGMS5U3XT";

NSString const *foursquareVenueSearchURL = @"https://api.foursquare.com/v2/venues/search";
NSString const *cfLatLong = @"47.625114,-122.335874";
NSString const *apiVersion = @"20160211";
NSString const *mode = @"foursquare";
int const radius = 250;


@implementation FourSquareService

+(void)searchVenueWithLatitude:(double)latitude longitude:(double)longitude completion:(nonnull void (^)(BOOL success, NSData * _Nullable data))completionHandler
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&ll=%@,%@&v=%@&m=%@&intent=browse&radius=%@", foursquareVenueSearchURL,foursquareAPIClientID, foursquareAPIClientSecret, [NSString stringWithFormat:@"%f",latitude], [NSString stringWithFormat:@"%f", longitude], apiVersion, mode, [NSString stringWithFormat:@"%i", radius]];
    
    if (urlString != nil) {
        
        NSURL *URL =[NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
        request.HTTPMethod = @"GET";
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data != nil) {
                completionHandler(true, data);
            }
            
            if (error != nil) {
                if (response != nil) {
                    NSLog(@"My error with code: %@", (NSHTTPURLResponse *)response);
                }
            }
            
            completionHandler(false, nil);
        }];
        [task resume];
    }
}


+(void)searchVenueAddress:(NSString *)queryString latitude:(double)latitude longitude:(double)longitude completion:(void (^)(BOOL, NSData * _Nullable))completionHandler
{
   
    //  This is the url I need to get
    //    https://api.foursquare.com/v2/venues/search?ll=47.6861009,-122.3791101&query=Thai Siam Restaurant&intent=search&radius=250
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&ll=%@,%@&v=%@&m=%@&query=%@&intent=search&radius=%@", foursquareVenueSearchURL,foursquareAPIClientID, foursquareAPIClientSecret, [NSString stringWithFormat:@"%f",latitude], [NSString stringWithFormat:@"%f", longitude], apiVersion, mode, queryString, [NSString stringWithFormat:@"%i", radius]];
    
    if (urlString) {
        
        NSURL *URL =[NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
        request.HTTPMethod = @"GET";
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (data) {
                completionHandler(true, data);
            }
            
            if (error) {
                if (response != nil) {
                    NSLog(@"My error with code: %@", (NSHTTPURLResponse *)response);
                }
            }
            
            completionHandler(false, nil);
        }];
        [task resume];
    }
}


+(void)searchVenues:(NSString *)queryString completion:(void (^)(BOOL, NSData * _Nullable))completionHandler
{

    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&ll=%@&v=%@m=%@&query=%@", foursquareVenueSearchURL, foursquareAPIClientID, foursquareAPIClientSecret, cfLatLong, apiVersion,mode, queryString];

    if (urlString != nil) {
        
        NSURL *URL =[NSURL URLWithString:urlString];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
        request.HTTPMethod = @"GET";
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (data != nil) {
                completionHandler(true, data);
                 }
            
            if (error != nil) {
                if (response != nil) {
                    NSLog(@"My error with code: %@", (NSHTTPURLResponse *)response);
                }
            }
            
            completionHandler(false, nil);
                }];
        [task resume];
    }
}

+(void)parseVenueResponse:(NSData *)data completion:(void (^)(BOOL, NSMutableArray * _Nullable))completionHandler
{
    NSError *error = nil;
    if (data)
    {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    
    if (json != nil && [json isKindOfClass:[NSDictionary class]])
    {
        NSMutableArray *addressesFromFoursquare = [NSMutableArray new];
        NSDictionary *response = [(NSDictionary*)json objectForKey:@"response"];
        NSArray *venues = response[@"venues"];
        
        if ([venues count] > 0)
        {
            for (int i=0; i<[venues count]; i++)
            {
                NSString *name = [[venues objectAtIndex:i] objectForKey:@"name"];
                NSDictionary *location = [[venues objectAtIndex:i] objectForKey:@"location"];
                NSArray *address = location[@"formattedAddress"];
                NSString *completeAddress = [address componentsJoinedByString:@", "];
                
                if (name && location && address) {
                    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys: name, @"name",  completeAddress, @"address", nil];
                    if (result) {
                        [addressesFromFoursquare addObject:result];

                    } else { NSLog(@"Results is nil"); }

                } else {
                    NSLog(@"Failed to parse JSON properties"); return; }
                            }
//            completionHandler(true, addressesFromFoursquare);
        } else {
            NSLog(@"Foursquare JSON contains 0 venues");
        }
        completionHandler(true, addressesFromFoursquare);

    }
//        completionHandler(true, addressesFromFoursquare);

}
//    completionHandler(true, addressesFromFoursquare);

}
@end
