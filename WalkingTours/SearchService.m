//
//  SearchService.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 2/11/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

#import "SearchService.h"

@implementation SearchService

+ (NSMutableArray*)findMatchesWithTerm:(NSString *)term arrayToSearch:(NSMutableArray *)arrayToSearch {
    
    NSMutableArray *matches = [NSMutableArray new];
    
    for (int i = 0; i < [arrayToSearch count]; i++) {
        
        NSString* stringToSearch = [[arrayToSearch objectAtIndex:i] objectForKey:@"name"];
        NSString* lowerCaseStringToSearch = [stringToSearch lowercaseStringWithLocale: [NSLocale currentLocale]];
        NSString* lowerCaseSearchTerm = [term lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        
            NSRange searchResult = [lowerCaseStringToSearch rangeOfString: lowerCaseSearchTerm];
        if (searchResult.location == NSNotFound) {
            NSLog(@"Search term string was not found");
        } else {
            NSLog(@"%@ starts at index %lu and is %lu characters long", lowerCaseSearchTerm, searchResult.location, searchResult.length);
            [matches addObject:[arrayToSearch objectAtIndex:i]];
        }
    }
    return matches;
}

@end
