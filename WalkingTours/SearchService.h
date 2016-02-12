//
//  SearchService.h
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 2/11/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchService : NSObject

+ (NSMutableArray*)findMatchesWithTerm:(NSString*)term arrayToSearch:(NSMutableArray*)arrayToSearch;

@end
