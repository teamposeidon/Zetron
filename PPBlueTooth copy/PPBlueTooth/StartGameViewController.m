//
//  StartScreenViewController.m
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/14/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "StartGameViewController.h"
#import "PlayerCharacter.h"
#import "PlayerManager.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BTLECentralViewController.h"
#import "BTLEPeripheralViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface StartGameViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate>

//Game buttons
@property (strong, nonatomic) IBOutlet UIButton *startGameButton;
@property (strong, nonatomic) IBOutlet UIButton *releaseVirusButton;
@property (strong, nonatomic) IBOutlet UIButton *findPlayersButton;

// UI Side Bar
@property (weak, nonatomic) IBOutlet UIView *leftBarView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *rightBarView;

// Timer for Shadow
@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL countDown;
@property (nonatomic) double counter;

// Alert Controller
@property (nonatomic) UIAlertController *alertController;
@property (nonatomic) PlayerCharacter *player;
@property (nonatomic) PlayerManager *data;
@property (nonatomic, strong) NSString *userName;

// Central and Peripheral IDS
@property (nonatomic, strong) NSMutableArray<MCPeerID *> *allConnectedPeers;
@property (nonatomic, strong) MCPeerID *peripheralID;
//@property (nonatomic, strong) MCPeerID *peripheralIDConfirmed;
@property (nonatomic, strong) NSMutableArray<MCPeerID *> *centralIDs;

//Sound
@property (nonatomic) AVAudioPlayer *play;

//assigning Virus properties
@property (nonatomic) MCPeerID *localVirusRandomSelection;  //this is the random virus chosen by each phone
@property (nonatomic) MCPeerID *peerVirusConfirmed;         //this is the MCPeerID that is confirmed virus for game

@property (nonatomic) PlayerManager *playerManager;

@end

@implementation StartGameViewController

#pragma mark
#pragma mark - View Did Load
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //hide start game button & releaseVirus button
    self.startGameButton.hidden = YES;
    self.startGameButton.enabled = NO;
    self.releaseVirusButton.hidden = YES;
    self.releaseVirusButton.enabled = NO;
    
    // Setup Drop Shadow
    [self setUpDropShadowSideBar];

    // Multipeer Setup
    self.player = [[PlayerCharacter alloc]init];
    
    // Singleton Player Data
    self.data = [PlayerManager sharedInstance];
    [self.data initializeModel];
    
    // MCPeerSession Delegate
    self.session.delegate = self;

    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GlassCandy"  ofType:@"mp3"]];
    
    
    self.play = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    [self.play play];
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
    [self dropShadowSideBar:self.topBarView];
    [self dropShadowSideBar:self.rightBarView];
    [self dropShadowSideBar:self.leftBarView];
    [self dropShadowSideBar:self.bottomBarView];
}

- (void)dropShadowSideBar:(UIView *)glowView {
    glowView.layer.masksToBounds = NO;
    glowView.layer.shadowColor = [UIColor yellowColor].CGColor;
    glowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    glowView.layer.shadowRadius = 20.0;
    glowView.layer.shadowOpacity = 0.5f;
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
    
    self.leftBarView.layer.shadowOpacity = opacity;
    self.rightBarView.layer.shadowOpacity = opacity;
    self.topBarView.layer.shadowOpacity = opacity;
    self.bottomBarView.layer.shadowOpacity = opacity;
    
    self.startGameButton.layer.shadowOpacity = opacity;

}

#pragma mark
#pragma mark - Start Button
- (IBAction)findPlayersTapped:(id)sender {
    if (self.data.player.count == 0) {
        [self alertControllerShow];
    }
}

#pragma mark
#pragma mark - Alert Controller User Name
- (void)alertControllerShow{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Z E T R O N"
                                          message:@"Enter Name"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    // Alert Message - OK Button
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.player.userName = alertController.textFields.firstObject.text;
        
        self.player.zitronUserName = [NSString stringWithFormat:@"Zitron-%@",self.player.userName];
        
        [self runAdvertiser];
        
        [self.data.player addObject:self.player];
        
        [self requireDeviceConnected];
        
    }];
    
    // Alert Message - Cancel Button
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel");
    }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark
#pragma mark - Run Advertiser
- (void)runAdvertiser {
    
    self.player.mcPeerID = [[MCPeerID alloc]initWithDisplayName:self.player.zitronUserName];
    self.session = [[MCSession alloc]initWithPeer:self.player.mcPeerID];
    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:ppService discoveryInfo:nil session:self.session];
     self.session.delegate = self;
    
    [self.advertiser start];
}

#pragma mark
#pragma mark - Convenience methods
- (void)requireDeviceConnected
{
    if (self.session.connectedPeers.count == 0) {
        self.browserController
        = [[MCBrowserViewController alloc] initWithServiceType:ppService session:self.session];
        self.browserController.delegate = self;
        [self presentViewController:self.browserController animated:YES completion:nil];
    } else {
    }
}

#pragma mark
#pragma mark - MCBrowserViewControllerDelegate
// Notifies the delegate, when the user taps the done button.
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
    //enables releaseVirus button after finding players
    self.releaseVirusButton.hidden = NO;
    self.releaseVirusButton.enabled = YES;
    self.findPlayersButton.hidden = YES;
    self.findPlayersButton.enabled = NO;
    self.startGameButton.hidden = NO;
    self.startGameButton.enabled = YES;
    
    [self assignVirusPeripheral];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self sendMessageToPeers];
    }];
     
// kaira's code that includes virus string name
//     ^{
//        if ([self.player.zitronUserName rangeOfString:@"virus"].location == NSNotFound) {
//            NSLog(@"string does not contain virus");
//            [self.play stop];
//            [self pushToCentral];
//        } else {
//            NSLog(@"string contains virus!");
//            [self.play stop];
//            [self pushToPeripheral];
//        }
//    }];
}
// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.data.player removeObjectAtIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    viewController.zetronPeerID = self.peerID;
    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Virus!(peripheral)");

}

#pragma mark - Start Game
- (IBAction)startGameButtonTapped:(UIButton *)sender {
    //stops song
    [self.play stop];
    
    //checks if this device's peerID matches that of the peerVirusConfirmed's peerID
    if ([self.session.myPeerID.displayName isEqualToString:self.peerVirusConfirmed.displayName]){
        [self pushToPeripheral];
    } else {
        [self pushToCentral];
    }
    
}
#pragma mark
#pragma mark - Assigning Peripheral
-(void)assignVirusPeripheral{
    
    self.allConnectedPeers = [[NSMutableArray alloc]initWithArray:self.session.connectedPeers];
    [self.allConnectedPeers addObject:self.session.myPeerID];
    
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
    
//    self.centralIDs = [[NSMutableArray alloc]init];
//    for (MCPeerID *peerID in orderedArray){
//        if (peerID != self.peripheralID ){
//            [self.centralIDs addObject:peerID];
//        }
//    }
    
    //each device assigns its own random MCPeerID as virus
    self.localVirusRandomSelection = self.peripheralID;
}
- (void)sendMessageToPeers{
    //sends a message to other devices who is the virus
    NSLog(@"Message sent!");
    
    NSError *error = nil;
    NSDictionary *virusID = @{@"VirusID":self.localVirusRandomSelection};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:virusID];
    
    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    
    NSLog(@"Device chose Virus random: %@", self.localVirusRandomSelection);
    NSLog(@"Data Sent: %@",data);

    
    //tells SELF the data its sending out
    self.peerVirusConfirmed = self.localVirusRandomSelection;
    
}

#pragma mark - Used MCSessionDelegate Methods
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
  
    NSLog(@"Message Received");
    NSLog(@"Received From Peer: %@",peerID);
    
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:nil];
    MCPeerID *virusID = [myDictionary valueForKey:@"VirusID"];
    
    //NSLog(@"Recieved Data: %@",data);
    NSLog(@"Received Data: %@", virusID);
    
    self.peerVirusConfirmed = virusID;
    
    //if you receive Data then:
    //self.releaseVirusButton.hidden = YES;
    self.releaseVirusButton.enabled = NO;
    [self.startGameButton setEnabled:YES];
}


#pragma mark
#pragma mark - Unused MCSession Methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
