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
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTour:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.greyOutView setFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    [self.categoryTableView setFrame:CGRectMake(self.greyOutView.center.x, self.greyOutView.center.y, 0, 0)];
    [self.greyOutView setNeedsLayout];
    [self.categoryTableView setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)setCategoryOptions {
    categories = @[@"Restaurant", @"Cafe", @"Art", @"Museum", @"History", @"Shopping", @"Nightlife"];
}

- (void)setUpTableView {
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    UINib *categoryNib = [UINib nibWithNibName:@"CategoryTableViewCell" bundle:[NSBundle mainBundle]];
    [self.categoryTableView registerNib:categoryNib forCellReuseIdentifier:@"cell"];
    
    [self.categoryTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0.0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0.0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.categoryTableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
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
    [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            //Animate greyout view to full screen size
            self.greyOutView.frame = CGRectMake(self.view.center.x, self.view.center.y, self.view.frame.size.width, self.view.frame.size.height);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            //Animate table view to most of screen size
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
    [self loadImagePicker];
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
    cell.category = categories[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedCategories indexOfObject:categories[indexPath.row]]) {
        [self.selectedCategories removeObjectAtIndex:[self.selectedCategories indexOfObject:categories[indexPath.row]]];
    } else {
        [self.selectedCategories addObject:categories[indexPath.row]];
    }
}

@end
