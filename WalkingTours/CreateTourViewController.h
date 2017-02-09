//
//  CreateTourViewController.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

typedef void(^EditToursCompletion)(void);

@interface CreateTourViewController : UIViewController

@property (strong, nonatomic) Tour *tour;
@property (strong, nonatomic) NSMutableArray<Location *> *locations;
@property (strong, nonatomic) NSMutableArray<UIImage *> *images;
@property (strong) EditToursCompletion editToursCompletion;

@end
