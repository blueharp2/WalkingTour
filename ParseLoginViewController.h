//
//  ParseLoginViewController.h
//  WalkingTours
//
//  Created by Cynthia Whitlatch on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ParseLoginViewControllerCompletion)();

@interface ParseLoginViewController : UIViewController

@property (copy, nonatomic) ParseLoginViewControllerCompletion completion;

@end
