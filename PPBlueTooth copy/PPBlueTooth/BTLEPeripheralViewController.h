

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <UIKit/UIKit.h>
#import "PPMatchmaking.h"

@interface BTLEPeripheralViewController : UIViewController

@property (nonatomic,strong) MCSession *session;
@property (nonatomic) PPMatchmaking *ppMatchmaking;

@end
