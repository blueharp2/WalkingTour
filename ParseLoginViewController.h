//
//  ParseLoginViewController.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ParseLoginViewControllerCompletion)();

@interface ParseLoginViewController : UIViewController

@property (copy, nonatomic) ParseLoginViewControllerCompletion completion;

@end
