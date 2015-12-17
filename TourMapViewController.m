//
//  TourMapViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourMapViewController.h"
#import "TourDetailViewController.h"
#import "Tour.h"
#import "Location.h"
#import "ParseService.h"

@import UIKit;
@import MapKit;
@import CoreLocation;


@interface TourMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) Tour *currentTour;
@property (strong, nonatomic) NSArray <Location*> *locationsFromParse;
@property (strong, nonatomic) NSMutableDictionary *locationsWithObjectId;

@end

@implementation TourMapViewController

- (void)setCurrentTour:(NSString*)currentTour {
    _currentTour = currentTour;
    
    [ParseService fetchLocationsWithTourId:currentTour completion:^(BOOL success, NSArray *results) {
        if (success) {
            [self setLocationsFromParse:results];
        }
    }];
}

- (void)setLocationsFromParse:(NSArray<Location *> *)locationsFromParse {
    _locationsFromParse = locationsFromParse;
    
    for (Location *location in locationsFromParse) {
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = CLLocationCoordinate2DMake(location.location.latitude, location.location.longitude);
        newPoint.title = location.locationName;
        newPoint.subtitle = location.objectId;
        
        [self.mapView addAnnotation:newPoint];
        
        //Create Dictionary..
        if (_locationsWithObjectId) {
            [_locationsWithObjectId setObject:location forKey:location.objectId];
        } else {
            _locationsWithObjectId = [NSMutableDictionary dictionaryWithObject:location forKey:location.objectId];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation: YES];
    
    //Location Manager setUp
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    
    // Gets user location and set map region
    CLLocation *location = [self.locationManager location];
    [self setMapForCoordinateWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)setRegionForCoordinate:(MKCoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];
}

- (void)setMapForCoordinateWithLatitude: (double)lat  andLongitude:(double)longa {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, longa);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 700.0, 700.0);
    [self setRegionForCoordinate:region];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Add view.
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"AnnotationView"];
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    
    //Add a detail disclosure button.
    annotationView.canShowCallout = true;
    annotationView.animatesDrop = true;
    annotationView.pinTintColor = [UIColor orangeColor];
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    // Add a custom image to the callout.
    
    //    UIImage *myCustomImage = [[UIImage alloc]initWithImage:[UIImage imageNamed:@"MyCustomImage.png"]];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

   Location* selectedLocation = [self.locationsWithObjectId objectForKey:(view.annotation.subtitle)];
    
    [self performSegueWithIdentifier:@"TourDetailViewController" sender:selectedLocation];

}

#pragma mark - CLLocationManager

-(void) startStandardUpdates {
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 100; // meters
    
    [_locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates {
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@", locations);
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TourDetailViewController"]) {
            TourDetailViewController *tourDetailViewController = (TourDetailViewController *)segue.destinationViewController;
        if ([sender isKindOfClass: [Location class]]) {
            
            Location *location = (Location *)sender;
            
            Location* selectedLocation = [_locationsWithObjectId objectForKey:(location.objectId)];
            NSLog(@"%@",selectedLocation);
            [tourDetailViewController setLocation:selectedLocation];

        }
    }
}


@end
