//
//  GameOverViewController.h
//  PPBlueTooth
//
//  Created by Jamaal Sedayao on 11/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMatchmaking.h"

@interface GameOverViewController : UIViewController

@property (nonatomic,strong) PPMatchmaking *ppMatchmaking;
@property (nonatomic) NSString *gameEndStatus;
@property (strong, nonatomic) IBOutlet UILabel *gameEndLabel;

@end
