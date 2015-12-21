//
//  CreateTourDetailViewController.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourDetailViewController.h"
#import "CategoryTableViewCell.h"
#import "CreateTourViewController.h"
@import MobileCoreServices;
@import CoreLocation;
@import CoreMedia;
@import AVFoundation;
@import Parse;
@import MapKit;

static const NSArray *categories;

@interface CreateTourDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIView *greyOutView;
@property (strong, nonatomic) UITableView *categoryTableView;
//@property (strong, nonatomic) UIButton *finalSaveButton;
//@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSMutableArray *selectedCategories;
@property (strong, nonatomic) PFFile *videoFile;
@property (strong, nonatomic) PFFile *photoFile;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) PFGeoPoint *geoPoint;
@property (strong, nonatomic) Location *createdLocation;
@property (strong, nonatomic) MKPointAnnotation *mapPinAnnotation;
@property (strong, nonatomic) UIColor *navBarTintColor;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationDescriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *pinDropReminderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonBottomConstraint;
- (IBAction)cameraButtonPressed:(UIButton *)sender;
- (IBAction)saveButtonPressed:(UIButton *)sender;

@end

@implementation CreateTourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.image = [UIImage imageNamed:@"idaho.jpg"];
    
//    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveLocation:)];
//    self.navigationItem.rightBarButtonItem = self.saveButton;
//    self.saveButton.enabled = NO;
    
    self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width / 2;
    
    self.locationNameTextField.hidden = YES;
    self.locationDescriptionTextField.hidden = YES;
    self.cameraButton.hidden = YES;
    self.locationNameTextField.alpha = 0.0;
    self.locationDescriptionTextField.alpha = 0.0;
    self.cameraButton.alpha = 0.0;
    
    self.navigationController.delegate = self;
    
    [self setUpGreyOutView];
    self.mapView.delegate = self;
    [self requestPermissions];
    [self.locationManager setDelegate:self];
    
    self.locationNameTextField.delegate = self;
    self.locationDescriptionTextField.delegate = self;
    
    UIColor *tintColor = self.navigationController.navigationBar.tintColor;
    self.navBarTintColor = tintColor;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.951 alpha:1.000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - Setup Functions

- (void)setCategoryOptions {
    categories = @[@"Restaurant", @"Cafe", @"Art", @"Museum", @"History", @"Shopping", @"Nightlife", @"Film", @"Education"];
}

- (void)setUpGreyOutView {
    self.greyOutView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    self.greyOutView.backgroundColor = [UIColor colorWithWhite:0.737 alpha:0.500];
    [self.greyOutView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.greyOutView];
//    [self setUpFinalSaveButton];
    [self setUpTableView];
}

//- (void)setUpFinalSaveButton {
//    self.finalSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
//    self.finalSaveButton.titleLabel.font = [UIFont fontWithName:@"Futura" size:20];
//    [self.finalSaveButton setTitle:@"Save" forState:UIControlStateNormal];
//    [self.finalSaveButton setTitleColor:[UIColor colorWithRed:0.278 green:0.510 blue:0.855 alpha:1.000] forState:UIControlStateNormal];
//    [self.finalSaveButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:self.finalSaveButton];
//    [self.finalSaveButton addTarget:self action:@selector(saveLocationWithCategories:) forControlEvents:UIControlEventTouchUpInside];
//    self.finalSaveButton.hidden = YES;
//}

- (void)setUpTableView {
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0) style:UITableViewStyleGrouped];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.categoryTableView.frame.origin.x -40, self.categoryTableView.frame.origin.y, self.categoryTableView.frame.size.width, 40)];
    [headerLabel setText:@"Categories"];
    headerLabel.font = [UIFont fontWithName:@"Futura" size:20];
    headerLabel.textColor = [UIColor colorWithRed:0.278 green:0.510 blue:0.855 alpha:1.000];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.categoryTableView setTableHeaderView:headerLabel];
    
    [self setCategoryOptions];
    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    
    
    UINib *categoryNib = [UINib nibWithNibName:@"CategoryTableViewCell" bundle:[NSBundle mainBundle]];
    [self.categoryTableView registerNib:categoryNib forCellReuseIdentifier:@"cell"];
    [self.categoryTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.categoryTableView];
}

#pragma mark - User Interaction Functions

- (void)loadImagePicker {
    [self.locationNameTextField resignFirstResponder];
    [self.locationDescriptionTextField resignFirstResponder];
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie, nil];
            }
            self.imagePicker.showsCameraControls = YES;
            self.imagePicker.allowsEditing = YES;
        }
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)displayCategories {
    [self.locationNameTextField resignFirstResponder];
    [self.locationDescriptionTextField resignFirstResponder];
    [self.view bringSubviewToFront:self.saveButton];
    [self.view layoutIfNeeded];
//    self.finalSaveButton.hidden = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    top.active = YES;
    trailing.active = YES;
    bottom.active = YES;
    leading.active = YES;
    
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(self.view.frame.size.height / 2)];
    NSLayoutConstraint *tableViewHeight = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.50 constant:-(self.view.frame.size.height * 0.50)];
    NSLayoutConstraint *tableViewWidth = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:-(self.view.frame.size.width) * 0.8];
    NSLayoutConstraint *tableViewCenterX = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    tableViewBottom.active = YES;
    tableViewHeight.active = YES;
    tableViewWidth.active = YES;
    tableViewCenterX.active = YES;

//    NSLayoutConstraint *buttonTop = [NSLayoutConstraint constraintWithItem:self.finalSaveButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
//    NSLayoutConstraint *buttonTrailing = [NSLayoutConstraint constraintWithItem:self.finalSaveButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20];
    
    self.cameraButton.enabled = NO;
    
    [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden = YES;
            self.cameraButton.alpha = 0.0;
            [self.view layoutIfNeeded];
            
        }];
        
        tableViewBottom.constant = -60.0;
        tableViewHeight.constant = 0;
        tableViewWidth.constant = 0;
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
//        buttonTop.active = YES;
//        buttonTrailing.active = YES;
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        //
    }];
}

- (IBAction)cameraButtonPressed:(UIButton *)sender {
        [self loadImagePicker];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (self.selectedCategories.count == 0) {
        [self.locationNameTextField resignFirstResponder];
        [self.locationDescriptionTextField resignFirstResponder];
        NSString *alertMessage = @"Please fill all fields out.";
        if (self.locationNameTextField.text.length == 0) {
            alertMessage = @"Please enter a location name.";
            [self presentAlertWithMessage:alertMessage];
            return;
        }
        if (self.locationDescriptionTextField.text.length == 0) {
            alertMessage = @"Please enter a location description.";
            [self presentAlertWithMessage:alertMessage];
            return;
        }
        if (self.geoPoint == nil) {
            alertMessage = @"Please drop a pin for your location.";
            [self presentAlertWithMessage:alertMessage];
            return;
        }
        if (self.photoFile == nil) {
            [self presentNoPhotoWarning];
            return;
        }
        Location *locationToSave = [[Location alloc] initWithLocationName:self.locationNameTextField.text locationDescription:self.locationDescriptionTextField.text photo:self.photoFile video:self.videoFile categories:nil location:self.geoPoint orderNumber:0 tour:nil];
        self.createdLocation = locationToSave;
        [self displayCategories];
    } else {
        [self saveLocationWithCategories:sender];
    }
}

//- (void)saveLocation:(UIBarButtonItem *)sender {
//    [self.locationNameTextField resignFirstResponder];
//    [self.locationDescriptionTextField resignFirstResponder];
//    NSString *alertMessage = @"Please fill all fields out.";
//    if (self.locationNameTextField.text.length == 0) {
//        alertMessage = @"Please enter a location name.";
//        [self presentAlertWithMessage:alertMessage];
//        return;
//    }
//    if (self.locationDescriptionTextField.text.length == 0) {
//        alertMessage = @"Please enter a location description.";
//        [self presentAlertWithMessage:alertMessage];
//        return;
//    }
//    if (self.geoPoint == nil) {
//        alertMessage = @"Please drop a pin for your location.";
//        [self presentAlertWithMessage:alertMessage];
//        return;
//    }
//    if (self.photoFile == nil) {
//        [self presentNoPhotoWarning];
//        return;
//    }
//    Location *locationToSave = [[Location alloc] initWithLocationName:self.locationNameTextField.text locationDescription:self.locationDescriptionTextField.text photo:self.photoFile video:self.videoFile categories:nil location:self.geoPoint orderNumber:0 tour:nil];
//    self.createdLocation = locationToSave;
//    [self displayCategories];
//}

- (void)presentAlertWithMessage:(NSString *)alertMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"What!?!" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentNoPhotoWarning {
    UIAlertController *photoAlert = [UIAlertController alertControllerWithTitle:@"No Photo/Video" message:@"Did you want to add a photo or video?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImagePicker];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        Location *locationToSave = [[Location alloc] initWithLocationName:self.locationNameTextField.text locationDescription:self.locationDescriptionTextField.text photo:self.photoFile video:self.videoFile categories:nil location:self.geoPoint orderNumber:0 tour:nil];
        self.createdLocation = locationToSave;
        [self displayCategories];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [photoAlert addAction:yesAction];
    [photoAlert addAction:noAction];
    [photoAlert addAction:cancelAction];
    [self presentViewController:photoAlert animated:YES completion:nil];
}

- (void)saveLocationWithCategories:(UIButton *)sender {
    if (self.createdLocation != nil && self.selectedCategories.count > 0) {
        self.createdLocation.categories = self.selectedCategories;
        self.navigationController.navigationBarHidden = NO;
        if (self.createTourDetailDelegate) {
            [self.createTourDetailDelegate didFinishSavingLocationWithLocation:self.createdLocation image:self.image];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dissolvePinDropReminderLabel {
    [UIView animateWithDuration:0.8 animations:^{
        self.pinDropReminderLabel.alpha = 0.0;
    }];
}

- (void)toggleViewAfterPinDrop {
    [self.view layoutIfNeeded];
//    self.saveButton.enabled = YES;
    if (self.locationNameTextField.alpha == 0.0) {
        self.locationNameTextField.hidden = NO;
        self.locationDescriptionTextField.hidden = NO;
        self.cameraButton.hidden = NO;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.locationNameTextField.alpha = 1.0;
            self.locationDescriptionTextField.alpha = 1.0;
            self.cameraButton.alpha = 1.0;
            self.mapHeightConstraint.constant = -(self.mapView.frame.size.height / 2);
            self.saveButtonBottomConstraint.constant = 10;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            MKCoordinateRegion pinRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.geoPoint.latitude, self.geoPoint.longitude), 300, 300);
            [self.mapView setRegion:pinRegion animated:YES];
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *photoData;
    NSData *videoData;
    PFFile *photoFile;
    PFFile *videoFile;
    if ([info objectForKey:@"UIImagePickerControllerMediaURL"]) {
        videoData = [NSData dataWithContentsOfURL:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
        videoFile = [PFFile fileWithName:[NSString stringWithFormat:@"%i.mp4", rand() / 2] data:videoData];
        
        UIImage *photo = [self getStillImageDataFromMovieUrl:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
        self.image = photo;
        NSData *stillImageData = UIImageJPEGRepresentation(photo, 1.0);
        photoData = stillImageData;
        photoFile = [PFFile fileWithName:[NSString stringWithFormat:@"%i.jpg",rand() / 2] data:photoData];
    } else if ([info objectForKey:@"UIImagePickerControllerEditedImage"]) {
        photoData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"], 1.0);
        photoFile = [PFFile fileWithName:[NSString stringWithFormat:@"%i.jpg",rand() / 2] data:photoData];
        self.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    } else if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]) {
        photoData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
        photoFile = [PFFile fileWithName:[NSString stringWithFormat:@"%i.jpg",rand() / 2] data:photoData];
        self.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"What!?!" message:@"Why don't you pick a normal photo/video!?!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    self.photoFile = photoFile;
    self.videoFile = videoFile;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)getStillImageDataFromMovieUrl:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    if (asset) {
        AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef stillImageRef;
        CFTimeInterval stillImageTime = 0.5;
        NSError *imageGeneratorError;
        stillImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(stillImageTime, 60) actualTime:nil error:&imageGeneratorError];
        
        if (!stillImageRef) {
            NSLog(@"Image generator error: %@", imageGeneratorError.localizedDescription);
        } else {
            UIImage *stillImage = stillImageRef ? [[UIImage alloc] initWithCGImage:stillImageRef] : nil;
            return stillImage;
        }
    }
    return nil;
}

#pragma mark - UITableViewControllerDelegate & UITableViewControllerDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCategory:categories[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (self.selectedCategories.count > 0) {
        if ([self.selectedCategories containsObject:categories[indexPath.row]]) {
            [self.selectedCategories removeObjectAtIndex:[self.selectedCategories indexOfObject:[categories objectAtIndex:indexPath.row]]];
        } else {
            [self.selectedCategories addObject:categories[indexPath.row]];
        }
    } else {
        self.selectedCategories = [NSMutableArray arrayWithObject:categories[indexPath.row]];
    }
}

#pragma mark LocationController

-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)location {
   [self.delegate locationControllerDidUpdateLocation:location.lastObject];
    [self setLocation:location.lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.mapView setShowsUserLocation:YES];
        MKCoordinateRegion currentRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 300, 300);
        [self setRegion:currentRegion];
    }
}

-(void)locationControllerDidUpdateLocation: (CLLocation *)location {
    [self setRegion: MKCoordinateRegionMakeWithDistance(location.coordinate, 300.0, 300.0)];
}

-(void)setRegion:(MKCoordinateRegion) region {
    [self.mapView setRegion:region animated:YES];
}

#pragma mark set up Map

-(void)setupMap {
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 100;

}

#pragma mark MKMapViewDelegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    
    annotationView.annotation = annotation;
    
    annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    annotationView.pinTintColor = [UIColor colorWithRed:0.278 green:0.510 blue:0.855 alpha:1.000];
    UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.rightCalloutAccessoryView = rightCallout;
    [self dissolvePinDropReminderLabel];
    [self toggleViewAfterPinDrop];

    return annotationView;
    
}

-(IBAction)handleLongPressGestured:(UILongPressGestureRecognizer *)sender{
    if (sender.state ==UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = coordinate;
        
        self.geoPoint = [PFGeoPoint geoPointWithLatitude:newPoint.coordinate.latitude longitude:newPoint.coordinate.longitude];
        [self.mapView removeAnnotation:self.mapPinAnnotation];
        self.mapPinAnnotation = newPoint;
        [self.mapView addAnnotation:newPoint];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == 0 && self.locationDescriptionTextField.text.length == 0) {
        [self.locationDescriptionTextField becomeFirstResponder];
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[CreateTourViewController class]]) {
        self.navigationController.navigationBar.tintColor = self.navBarTintColor;
    }
}

@end
