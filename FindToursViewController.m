//
//  FindToursViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "FindToursViewController.h"
#import "TourMapViewController.h"
#import "TourListViewController.h"
#import "Location.h"
#import "Tour.h"
#import "Location.h"
#import "POIDetailTableViewCell.h"
#import "ParseService.h"

@import UIKit;
@import CoreLocation;
@import MapKit;

@import Parse;
@import ParseUI;

@interface FindToursViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *toursTableView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSArray <Tour*> *toursFromParse;
-(void)setToursFromParse:(NSArray<Tour *> *)toursFromParse;


@end

@implementation FindToursViewController

- (void)setToursFromParse:(NSArray<Tour *> *)toursFromParse {
    _toursFromParse = toursFromParse;
    
    for (Tour *tour in toursFromParse) {
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = CLLocationCoordinate2DMake(tour.startLocation.latitude, tour.startLocation.longitude);
        newPoint.title = tour.nameOfTour;
        newPoint.subtitle = tour.objectId;
        
        [self.mapView addAnnotation:newPoint];
        [self.toursTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Location Manager setup
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    
    [self setupViewController];
    
    // Gets user location and set map region
    CLLocation *location = [self.locationManager location];
    [self setMapForCoordinateWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    //    CLLocationCoordinate2D coordinate = [location coordinate];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.624441, -122.335913);
    
    
    [ParseService fetchToursNearLocation:coordinate completion:^(BOOL success, NSArray *results) {
        if (success) {
            [self setToursFromParse:results];
            [self.toursTableView reloadData];
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

- (void)setupViewController
{
    //Setup tableView
    [self.toursTableView setDelegate:self];
    [self.toursTableView setDataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"POIDetailTableViewCell" bundle:nil];
    [[self toursTableView] registerNib:nib forCellReuseIdentifier:@"POIDetailTableViewCell"];
    
    //Setup up MapView
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation: YES];
    
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Add view.
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"AnnotationView"];
    annotationView.annotation = annotation;
    
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    
    //Add a detail disclosure button.
    annotationView.canShowCallout = true;
    annotationView.animatesDrop = true;
    annotationView.pinTintColor = [UIColor orangeColor];
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    // Add a custom image to the callout.
    
    //        UIImage *myCustomImage = [[UIImage alloc]initWithImage:[UIImage imageNamed:@"map-marker.png"]];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"TabBarController" sender:view];
    
}

#pragma mark - CLLocationManager

-(void) startStandardUpdates
{
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 100; // meters
    
    [_locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@", locations);
}


#pragma mark - UITableView protocol functions.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.toursFromParse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    POIDetailTableViewCell *cell = (POIDetailTableViewCell*) [self.toursTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell"];
    [cell setTour:[self.toursFromParse objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tourId = self.toursFromParse[indexPath.row].objectId;
    [self performSegueWithIdentifier:@"TabBarController" sender:tourId];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TabBarController"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            UITabBarController *tabBar = (UITabBarController *)segue.destinationViewController;
            
            TourMapViewController *tourMapViewController = (TourMapViewController *)tabBar.viewControllers.firstObject;
            TourListViewController *tourListViewController = (TourListViewController *)tabBar.viewControllers[1];
            
            [tourMapViewController setCurrentTour:annotationView.annotation.subtitle];
            
        } else {
            
            UITabBarController *tabBar = (UITabBarController *)segue.destinationViewController;
            
            TourMapViewController *tourMapViewController = (TourMapViewController *)tabBar.viewControllers.firstObject;
            TourListViewController *tourListViewController = (TourListViewController *)tabBar.viewControllers[1];
            
            if ([sender isKindOfClass:[NSString class]]) {
                [tourMapViewController setCurrentTour:sender];
            }
        }
    }
}



@end


