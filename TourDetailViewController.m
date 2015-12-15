//
//  TourDetailViewController.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourDetailViewController.h"
#import "VideoPlayerView.h"
@import Parse;
#import "Location.h"

static const NSString *ItemStatusContext;

@interface TourDetailViewController ()

@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic, weak) IBOutlet VideoPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
- (IBAction)playButtonPressed:(UIButton *)sender;


@end

@implementation TourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setButtonStatus];
    [self testVideoStream];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)testVideoStream {
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKeyExists:@"photo"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error");
        }
        if (object) {
            if ([object isKindOfClass:[Location class]]) {
                Location *location = (Location *)object;
                if ([location.photo isKindOfClass:[PFFile class]]) {
                    PFFile *photoFile = (PFFile *)location.photo;
                    NSURL *videoURL = [NSURL URLWithString:photoFile.url];
                    [self loadVideoAsset:videoURL];
//                    [photoFile getFilePathInBackgroundWithBlock:^(NSString * _Nullable filePath, NSError * _Nullable error) {
//                        if (error) {
//                            NSLog(@"Couldn't get the file path...");
//                        }
//                        if (filePath) {
//                            NSLog(@"%@", filePath);
//                            [self loadVideoAsset:[NSURL URLWithString:filePath]];
//                        }
//                    }];
                }
            }
        }
    }];
}

- (void)loadVideoAsset:(NSURL *)url {
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSLog(@"%@", asset.metadata);
    NSLog(@"%@", asset.description);
    NSString *tracksKey = @"tracks";
    
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler: ^ {
         dispatch_async(dispatch_get_main_queue(), ^ {
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
             
             NSLog(@"%li", status);
            
            if (status == AVKeyValueStatusLoaded) {
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
//                 ensure that this is done before the playerItem is associated with the player
                [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:&ItemStatusContext];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [self.playerView setPlayer:self.player];
            }
            else {
//                 You should deal with the error appropriately.
                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
            }
        });

     }];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
    [UIView animateWithDuration:0.4 animations:^{
        self.playButton.alpha = 1.0;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self setButtonStatus];
       });
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    return;
}

- (void)setButtonStatus {
    if ((self.player.currentItem != nil) &&
        ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay)) {
        self.playButton.enabled = YES;
    }
    else {
        self.playButton.enabled = NO;
    }
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.playButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
}
@end
