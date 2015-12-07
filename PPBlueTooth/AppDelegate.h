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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) NSString *ppService;

@property (strong, nonatomic) UIWindow *window;



@end

