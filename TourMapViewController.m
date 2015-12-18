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
#import "CustomAnnotation.h"

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
    
//    MKRoute *myRoute = [[MKRoute alloc] init];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    NSMutableArray<MKMapItem *> *placemarks;
    for (Location *location in locationsFromParse) {
        CustomAnnotation *newPoint = [[CustomAnnotation alloc]init];
        newPoint.coordinate = CLLocationCoordinate2DMake(location.location.latitude, location.location.longitude);
        newPoint.title = location.locationName;
//        newPoint.subtitle = location.objectId;
        newPoint.tourId = location.objectId;
        
        [self.mapView addAnnotation:newPoint];
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(location.location.latitude, location.location.longitude) addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        if (placemarks.count == 0) {
            placemarks = [NSMutableArray arrayWithObject:mapItem];
        } else {
            [placemarks addObject:mapItem];
        }
        
        //Create Dictionary..
        if (_locationsWithObjectId) {
            [_locationsWithObjectId setObject:location forKey:location.objectId];
        } else {
            _locationsWithObjectId = [NSMutableDictionary dictionaryWithObject:location forKey:location.objectId];
        }
    }
    
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    for (int i = 0; i < placemarks.count - 1; i++) {
        [directionsRequest setSource:placemarks[i]];
        [directionsRequest setDestination:placemarks[i+1]];
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedFailureReason);
            }
            if (response) {
                MKRoute *route = response.routes[0];
                [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            }
        }];
    }
}


//var myRoute : MKRoute?
//var directionsRequest = MKDirectionsRequest()
//var placemarks = [MKMapItem]()
//for item in list {
//    var placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(item["location"]["coordinate"]["x"].doubleValue), longitude: CLLocationDegrees(item["location"]["coordinate"]["y"].doubleValue)), addressDictionary: nil )
//    placemarks.append(MKMapItem(placemark: placemark))
//}
//directionsRequest.transportType = MKDirectionsTransportType.Automobile
//for (k, item) in enumerate(placemarks) {
//    if k < (placemarks.count - 1) {
//        directionsRequest.setSource(item)
//        directionsRequest.setDestination(placemarks[k+1])
//        var directions = MKDirections(request: directionsRequest)
//        directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.myRoute = response.routes[0] as? MKRoute
//                self.mapView.addOverlay(self.myRoute?.polyline)
//            }
//        }
//    }
//}

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

//   Location* selectedLocation = [self.locationsWithObjectId objectForKey:(view.annotation.subtitle)];
    if ([view.annotation isKindOfClass:[CustomAnnotation class]]) {
        
        CustomAnnotation *annotation = (CustomAnnotation *)view.annotation;
        
        Location* selectedLocation = [self.locationsWithObjectId objectForKey: annotation.tourId];
        
        [self performSegueWithIdentifier:@"TourDetailViewController" sender:selectedLocation];
        
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    lineView.strokeColor = [UIColor blueColor];
    lineView.lineWidth = 5.0;
    return lineView;
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
