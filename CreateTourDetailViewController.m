//
//  CreateTourDetailViewController.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CreateTourDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CreateTourDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation CreateTourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)imageButtonPressed:(UIImagePickerController *)sender {
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
                self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie, nil];
            }
            self.imagePicker.showsCameraControls = YES;
            
        }
        
    }
}

@end
