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
#import "MyExtension.h"
#import "CustomAnnotation.h"
@import Parse;
@import ParseUI;

@interface FindToursViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *toursTableView;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray <id> *mapPoints;
@property (strong, nonatomic) NSArray <Tour*> *toursFromParse;
-(void)setToursFromParse:(NSArray<Tour *> *)toursFromParse;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopConstraint;
@property (weak, nonatomic) IBOutlet UISearchBar *keywordSearchBar;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UITableView *searchCategoryTableView;
@property (strong, nonatomic) NSArray *categoryList;
- (IBAction)radiusSliderChanged:(UISlider *)sender;

@end

@implementation FindToursViewController

- (void)setToursFromParse:(NSArray<Tour *> *)toursFromParse {
    _toursFromParse = toursFromParse;
    
    for (Tour *tour in toursFromParse)
    {
        CustomAnnotation *newPoint = [[CustomAnnotation alloc]init];
        newPoint.coordinate = CLLocationCoordinate2DMake(tour.startLocation.latitude, tour.startLocation.longitude);
        newPoint.title = tour.nameOfTour;
        newPoint.tourId = tour.objectId;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newPoint.coordinate.latitude longitude:newPoint.coordinate.longitude];
        
        if (self.mapPoints.count == 0) {
            self.mapPoints = [NSMutableArray arrayWithObject:location];
        } else {
            [self.mapPoints addObject:location];
        }
        
        [self.mapView addAnnotation:newPoint];
        [self.toursTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchViewTopConstraint.constant = self.view.frame.size.height;
    self.radiusSlider.hidden = YES;
    //Location Manager setup
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self setUpSearchButton];
    [self setupViewController];
}

- (void)fetchToursNearUser {
    CLLocation *location = [self.locationManager location];
    [self setMapForCoordinateWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    
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
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)setUpSearchButton {
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed:)];
    self.navigationItem.rightBarButtonItem = self.searchButton;
}

- (void)setupViewController {
    //Setup tableView
    [self.toursTableView setDelegate:self];
    [self.toursTableView setDataSource:self];
    self.searchCategoryTableView.delegate = self;
    self.searchCategoryTableView.dataSource = self;
    self.categoryList = @[@"Restaurant", @"Cafe", @"Art", @"Museum", @"History", @"Shopping", @"Nightlife", @"Film", @"Education"];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBackground.png"]];
    [tempImageView setFrame:self.toursTableView.frame];
    
    UINib *nib = [UINib nibWithNibName:@"POIDetailTableViewCell" bundle:nil];
    [[self toursTableView] registerNib:nib forCellReuseIdentifier:@"POIDetailTableViewCell"];
    
    //Setup up MapView
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation: YES];
    
}

- (void)searchButtonPressed:(UIBarButtonItem *)sender {
    if (self.searchViewTopConstraint.constant == -60) {
        //Handle if the search view is open
    } else {
        self.radiusSlider.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.searchViewTopConstraint.constant = -60;
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)radiusSliderChanged:(UISlider *)sender {
    self.radiusLabel.text = [NSString stringWithFormat:@"%.1f", sender.value];
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
    annotationView.pinTintColor = [UIColor colorWithRed:0.278 green:0.510 blue:0.855 alpha:1.000];
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
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

- (void)startSignificantChangeUpdates {
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mapView setShowsUserLocation:YES];
        MKCoordinateRegion currentRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 300, 300);
        [self.mapView setRegion:currentRegion];
        [self fetchToursNearUser];
//        [self testQuery];
    }
}

//- (void)testQuery {
//    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(47.561137, -122.386794);
    //Generic search (without categories or search term) working.
//    [ParseService searchToursNearLocation:location withinMiles:1.0 withSearchTerm:nil completion:^(BOOL success, NSArray *results) {
//        if (success) {
//            for (Tour *tour in results) {
//                NSLog(@"%@", tour.objectId);
//            }
//        }
//    }];
    
    //Full search (with one category and no search term) working
//    [ParseService searchToursNearLocation:location withinMiles:1.0 withSearchTerm:nil categories:@[@"Cafe"] completion:^(BOOL success, NSArray *results) {
//        if (success) {
//            for (Tour *tour in results) {
//                NSLog(@"%@", tour.objectId);
//            }
//        }
//    }];
    
//    Generic search (without categories, with search term) working.
//    [ParseService searchToursNearLocation:location withinMiles:1.0 withSearchTerm:@"Sushi" completion:^(BOOL success, NSArray *results) {
//        if (success) {
//            for (Tour *tour in results) {
//                NSLog(@"%@", tour.objectId);
//            }
//        }
//    }];
    
    //Full search (with two categories and a search term)working
//        [ParseService searchToursNearLocation:location withinMiles:1.0 withSearchTerm:@"West" categories:@[@"Cafe", @"Restaurant"] completion:^(BOOL success, NSArray *results) {
//            if (success) {
//                for (Tour *tour in results) {
//                    NSLog(@"%@", tour.objectId);
//                }
//            }
//        }];
//}

#pragma mark - UITableView protocol functions.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 0) {
        return self.toursFromParse.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return 1;
    } else {
        return self.categoryList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return 5.0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    if (tableView.tag == 0) {
        [headerView setBackgroundColor:[UIColor clearColor]];
        return headerView;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        POIDetailTableViewCell *cell = (POIDetailTableViewCell*) [self.toursTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell"];
        [cell setTour:[self.toursFromParse objectAtIndex:indexPath.section]];
        
        return cell;
    } else {
        UITableViewCell *cell = [self.searchCategoryTableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell" forIndexPath:indexPath];
        cell.textLabel.font = [UIFont fontWithName:@"Futura" size:17.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.510 blue:0.855 alpha:1.000];
        cell.textLabel.text = self.categoryList[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        NSString *tourId = self.toursFromParse[indexPath.section].objectId;
        [self performSegueWithIdentifier:@"TabBarController" sender:tourId];
    } else {
        //what to do?
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TabBarController"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            UITabBarController *tabBar = (UITabBarController *)segue.destinationViewController;
            
            TourMapViewController *tourMapViewController = (TourMapViewController *)tabBar.viewControllers.firstObject;
            TourListViewController *tourListViewController = (TourListViewController *)tabBar.viewControllers[1];
            
            if ([annotationView.annotation isKindOfClass:[CustomAnnotation class]]) {
                CustomAnnotation *annotation = (CustomAnnotation *)annotationView.annotation;
                
                // ...
                [tourMapViewController setCurrentTour:annotation.tourId];
                [tourListViewController setCurrentTour:annotation.tourId];
            }
            
        } else {
            
            UITabBarController *tabBar = (UITabBarController *)segue.destinationViewController;
            
            TourMapViewController *tourMapViewController = (TourMapViewController *)tabBar.viewControllers.firstObject;
            TourListViewController *tourListViewController = (TourListViewController *)tabBar.viewControllers[1];
            
            if ([sender isKindOfClass:[NSString class]]) {
                [tourMapViewController setCurrentTour:sender];
                [tourListViewController setCurrentTour:sender];
            }
        }
    }
}

@end


