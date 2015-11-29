//
//  BrowsePlayersViewController.m
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/27/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "BrowsePlayersViewController.h"
#import "AppDelegate.h"
#import "PPMatchmaking.h"
#import "BTLECentralViewController.h"
#import "BTLEPeripheralViewController.h"


@interface BrowsePlayersViewController ()<PPMatchmakingDelegate>

// Public Properties
@property (nonatomic, strong) PPMatchmaking *ppMatchmaking;

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@property (nonatomic) UIImageView *animatedView;
@property (nonatomic) NSTimer *checkConnectedPlayersTimer;
@property (nonatomic) NSMutableArray *players;

@property (nonatomic) CGFloat previousLocationX;

// Virus Randomizer
@property (nonatomic, strong) NSMutableArray<MCPeerID *> *allConnectedPeers;
@property (nonatomic, strong) MCPeerID *peripheralID;
@property (nonatomic) MCPeerID *localVirusRandomSelection;  //this is the random virus chosen by each phone
@property (nonatomic) MCPeerID *peerVirusConfirmed;         //this is the MCPeerID that is confirmed virus for game

// Buttons
@property (strong, nonatomic) IBOutlet UIButton *leaveButton;
@property (strong, nonatomic) IBOutlet UIButton *readyButton;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) IBOutlet UIButton *startGameButton;

@end

@implementation BrowsePlayersViewController

#pragma mark
#pragma mark - UI Buttons
- (IBAction)joinMatchmaking:(id)sender {
    [self.ppMatchmaking joinParty];
    
    NSLog(@"Number of connected peers: %lu", (unsigned long)self.ppMatchmaking.connectedPeers.count);
    
    NSLog(@"Connected Peers in Session: %@", self.ppMatchmaking.connectedPeers);
    
    NSLog(@"Current Session: %@", self.ppMatchmaking.session);
    
    self.leaveButton.hidden = NO;
    self.leaveButton.enabled = YES;
    self.joinButton.enabled = NO;
    self.joinButton.hidden = YES;
    self.readyButton.hidden = NO;
    self.readyButton.enabled = YES;
    
    
    [self computerAnimationPlayer:30];
}

- (IBAction)leaveMatchmaking:(id)sender {
    [self.ppMatchmaking leaveParty];
    
    [self.animatedView removeFromSuperview];

        NSLog(@"Number of connected peers: %lu", (unsigned long)self.ppMatchmaking.connectedPeers.count);
}

#pragma mark
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load matchmaking
    [self matchmakingLoad];
    
    // Load computer table
    [self computerTable];
    
    // Allocate players array
    self.players = [[NSMutableArray alloc]init];
    
    // Load timer
    [self checkConnectedPlayersWithThisTimer];
    
    self.leaveButton.hidden = YES;
    self.leaveButton.enabled = NO;
    self.startGameButton.enabled = NO;
    self.startGameButton.hidden = YES;
    self.readyButton.enabled = NO;
    self.readyButton.hidden = YES;

}


#pragma mark
#pragma mark - Connected Players Check
- (void) checkConnectedPlayersWithThisTimer {
    NSTimer *timerToCheckConnectedPlayers = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(checkForPlayersNearby)
                                                             userInfo:nil
                                                              repeats:YES];
    [timerToCheckConnectedPlayers fire];
}

- (void) checkForPlayersNearby {
    self.previousLocationX = 90;
    //NSLog(@"Checking for nearby players...");
    NSUInteger connectedPeers = self.ppMatchmaking.connectedPeers.count;
    NSUInteger playersArr = self.players.count;
    
    //NSLog(@"Number of connected peers: %lu", (unsigned long)connectedPeers);
    //NSLog(@"Number of players array: %lu", (unsigned long)playersArr);
    
    if (connectedPeers != playersArr){
        if (connectedPeers > playersArr){
            NSLog(@"adding");
            if (playersArr == 0){
                [self.players addObject: [self computerAnimationPlayer:self.previousLocationX]];
            }
            if (playersArr == 1){
                [self.players addObject: [self computerAnimationPlayer:self.previousLocationX + 60]];
            }
            
            else if (playersArr == 2){
                [self.players addObject: [self computerAnimationPlayer:self.previousLocationX + 120]];
            }
            
        }
        
        else if (connectedPeers < playersArr) {
            NSLog(@"removing");
            UIImageView *viewToDelete = [self.players lastObject];
            [viewToDelete removeFromSuperview];
            [self.players removeLastObject];
        }
        
    }


}

#pragma mark 
#pragma mark Matchmakign Setup
- (void)matchmakingLoad {
    self.ppMatchmaking = [[PPMatchmaking alloc] initWithServiceType:ppService];
    self.ppMatchmaking.delegate = self;
    
}

#pragma mark
#pragma mark Animataion
- (void)computerTable {
    UIImageView *computerTable = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 8)];
    
    computerTable.image = [UIImage imageNamed:@"computertable"];
    
    [self.view addSubview:computerTable];
}

- (UIImageView *)computerAnimationPlayer: (CGFloat)computerPosition{
    
    UIImageView *animatedView = [[UIImageView alloc] init];
    
    if (self.ppMatchmaking.connectedPeers.count == 0){
        NSArray *animationFrames = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"l0_computerplayer1"],
                                    [UIImage imageNamed:@"l0_computerplayer2"],
                                    [UIImage imageNamed:@"l0_computerplayer3"],
                                    [UIImage imageNamed:@"l0_computerplayer4"],
                                    nil];
        
        self.animatedView = [[UIImageView alloc] init];
        self.animatedView.frame = CGRectMake(computerPosition, (self.view.frame.size.height / 2 ) - 25, self.view.frame.size.height / 8 , self.view.frame.size.height / 8);
        self.animatedView.animationImages = animationFrames;
        
        [self.view addSubview:self.animatedView];
        [self.animatedView startAnimating];
        
        return self.animatedView;

    }
    
    else if (self.ppMatchmaking.connectedPeers.count > 0){
        NSArray *animationFrames = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"l0_computerplayer1"],
                                    [UIImage imageNamed:@"l0_computerplayer2"],
                                    [UIImage imageNamed:@"l0_computerplayer3"],
                                    [UIImage imageNamed:@"l0_computerplayer4"],
                                    nil];
        
        
        animatedView.frame = CGRectMake(computerPosition, (self.view.frame.size.height / 2 ) - 25, self.view.frame.size.height / 8 , self.view.frame.size.height / 8);
        animatedView.animationImages = animationFrames;
        
        [self.view addSubview:animatedView];
        [animatedView startAnimating];
        return animatedView;
        
    }
    
    return animatedView;
}

#pragma mark
#pragma mark - Matchmaking Delegate
- (void)partyTime:(PPMatchmaking *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"Message Received");
    NSLog(@"Received From Peer: %@",peerID);
    
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:nil];
    MCPeerID *virusID = [myDictionary valueForKey:@"VirusID"];
    
    //NSLog(@"Recieved Data: %@",data);
    NSLog(@"Received Data: %@", virusID);
    
    self.peerVirusConfirmed = virusID;
    
    
    NSLog(@"Received some data!");
}

- (void)partyTime:(PPMatchmaking *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers {
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected to %@", peer.displayName);
    }
    else {
        NSLog(@"Peer disconnected: %@", peer.displayName);
    }
    NSLog(@"Current peers: %@", currentPeers);
    
}

- (void)partyTime:(PPMatchmaking *)partyTime failedToJoinParty:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedFailureReason]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (IBAction)readyButtonTapped:(id)sender {
    
    [self assignVirusPeripheral];
    
    [self sendMessageToPeers];
    
    self.startGameButton.enabled = YES;
    self.startGameButton.hidden = NO;
    self.readyButton.enabled = NO;
    self.readyButton.hidden = YES;

}
- (IBAction)startGameButton:(UIButton *)sender {
    
    //checks if this device's peerID matches that of the peerVirusConfirmed's peerID
    if ([self.ppMatchmaking.peerID.displayName isEqualToString:self.peerVirusConfirmed.displayName]){
        [self pushToPeripheral];
    } else {
        [self pushToCentral];
        
    }
    
      //if ([self.player.zitronUserName rangeOfString:@"virus"].location == NSNotFound)
}

#pragma mark
#pragma mark - Assigning Peripheral
-(void)assignVirusPeripheral{
    
    self.allConnectedPeers = [[NSMutableArray alloc]initWithArray:self.ppMatchmaking.connectedPeers];
    [self.allConnectedPeers addObject:self.ppMatchmaking.peerID];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.allConnectedPeers];
    NSUInteger count = [mutableArray count];
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    NSArray *orderedArray = [NSArray arrayWithArray:mutableArray];
    NSLog(@"Ordered Array: %@",orderedArray);
    
    self.peripheralID = [orderedArray firstObject];
    
    self.localVirusRandomSelection = self.peripheralID;
}
- (void)sendMessageToPeers{
    //sends a message to other devices who is the virus
    NSLog(@"Message sent!");
    
    NSError *error = nil;
    NSDictionary *virusID = @{@"VirusID":self.localVirusRandomSelection};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:virusID];
    
    [self.ppMatchmaking sendData:data
                         toPeers:self.ppMatchmaking.connectedPeers
                        withMode:MCSessionSendDataReliable
                           error:&error];
    
    NSLog(@"Device chose Virus random: %@", self.localVirusRandomSelection);
    NSLog(@"Data Sent: %@",data);
    
    
    //tells SELF the data its sending out
    self.peerVirusConfirmed = self.localVirusRandomSelection;
}

#pragma mark
#pragma mark - Game Screen Segue
-(void)pushToCentral {
    BTLECentralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"CentralID"];
    viewController.session = self.session;
    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Healthy (central)");
}

- (void)pushToPeripheral {
    BTLEPeripheralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"PeripheralID"];
    viewController.session = self.session;
    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Virus!(peripheral)");
    
}

@end
