//
//  ParseLoginViewController.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface VideoPlayerView : UIView

+ (Class)layerClass;
- (AVPlayer*)player;
- (void)setPlayer:(AVPlayer *)player;

@end
