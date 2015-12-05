//
//  GameOverViewController.m
//  PPBlueTooth
//
//  Created by Jamaal Sedayao on 11/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "GameOverViewController.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, ReconnectState) {
    ReconnectStateNone,
    ReconnectStateJoined,
    ReconnectStateScoreboard
};

@interface GameOverViewController ()
<
PPMatchmakingDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *gameResultsView;
@property (nonatomic) ReconnectState reconnectState;
@property (nonatomic, strong) NSMutableDictionary *allConnectedPeers;
@property (nonatomic) NSMutableDictionary *readyPlayers;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// UI Properties Below
@property (weak, nonatomic) IBOutlet UIImageView *wallpaperBG;
@property (weak, nonatomic) IBOutlet UIImageView *borderFrame;
@property (nonatomic) BOOL countDown;
@property (nonatomic) double counter;

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameResultsView.layer.cornerRadius = 4.0f;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.allConnectedPeers = [[NSMutableDictionary alloc]init];
    self.readyPlayers = [[NSMutableDictionary alloc]init];
    
    [self matchmakingLoad];
    
    //self.ppMatchmaking.endGameStatus = self.gameEndStatus;
    
    self.reconnectState = ReconnectStateNone;
    
    [self animationChangeBGLogo];
    
    [self setUpDropShadowSideBar];
    
}

#pragma mark 
#pragma mark - Reconnect Peers in PPMatchmaking

- (void)matchmakingLoad {
    self.ppMatchmaking = [[PPMatchmaking alloc] initWithServiceType:ppService];
    self.ppMatchmaking.delegate = self;
    
}
- (void)partyTime:(PPMatchmaking *)partyTime failedToJoinParty:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedFailureReason]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark
#pragma mark - Matchmaking Delegate
- (void)partyTime:(PPMatchmaking *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID {
    NSLog(@"Message received From Peer: %@",peerID);
    
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:nil];
    //MCPeerID *virusID = [myDictionary valueForKey:@"VirusID"];
    
    
    NSDictionary *peerAndStatus = @{
                                    self.ppMatchmaking.peerID.displayName:self.gameEndStatus
                                    };
    [self.allConnectedPeers addEntriesFromDictionary:peerAndStatus];
    [self.allConnectedPeers addEntriesFromDictionary:myDictionary];
    
    [self.tableView reloadData];
}

- (void)partyTime:(PPMatchmaking *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers
       gameStatus:(NSString *)gameStatus{
    
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected to %@", peer.displayName);
        [self sendMessageToPeers];
        [self makePeerReady:peer];
        [self checkReady];
    }
    else {
        NSLog(@"Peer disconnected: %@", peer.displayName);
    }
    NSLog(@"Current peers: %@", currentPeers);
    
    [self.tableView reloadData];
    
}
- (void)sendMessageToPeers {
    
    NSError *error = nil;
    NSDictionary *endGameStatus = @{
                              self.ppMatchmaking.peerID.displayName:self.gameEndStatus};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:endGameStatus];
    
    [self.ppMatchmaking sendData:data
                         toPeers:self.ppMatchmaking.connectedPeers
                        withMode:MCSessionSendDataReliable
                           error:&error];
    
    NSLog(@"Data Sent: %@",data);
    
}

#pragma mark
#pragma mark - Connected Players Check

- (void)checkReady
{
    BOOL allReady = self.allConnectedPeers.count == self.readyPlayers.allKeys.count;
    if (allReady) {
        self.reconnectState = ReconnectStateJoined;
    }
}

- (void)makePeerReady:(MCPeerID *)peer
{
    self.readyPlayers[peer.displayName] = @(YES);
}


- (BOOL)isPeerReady:(MCPeerID *)peer
{
    return [self.readyPlayers[peer.displayName] boolValue];
}

#pragma mark
#pragma mark - Overrides
- (void)setReconnectState:(ReconnectState)reconnectState {
    
    _reconnectState = reconnectState;
    
    switch (reconnectState) {
        case ReconnectStateNone:
            self.gameEndLabel.text = @"Gather all players...";
            [self.ppMatchmaking joinParty:nil];
            NSLog(@"triggered");
            break;
        case ReconnectStateJoined:
            NSLog(@"Reconnect State Joined");
            break;
        case ReconnectStateScoreboard:

            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark
#pragma mark - Tableview DataSource
//- (NSArray *) allPeers {
//    if (!self.ppMatchmaking.connected) return @[];
//    return [@[self.ppMatchmaking.peerID] arrayByAddingObjectsFromArray:self.ppMatchmaking.connectedPeers];
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allConnectedPeers.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZetronIdentifier" forIndexPath:indexPath];
    
    //cell.textLabel.text = peer.displayName;
    
    NSArray* keys = [self.allConnectedPeers allKeys];
    
    cell.textLabel.text = keys[indexPath.row];
    
    cell.detailTextLabel.text = [self.allConnectedPeers objectForKey:[keys objectAtIndex:indexPath.row]];
    
    
    return cell;
}


// ** UI BELOW ** //
// ** UI BELOW ** //
// ** UI BELOW ** //


#pragma mark
#pragma mark - Drop Shadow Side Bar
- (void)setUpDropShadowSideBar {
    
    // Side Bar Timer Animation
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.09
                                                      target:self
                                                    selector:@selector(updateShadowTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [timer fire];
    
    self.counter = 2.0;
    self.countDown = NO;
    
    // Side Bar Setup Drop Shadow
    [self dropShadowSideBar:self.borderFrame];
    
    // Setup the background animation
    [self animationChangeBGLogo];
}

- (void)dropShadowSideBar:(UIView *)glowView {
    glowView.layer.masksToBounds = NO;
    glowView.layer.shadowColor = [UIColor yellowColor].CGColor;
    glowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    glowView.layer.shadowRadius = 10.0f;
    glowView.layer.shadowOpacity = 1.0f;
}

- (void)updateShadowTimer {
    NSString *num = [NSString stringWithFormat:@"0.%f",self.counter];
    float opacity = [num floatValue];
    
    if (self.countDown == NO){
        self.counter++;
        if (self.counter == 9) {
            
            self.countDown = YES;
        }
    } else if (self.countDown == YES){
        self.counter--;
        if (self.counter == 2){
            self.countDown = NO;
        }
    }
    
    self.borderFrame.layer.shadowOpacity = opacity;
}

#pragma mark
#pragma mark - Show Animation BG
- (void)animationChangeBGLogo {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 8; i++){
        NSString *object = [NSString stringWithFormat:@"tmp-%d", i];
        [tempArray addObject:[UIImage imageNamed:object]];
    }
    
    NSArray *animationFrames = [NSArray arrayWithArray:tempArray];
    
    
    self.wallpaperBG.animationDuration = 0.6;
    self.wallpaperBG.animationImages = animationFrames;
    
    //    [self.view addSubview:self.zetronMainLogo];
    [self.wallpaperBG startAnimating];
    
}

@end
