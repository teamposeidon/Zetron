//
//  BrowsePlayersViewController.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/27/15.
//  Copyright © 2015 apps. All rights reserved.
//


#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <UIKit/UIKit.h>
#import "PPMatchmaking.h"
#import <SpriteKit/SpriteKit.h>
#import "PlayerScene.h"
#import "PlayerView.h"
#import "AppDelegate.h"

@interface BTLEPeripheralViewController : UIViewController

@property (nonatomic,strong) MCSession *session;
@property (nonatomic) PPMatchmaking *ppMatchmaking;
@property (nonatomic) NSString *timeLeftContinued;
@property (nonatomic) NSString *serverName;

@end
