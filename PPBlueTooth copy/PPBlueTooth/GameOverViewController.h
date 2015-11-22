//
//  GameOverViewController.h
//  PPBlueTooth
//
//  Created by Jamaal Sedayao on 11/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PlayerManager.h"
#import "PlayerCharacter.h"

@interface GameOverViewController : UIViewController

@property (nonatomic,strong) MCSession *session;
@property (nonatomic) PlayerManager *playerManager;

@end
