//
//  FindToursViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "FindToursViewController.h"
@import CoreLocation;
@import MapKit;

@interface FindToursViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *toursTableView;

@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation FindToursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation: YES];
//    [self.mapView.layer setCornerRadius:20.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [_locationManager stopMonitoringSignificantLocationChanges];
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
    
    
    #pragma mark - tableView

    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 8;
    }


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


