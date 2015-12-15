//
//  CreateTourDetailViewController.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import CoreLocation;
#import "Tour.h"
#import "Location.h"
@import Parse;

@interface CreateTourDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)cameraButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation CreateTourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    Tour *tour1 = [[Tour alloc] initWithClassName:@"Tour" nameOfTour:@"Tour 2." descriptionText:@"This is the tour description" startLocation:geoPoint user:nil];
    Location *location1 = [[Location alloc] initWithClassName:@"Location" locationName:@"Code Fellows" locationDescription:@"This is where we practically live" photo:media categories:@[@"School", @"Education"] location:geoPoint tour:tour1];
    PFGeoPoint *geoPoint2 = [PFGeoPoint geoPointWithLatitude:47.627825 longitude:-122.337412];
    Location *location2 = [[Location alloc] initWithClassName:@"Location" locationName:@"The Park" locationDescription:@"I remember what the sun was like..." photo:media categories:@[@"Park", @"Not Coding"] location:geoPoint2 tour:tour1];
    NSArray *objectArray = [NSArray arrayWithObjects:tour1, location1, location2, nil];
    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"They saved!");
        } else {
            NSLog(@"Something went terribly wrong.");
        }
    }];
}

@end
