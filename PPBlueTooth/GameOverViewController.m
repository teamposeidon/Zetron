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
    
}

- (void)showEndGameStatus {
    if ([self.gameEndStatus isEqualToString:@"central"]){
        self.gameEndLabel.text = @"You have survived The Zetron Virus!";
        self.gameEndLabel.textColor = [UIColor greenColor];
        
    } else if ([self.gameEndStatus isEqualToString:@"peripheral"]){
        
        self.gameEndLabel.text = @"Zetron!!! Continue To Infect Benign Systems!";
        self.gameEndLabel.textColor = [UIColor redColor];
    }
    
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
//    
//    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:nil];
//    MCPeerID *virusID = [myDictionary valueForKey:@"VirusID"];
//    
//    if (!virusID) return;
//    
//    [self makePeerReady:peerID];
//    
//    NSLog(@"Received Data: %@", virusID);
//    
//    //[self.collectionView reloadData];
//    
//    NSLog(@"Received some data!");
    
    
}

- (void)partyTime:(PPMatchmaking *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers
       gameStatus:(NSString *)gameStatus{
    
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected to %@", peer.displayName);
        
        //if (![currentPeers containsObject:peer]){
        NSDictionary *peerAndStatus = @{
                                   peer.displayName:gameStatus
                                        };
        
        [self.allConnectedPeers addEntriesFromDictionary:peerAndStatus];
            
        NSLog(@"Self.allConnectedPeers:%@",self.allConnectedPeers);
        //[self makePeerReady:peer];
        //[self checkReady];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
