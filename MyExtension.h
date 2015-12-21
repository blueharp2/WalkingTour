//
//  MyExtension.h
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/17/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface MyExtension : NSObject <MKAnnotation> {
    NSString *tourId;
//    NSString *title;
}

@property (retain, readwrite, nonatomic) NSString *tourId;
//@property NSString *title;

@end
