//
//  SearchService.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import "SearchService.h"

@implementation SearchService

+ (NSMutableArray*)findMatchesWithTerm:(NSString *)term arrayToSearch:(NSMutableArray *)arrayToSearch {
    
    NSMutableArray *matches = [NSMutableArray new];
    NSMutableDictionary *unableToLocateVenue = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Unable to locate venue", @"name",  @"", @"address", nil];
    
    for (int i = 0; i < [arrayToSearch count]; i++) {
        
        NSString* stringToSearch = [[arrayToSearch objectAtIndex:i] objectForKey:@"name"];
        NSString* lowerCaseStringToSearch = [stringToSearch lowercaseStringWithLocale: [NSLocale currentLocale]];
        NSString* lowerCaseSearchTerm = [term lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        NSRange searchResult = [lowerCaseStringToSearch rangeOfString: lowerCaseSearchTerm];
        if (searchResult.location == NSNotFound) {
            NSLog(@"Search term string was not found");
        } else {
            [matches addObject:[arrayToSearch objectAtIndex:i]];
        }
    }
    if (matches.count == 0) {
        [matches addObject:unableToLocateVenue];
    }
    return matches;
}

@end
