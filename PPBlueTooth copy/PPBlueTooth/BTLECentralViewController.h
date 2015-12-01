
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <UIKit/UIKit.h>
#import "PPMatchmaking.h"

@interface BTLECentralViewController : UIViewController

@property (nonatomic, strong) MCSession *session;
@property (nonatomic) PPMatchmaking *ppMatchmaking;

@end
