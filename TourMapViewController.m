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
@property (strong, nonatomic) Tour *currentTour;
@property (strong, nonatomic) NSArray <Location*> *locationsFromParse;

@end

@implementation TourMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation: YES];

    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];

    //    [self login];
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    // Get user location.
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [self setMapForCoordinateWithLatitude:userLocation.latitude andLongitude:userLocation.longitude];
    
    //find locations near user location.
    [query whereKey:@"location" nearGeoPoint:userLocation];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            Location *location = (Location *)object;
            
            PFQuery *tourQuery = [PFQuery queryWithClassName:@"Tour"];
            [tourQuery whereKey:@"objectId" equalTo:location.tour.objectId];
            [tourQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if ([object isKindOfClass:[Tour class]]) {
                    location.tour = (Tour *)object;
                    NSLog(@"%@", location.tour.nameOfTour);
                    Tour *tour = (Tour *)object;
                    NSLog(@"%@", tour.nameOfTour);
                    
                    
//                    CLLocationCoordinate2D touchMapCoordinate = [self.locationMapView convertPoint:touchPoint toCoordinateFromView:self.locationMapView];
                    
                    MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
                    PFGeoPoint *newLocation = [PFGeoPoint geoPointWithLatitude: tour.startLocation.latitude longitude:tour.startLocation.longitude];

                    newPoint.title = tour.nameOfTour;
                    
                    [self.mapView addAnnotation:newPoint];
                    [self.mapView  addAnnotation: newLocation];

                    self.locationsFromParse = [[NSArray alloc]init];
                    if (self.locationsFromParse.count > 0) {
                        [self.locationsFromParse arrayByAddingObject: location];
                    } else {
                        self.locationsFromParse = @[location];
                    }
                    
                }
            }];
            
            
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

- (void) createMapAnnotation {


}

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
