//
//  CustomAnnotation.h
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/17/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *tourId;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
