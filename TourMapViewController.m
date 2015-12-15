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

@import UIKit;
@import MapKit;
@import CoreLocation;

@interface TourMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation TourMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation: YES];

    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [self.locationManager requestLocation];
 
    // Get user location.
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    
    //find locations near user location.
    [query whereKey:@"location" nearGeoPoint:userLocation];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                
                for (PFObject *object in objects) {
                    
                    NSString *locationName = object[@"locationName"];
                    NSString *locationDescription = object[@"locationDescription"];
                    NSArray *categories = object[@"categories"];
                    
                    PFGeoPoint *geopoint = (PFGeoPoint *)object[@"location"];
                    Tour *tour = (Tour *)object[@"tour"];
                }
            }
            
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_locationManager stopMonitoringSignificantLocationChanges];
}

- (void)setRegionForCoordinate:(MKCoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];
}

- (void)setMapForCoordinateWithLatitude: (double)lat  andLongitude:(double)longa {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, longa);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 2000.0, 2000.0);
    [self setRegionForCoordinate:region];
}
#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil; }
    
    // Add view.
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"AnnotationView"];
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    //Add a detail disclosure button.
    annotationView.canShowCallout = true;
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    // Add a custom image to the callout.
    
//    UIImage *myCustomImage = [[UIImage alloc]initWithImage:[UIImage imageNamed:@"MyCustomImage.png"]];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //Put the segue name here...
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
}

//Uncomment this one if you want an overlay circle around the pin.

//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
//    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
//    circleRenderer.strokeColor = [UIColor blueColor];
//    circleRenderer.fillColor = [UIColor redColor];
//    circleRenderer.alpha = 0.5;
//    return circleRenderer;
//}

#pragma mark - CLLocationManager

-(void) startStandardUpdates
{
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 500; // meters
    
    [_locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TourDetailViewController"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            TourDetailViewController *tourDetailViewController = (TourDetailViewController *)segue.destinationViewController;
            
        }
    }    // Pass the selected object to the new view controller.
}


@end
