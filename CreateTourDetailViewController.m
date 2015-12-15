//
//  CreateTourDetailViewController.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CategoryTableViewCell.h"
@import CoreLocation;
#import "Tour.h"
#import "Location.h"
@import Parse;

static const NSArray *categories;

@interface CreateTourDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

- (IBAction)cameraButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIView *greyOutView;
@property (strong, nonatomic) UITableView *categoryTableView;
@property (strong, nonatomic) NSMutableArray *selectedCategories;

@end

@implementation CreateTourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        if (object) {
//            Location *location = (Location *)object;
//            PFQuery *tourQuery = [PFQuery queryWithClassName:@"Tour"];
//            [tourQuery whereKey:@"objectId" equalTo:location.tour.objectId];
//            [tourQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//                if ([object isKindOfClass:[Tour class]]) {
//                    location.tour = (Tour *)object;
//                    NSLog(@"%@", location.tour.nameOfTour);
//                    Tour *tour = (Tour *)object;
//                    NSLog(@"%@", tour.nameOfTour);
//                }
//            }];
//        }
//    }];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTour:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.selectedCategories = [[NSMutableArray alloc] init];
    [self setUpGreyOutView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setCategoryOptions {
    categories = @[@"Restaurant", @"Cafe", @"Art", @"Museum", @"History", @"Shopping", @"Nightlife"];
}

- (void)setUpGreyOutView {
    self.greyOutView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    
    self.greyOutView.backgroundColor = [UIColor colorWithWhite:0.737 alpha:0.500];
    
    [self.greyOutView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.greyOutView];
    
    [self setUpTableView];
}

- (void)setUpTableView {
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    
    [self setCategoryOptions];
    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    
    UINib *categoryNib = [UINib nibWithNibName:@"CategoryTableViewCell" bundle:[NSBundle mainBundle]];
    [self.categoryTableView registerNib:categoryNib forCellReuseIdentifier:@"cell"];
    
    [self.categoryTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.categoryTableView];
}

- (void)loadImagePicker {
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

- (void)saveTour:(UIBarButtonItem *)sender {
    [self.view layoutIfNeeded];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.view.frame.size.height / 2];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:self.view.frame.size.width / 2];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(self.view.frame.size.height / 2)];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.greyOutView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-(self.view.frame.size.width / 2)];
    
    top.active = YES;
    trailing.active = YES;
    bottom.active = YES;
    leading.active = YES;
    
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(self.view.frame.size.height / 2)];
    NSLayoutConstraint *tableViewHeight = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.6 constant:-(self.view.frame.size.height * 0.6)];
    NSLayoutConstraint *tableViewWidth = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:-(self.view.frame.size.width) * 0.8];
    NSLayoutConstraint *tableViewCenterX = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    tableViewBottom.active = YES;
    tableViewHeight.active = YES;
    tableViewWidth.active = YES;
    tableViewCenterX.active = YES;
    
    top.constant = 0;
    trailing.constant = 0;
    bottom.constant = 0;
    leading.constant = 0;
    
    [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            
        }];
        
        tableViewBottom.constant = -30.0;
        tableViewHeight.constant = 0;
        tableViewWidth.constant = 0;
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"Why'd you cancel?");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *mediaData;
    PFFile *mediaFile;
    if ([info objectForKey:@"UIImagePickerControllerMediaURL"]) {
        NSLog(@"So, you've made a movie...");
        mediaData = [NSData dataWithContentsOfURL:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
        mediaFile = [PFFile fileWithName:[NSString stringWithFormat:@"%i.mp4", rand() / 2] data:mediaData];
    }
    if ([info objectForKey:@"UIImagePickerControllerEditedImage"]) {
        NSLog(@"Ah, just a photo?");
        mediaData = UIImageJPEGRepresentation([info objectForKey:@""], 1.0);
        mediaFile = [PFFile fileWithName:[NSString stringWithFormat:@"%i.jpg",rand() / 2] data:mediaData];
    }
    [self addTestModelsToParse:mediaFile];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraButtonPressed:(UIButton *)sender {
//    [self loadImagePicker];
    [self saveTour:nil];
}

- (void)addTestModelsToParse:(PFFile *)media {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(47.623544, -122.336224);
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
    Tour *tour1 = [[Tour alloc] initWithNameOfTour:@"Tour 1" descriptionText:@"This is a tour." startLocation:geoPoint user:[PFUser currentUser]];
    Location *location1 = [[Location alloc] initWithLocationName:@"Code Fellows" locationDescription:@"This is where we practically live" photo:media categories:@[@"School", @"Education"] location:geoPoint tour:tour1];
    PFGeoPoint *geoPoint2 = [PFGeoPoint geoPointWithLatitude:47.627825 longitude:-122.337412];
    Location *location2 = [[Location alloc] initWithLocationName:@"The Park" locationDescription:@"I remember what the sun was like..." photo:media categories:@[@"Park", @"Not Coding"] location:geoPoint2 tour:tour1];
    NSArray *objectArray = [NSArray arrayWithObjects:tour1, location1, location2, nil];
    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"They saved!");
        } else {
            NSLog(@"Something went terribly wrong.");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCategory:categories[indexPath.row]];
    if ([self.selectedCategories indexOfObject:categories[indexPath.row]]) {
        [cell setCheckboxAlpha:1.0];
    } else {
        [cell setCheckboxAlpha:0.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCategories.count > 0 && [self.selectedCategories indexOfObject:categories[indexPath.row]]) {
        [self.selectedCategories removeObjectAtIndex:[self.selectedCategories indexOfObject:categories[indexPath.row]]];
    } else {
        [self.selectedCategories addObject:categories[indexPath.row]];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
