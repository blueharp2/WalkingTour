//
//  FourSquareService.h
//  GoTime
//
//  Created by Alberto Vega Gonzalez on 12/31/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareService : NSObject

+(void)searchVenueWithLatitude:(double)latitude longitude:(double)longitude completion:(nonnull void (^)(BOOL success, NSData * _Nullable data))completionHandler;


+(void)searchVenueAddress:(NSString * _Nullable)queryString latitude: (double)latitude longitude:(double)longitude completion:(nonnull void (^)(BOOL success, NSData * _Nullable data))completionHandler;

+(void)searchVenues:(NSString * _Nullable)queryString completion:(nonnull void (^)(BOOL success ,  NSData *_Nullable data))completionHandler;

+ (void)parseVenueResponse:(NSData * _Nullable)data completion:(nonnull void (^) (BOOL success, NSMutableArray *_Nullable addressesFromFoursquare))completionHandler;




@end
