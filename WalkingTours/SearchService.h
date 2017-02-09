//
//  SearchService.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchService : NSObject

+ (NSMutableArray*)findMatchesWithTerm:(NSString*)term arrayToSearch:(NSMutableArray*)arrayToSearch;

@end
