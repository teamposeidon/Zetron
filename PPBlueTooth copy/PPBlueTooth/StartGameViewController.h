//
//  StartScreenViewController.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/14/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BrowsePlayersViewController.h"

@interface StartGameViewController : UIViewController

#pragma mark - Multipeer Connectivity Properties
@property (nonatomic, strong) MCBrowserViewController *browserController;

#pragma mark - Multipeer Connectivity Properties
@property (strong, nonatomic) MCAdvertiserAssistant *advertiser;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCPeerID *peerID;

@end
