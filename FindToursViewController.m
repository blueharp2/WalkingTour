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
    [self setupViewController];
    
//    [self login];
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    // Get user location.
    [self.locationManager requestLocation];
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    //find locations near user location.
    [query whereKey:@"location" nearGeoPoint:userLocation];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                
                NSString *locationName = object[@"locationName"];
                NSString *locationDescription = object[@"locationDescription"];
                NSArray *categories = object[@"categories"];
                
                PFGeoPoint *geopoint = (PFGeoPoint *)object[@"location"];
                Tour *tour = (Tour *)object[@"tour"];
//                tour.nameOfTour = tour[@];
//                tour.descriptionText;
//                tour.startLocation;
//                tour.user;
                
                
//                Location *location = [[Location alloc]initWithLocationName:locationName locationDescription:<#(NSString *)#> photo:<#(PFFile *)#> categories:<#(NSArray *)#> location:geopoint tour:<#(Tour *)#>]
            }
            
//            NSLog(@"Succesfully retrieved %lu locations.", objects.count);
//            self.locationsFromParse = [[NSArray alloc] initWithArray:objects];
//            for ( Location *location in self.locationsFromParse) {
//                CLLocationCoordinate2D parsedLocation = CLLocationCoordinate2DMake(location.location.latitude, location.location.longitude);
//                
////                __weak typeof (self) weakSelf = self;
//                
//                MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
//                newPoint.coordinate = parsedLocation;
//                newPoint.title = @"Test Location";
//                
//                [self.mapView addAnnotation:newPoint];

//            }
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
    
    
    #pragma mark - UITableView protocol functions.

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        if (self.locationsFromParse != nil) {
            return self.locationsFromParse.count;
            
        }
        return 0;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POIDetailTableViewCell *cell = (POIDetailTableViewCell*) [self.toursTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell"];
    cell.location = [self.locationsFromParse objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end


