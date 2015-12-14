//
//  TourMapViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourMapViewController.h"
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

    // Do any additional setup after loading the view.
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
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_locationManager dequeReusableAnnotationViewWithIdentifier: ];
    }
}

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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
