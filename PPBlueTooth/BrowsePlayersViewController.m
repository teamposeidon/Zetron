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
#import "MatchMakingPlayerCell.h"

typedef NS_ENUM(NSInteger, BrowseState) {
    BrowseStateNone,
    BrowseStateJoined,
    BrowseStateReady,
    BrowseStateCountdown
};

@interface BrowsePlayersViewController ()<PPMatchmakingDelegate, UICollectionViewDataSource, UITextFieldDelegate>

// Public Properties
@property (nonatomic, strong) PPMatchmaking *ppMatchmaking;

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@property (nonatomic) NSTimer *checkConnectedPlayersTimer;
@property (nonatomic) NSMutableArray *players;

@property (nonatomic) CGFloat previousLocationX;

@property (nonatomic) BrowseState browseState;

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
@property (weak, nonatomic) IBOutlet UIImageView *borderFrame;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (nonatomic, strong) UIAlertAction *ok;

// Timer for Shadow
@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL countDown;
@property (nonatomic) double counter;

// Wallpaper
@property (weak, nonatomic) IBOutlet UIImageView *wallpaperBG;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableDictionary *readyPlayers;

//countdown timer
@property (nonatomic) NSTimeInterval countdownTimeLeft;
@property (nonatomic) NSTimer *countdownTimer;

// App Delegate
@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NSString *serverName;

@property (nonatomic,strong) UIAlertController *alertController;

@end

@implementation BrowsePlayersViewController



#pragma mark
#pragma mark - Life Cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // Show the alert controller
    [self alertControllerShow];
}

#pragma mark
#pragma mark - Alert Controller User Name
- (void)alertControllerShow{
     self.alertController = [UIAlertController
                                          alertControllerWithTitle:@"Z E T R O N"
                                          message:@"Enter Server Name:"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    // Alert Message - OK Button
    self.ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // This will add the server room
        self.appDelegate.ppService = self.alertController.textFields.firstObject.text;
        self.serverName = self.appDelegate.ppService;
        
        // Load matchmaking
        [self matchmakingLoad];
        
        
    }];
    
    // Alert Message - Cancel Button
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel");
    }];
    
    self.ok.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.alertController addAction:self.ok];
    [self.alertController addAction:cancel];
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Server Name";
        [textField addTarget:weakSelf action:@selector(textfieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }];

    [self presentViewController:self.alertController animated:YES completion:nil];
    
}

- (void)textfieldValueChanged:(UITextField *)textField {
    self.ok.enabled = textField.text.length > 0;
}

#pragma mark
#pragma mark - Drop Shadow Side Bar
- (void)setUpDropShadowSideBar {
    
    // Side Bar Timer Animation
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.09
                                                  target:self
                                                selector:@selector(updateShadowTimer)
                                                userInfo:nil
                                                 repeats:YES];
    self.counter = 2.0;
    self.countDown = NO;
    
    // Side Bar Setup Drop Shadow
    [self dropShadowSideBar:self.borderFrame];
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
#pragma mark - UI Buttons
- (IBAction)joinMatchmaking:(id)sender {
    [self.ppMatchmaking joinParty:nil];
    
    self.browseState = BrowseStateJoined;
    
//    NSLog(@"Number of connected peers: %lu", (unsigned long)self.ppMatchmaking.connectedPeers.count);
//    
//    NSLog(@"Connected Peers in Session: %@", self.ppMatchmaking.connectedPeers);
//    
//    NSLog(@"Current Session: %@", self.ppMatchmaking.session);
//    
//    self.leaveButton.hidden = NO;
//    self.leaveButton.enabled = YES;
//    self.joinButton.enabled = NO;
//    self.joinButton.hidden = YES;
//    self.readyButton.hidden = NO;
//    self.readyButton.enabled = YES;
//    
//    [self.collectionView reloadData];
}

- (IBAction)leaveMatchmaking:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.ppMatchmaking leaveParty];
    
    NSLog(@"Number of connected peers: %lu", (unsigned long)self.ppMatchmaking.connectedPeers.count);
    
}

#pragma mark
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup Drop Shadow
    [self setUpDropShadowSideBar];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Allocate players array
    self.players = [[NSMutableArray alloc]init];
    self.readyPlayers = [[NSMutableDictionary alloc]init];
    
    // Load BG
    [self animationChangeBGLogo];
    
    self.collectionView.dataSource = self;
    
    self.browseState = BrowseStateNone;
}


#pragma mark
#pragma mark - Connected Players Check

- (void)checkReady
{
    BOOL allReady = self.allConnectedPeers.count == self.readyPlayers.allKeys.count;
    if (allReady) {
        self.browseState = BrowseStateCountdown;
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
#pragma mark Matchmakign Setup
- (void)matchmakingLoad {
    self.ppMatchmaking = [[PPMatchmaking alloc] initWithServiceType:self.appDelegate.ppService];
    self.ppMatchmaking.delegate = self;
    
}

#pragma mark
#pragma mark Animataion
- (NSArray *) createAnimatedImages {
    NSMutableArray *animatedImages = [[NSMutableArray alloc]init];
    
    for (int i = 1; i < 15; i++){
        UIImage *image = [UIImage imageNamed:@(i).stringValue];
        [animatedImages addObject:image];
    }

    return animatedImages;
}

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

#pragma mark
#pragma mark - Matchmaking Delegate
- (void)partyTime:(PPMatchmaking *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"Message Received");
    NSLog(@"Received From Peer: %@",peerID);
    
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:nil];
    MCPeerID *virusID = [myDictionary valueForKey:@"VirusID"];
    
    if (!virusID) return;
    
    [self makePeerReady:peerID];
    
    //NSLog(@"Recieved Data: %@",data);
    NSLog(@"Received Data: %@", virusID);
    
    self.peerVirusConfirmed = virusID;
    
    [self.collectionView reloadData];
    
    NSLog(@"Received some data!");
    
    [self checkReady];
}

- (void)partyTime:(PPMatchmaking *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers
       gameStatus:(NSString *)gameStatus {

    if (self.ppMatchmaking.connectedPeers.count + 1==4){
        [self.ppMatchmaking stopAcceptingGuests];
    }
    
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected to %@", peer.displayName);
    }
    else {
        NSLog(@"Peer disconnected: %@", peer.displayName);
    }
    NSLog(@"Current peers: %@", currentPeers);
    
    [self.collectionView reloadData];
}

- (void)partyTime:(PPMatchmaking *)partyTime failedToJoinParty:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedFailureReason]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (IBAction)readyButtonTapped:(id)sender {
    self.browseState = BrowseStateReady;

    [self assignVirusPeripheral];
    
    [self sendMessageToPeers];
    

}

- (IBAction)startGameButton:(UIButton *)sender {
    [self startGame];

}

- (void) startGame {
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
    
    self.allConnectedPeers = [[[NSMutableArray alloc]initWithArray:self.ppMatchmaking.connectedPeers]init];
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
    
//    self.localVirusRandomSelection = self.peripheralID;
    self.localVirusRandomSelection = self.ppMatchmaking.peerID;
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
    
    [self makePeerReady:self.ppMatchmaking.peerID];
    [self checkReady];
}

#pragma mark
#pragma mark - Game Screen Segue
-(void)pushToCentral {
    BTLECentralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"CentralID"];
    viewController.serverName = self.serverName;
    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Healthy (central)");
}

- (void)pushToPeripheral {
    BTLEPeripheralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"PeripheralID"];
    viewController.serverName = self.serverName;
    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Virus!(peripheral)");
    
}

#pragma mark
#pragma mark - Collection View Data Source
- (NSArray *) allPeers {
    if (!self.ppMatchmaking.connected) return @[];
    return [@[self.ppMatchmaking.peerID] arrayByAddingObjectsFromArray:self.ppMatchmaking.connectedPeers];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPeers.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MatchMakingPlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MatchMakingPlayer" forIndexPath:indexPath];
    
    cell.playerImageView.animationImages = [self createAnimatedImages];
    cell.playerImageView.animationDuration = 0.8;
    [cell.playerImageView startAnimating];
    
    MCPeerID *peer = self.allPeers[indexPath.row];
    cell.nameLabel.text = peer.displayName;
    
    // If peer is in readyPlayers, or if peer is yourself, this person is ready.
    if ([self isPeerReady:peer]) {
        cell.alpha = 1;
    }
    else {
        cell.alpha = 0.5;
    }
    
    return cell;
}

#pragma mark
#pragma mark - Overrides

- (void)setBrowseState:(BrowseState)browseState
{
    _browseState = browseState;
    
    self.joinButton.hidden = YES;
    self.leaveButton.hidden = YES;
    self.startGameButton.hidden = YES;
    self.readyButton.hidden = YES;
    self.countdownLabel.hidden = YES;
    
    switch (browseState) {
        case BrowseStateNone:
            self.joinButton.hidden = NO;
            break;
        case BrowseStateJoined:
            self.leaveButton.hidden = NO;
            self.readyButton.hidden = NO;
            break;
        case BrowseStateReady:
            self.leaveButton.hidden = NO;
            break;
        case BrowseStateCountdown:
            self.countdownLabel.hidden = NO;
            [self startCountdown];
            break;
        default:
            break;
    }
    
    [self.collectionView reloadData];
}

#pragma mark
#pragma mark - Countdown

- (void)startCountdown
{
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(countdown:)
                                                             userInfo:nil
                                                              repeats:YES];
    self.countdownTimeLeft = 5;
}
- (void)countdown:(NSTimer *)timer
{
    self.countdownTimeLeft--;
    
    if (self.countdownTimeLeft == -1){
        [self.countdownTimer invalidate];
        [self startGame];
    }
    else {
        self.countdownLabel.text = @(self.countdownTimeLeft).stringValue;
    }
}

//unwind

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    
    return YES;
}
@end
