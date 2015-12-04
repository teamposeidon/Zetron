
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <UIKit/UIKit.h>
#import "PPMatchmaking.h"
#import "GradientProgressView.h"
#import <SpriteKit/SpriteKit.h>
#import "PlayerScene.h"
#import "PlayerView.h"

@interface BTLECentralViewController : UIViewController

@property (nonatomic, strong) MCSession *session;
@property (nonatomic) PPMatchmaking *ppMatchmaking;
@property (nonatomic) GradientProgressView *progressView;


@end
