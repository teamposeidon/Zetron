//
//  AppDelegate.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/9/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@import MultipeerConnectivity;

@class ViewController;

extern NSString * const ppService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) AVAudioPlayer *audioPlayerStartMusic;

@property (nonatomic) AVAudioPlayer *audioPlayerGameMusic;

@property (nonatomic) AVAudioPlayer *audioPlayerVirusMusic;

@end

