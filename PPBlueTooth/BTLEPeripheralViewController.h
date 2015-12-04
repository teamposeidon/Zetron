

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <UIKit/UIKit.h>
#import "PPMatchmaking.h"
#import <SpriteKit/SpriteKit.h>
#import "PlayerScene.h"
#import "PlayerView.h"

@interface BTLEPeripheralViewController : UIViewController

@property (nonatomic,strong) MCSession *session;
@property (nonatomic) PPMatchmaking *ppMatchmaking;
@property (nonatomic) NSString *timeLeftContinued;

@end
