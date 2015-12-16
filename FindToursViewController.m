//
//  FindToursViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "FindToursViewController.h"
#import "Location.h"
#import "Tour.h"
#import "Location.h"
#import "POIDetailTableViewCell.h"

@import UIKit;
@import CoreLocation;
@import MapKit;

@import Parse;
@import ParseUI;

@interface FindToursViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *toursTableView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSArray <Location*> *locationsFromParse;


@end

@implementation FindToursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self setupViewController];
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
                    self.locationsFromParse = [[NSArray alloc]init];
                    if (self.locationsFromParse.count > 0) {
                        [self.locationsFromParse arrayByAddingObject: location];
                    } else {
                        self.locationsFromParse = @[location];
                    }
                    [self.toursTableView reloadData];

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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1000.0, 1000.0);
    [self setRegionForCoordinate:region];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
    {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil; }
    
    // Add view.
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"AnnotationView"];
    annotationView.annotation = annotation;
    
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    //Add a detail disclosure button.
    annotationView.canShowCallout = true;
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    // Add a custom image to the callout.
    
//        UIImage *myCustomImage = [[UIImage alloc]initWithImage:[UIImage imageNamed:@"map-marker.png"]];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //Put the segue name here...
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
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


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
    {
    NSLog(@"%@", locations);
}
    
    
    #pragma mark - UITableView protocol functions.

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        if (self.locationsFromParse != nil) {
            return self.locationsFromParse.count;
            
        }
        return 0;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POIDetailTableViewCell *cell = (POIDetailTableViewCell*) [self.toursTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell"];
    [cell setLocation:[self.locationsFromParse objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end


