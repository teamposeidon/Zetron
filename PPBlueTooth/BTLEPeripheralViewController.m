//
//  BrowsePlayersViewController.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/27/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "BTLEPeripheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TransferService.h"
#import "GameOverViewController.h"
#import "AVAudioPlayerPool.h"


@interface BTLEPeripheralViewController () <CBPeripheralManagerDelegate>
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;

@property (weak, nonatomic) IBOutlet UIView *peripheralView;

// Timer for Shadow
@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL countDown;
@property (nonatomic) double counter;

// Timer to send data
@property (nonatomic) NSTimer *advertiserTimer;

// Round Timer
@property (nonatomic) NSTimer *roundTimer;
@property (nonatomic) NSTimeInterval roundTimeLeft;
@property (strong, nonatomic) IBOutlet UILabel *roundTimerLabel;

@end



#define NOTIFY_MTU      20

@implementation BTLEPeripheralViewController


#pragma mark
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Start up the CBPeripheralManager
    // if it matches our server name saved in Appdelegate then a central manager will be createdf
    
    if ([appDelegate.ppService isEqualToString:self.serverName]){
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    }
    
    // Draw Circle
    [self drawCircle];
    
    // Setup Drop Shadow Animation
    [self setUpDropShadowSideBar];
    
    NSLog(@"Session Peers: %@",self.session.connectedPeers);
    
    // Setup Advertising Timer
    //[self setUpAdvertisingTimer];
    
    //[self setupPlayerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        //[self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.timeLeftContinued == nil){
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    }
    
    [self startGameTimer];
    
    //sound
    [[AVAudioPlayerPool sharedInstance] setPlayerStates:AudioPlayerStateViral];


//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    [appDelegate.audioPlayerStartMusic stop];
//    
//    [appDelegate.audioPlayerVirusMusic play];
//    
//    [self performSelector:@selector(playGameMusic) withObject:self afterDelay:5.5];

}

//- (void) playGameMusic {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    [appDelegate.audioPlayerVirusMusic stop];
//    
//    [appDelegate.audioPlayerGameMusic play];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Don't keep it going while we're not showing.
    [self.peripheralManager stopAdvertising];

    [super viewWillDisappear:animated];
}



#pragma mark
#pragma mark - Round Timer Countdown
-(void)startGameTimer{
    self.roundTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(countDown:)
                                                     userInfo:nil
                                                      repeats:YES];
    
    if (self.timeLeftContinued == nil) {
        self.roundTimeLeft = 50;
    } else {
        self.roundTimerLabel.text = self.timeLeftContinued;
        double timeLeftCont = [self.timeLeftContinued doubleValue];
        self.roundTimeLeft = timeLeftCont;
    }
    
}

-(void) countDown:(NSTimer *)timer {
    self.roundTimeLeft--;
    self.roundTimerLabel.text = [NSString stringWithFormat:@":%.2f",self.roundTimeLeft];
    if (self.roundTimeLeft == -1) {
        [self.roundTimer invalidate];
        //[self sendMessageToEndGame];
        [self pushToGameOverViewController];
    }
}

-(void)sendMessageToEndGame{
    
    NSString *endGameCommand = @"endGame";
    
    // Get the data
    self.dataToSend = [endGameCommand dataUsingEncoding:NSUTF8StringEncoding];
    
    // Reset the index
    self.sendDataIndex = 0;
    
    [self.peripheralManager updateValue:self.dataToSend forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
    
    // Start sending
    //[self sendData];
    
}
#pragma mark
#pragma mark - Draw Circle
- (void)drawCircle {
    self.peripheralView.layer.cornerRadius = self.peripheralView.frame.size.width / 2;
    self.peripheralView.layer.cornerRadius = self.peripheralView.frame.size.height / 2;
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
    [self dropShadowSideBar:self.peripheralView];
}

- (void)dropShadowSideBar:(UIView *)glowView {
    glowView.layer.masksToBounds = NO;
    glowView.layer.shadowColor = [UIColor yellowColor].CGColor;
    glowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    glowView.layer.shadowRadius = 30.0;
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
    
    self.peripheralView.layer.shadowOpacity = opacity;
}

//- (IBAction)turnOnPeripheralTouch:(id)sender {
//    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
//}



#pragma mark
#pragma mark - Timer
- (void)setUpAdvertisingTimer{
    
    self.advertiserTimer = [NSTimer timerWithTimeInterval:0.01f
                                                   target:self
                                                 selector:@selector(fireAdvertiser:)
                                                 userInfo:nil
                                                  repeats:YES];
    
    [self.advertiserTimer fire];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.advertiserTimer forMode:NSDefaultRunLoopMode];
}

- (void)fireAdvertiser:(NSTimer *)timer{
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    //NSLog(@"Firing!");
}

#pragma mark
#pragma mark - Peripheral Methods
/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    // ... so build our service.
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                      properties:CBCharacteristicPropertyNotify
                                                                           value:nil
                                                                     permissions:CBAttributePermissionsReadable];

    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                        primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
    

}

/** Catch when someone subscribes to our characteristic, then start sending them data
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central subscribed to characteristic");
    
    // Send this data
    NSString *virus = @"Virus";
    //NSString *roundTimeString = [NSString stringWithFormat:@"%.2f",self.roundTimeLeft];
    
    // Get the data
    //self.dataToSend = [roundTimeString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Reset the index
    self.sendDataIndex = 0;
    
    // Start sending
    [self sendData];
}

/** Recognise when the central unsubscribes
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
}


/** Sends the next amount of data to the connected central
 */
- (void)sendData
{
    // First up, check if we're meant to be sending an EOM
    static BOOL sendingEOM = NO;
    
    if (sendingEOM) {
        
        // send it
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // Did it send?
        if (didSend) {
            
            // It did, so mark it as sent
            sendingEOM = NO;
            
            NSLog(@"Sent: EOM");
        }
        
        // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    
    // We're not sending an EOM, so we're sending data
    
    // Is there any left to send?
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        
        // No data left.  Do nothing
        return;
    }
    
    // There's data left, so send until the callback fails, or we're done.
    
    BOOL didSend = YES;
    
    while (didSend) {
        
        // Make the next chunk
        
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        
        // Send it
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // It was - send an EOM
            
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            
            // Send it
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                
                NSLog(@"Sent: EOM");
            }
            
            return;
        }
    }
}


/** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
 *  This is to ensure that packets will arrive in the order they are sent
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    // Start sending again
    [self sendData];
}

#pragma mark
#pragma mark - Peripheral Virus Alert

- (void)showVirusAlertController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You Are The ZETRON!"
                                                                             message:@"Command: Infiltrate benign systems"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // Alert Message - OK Button
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Seek & Infect!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
        [self startGameTimer];
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
        
    }];
    
    // Alert Message - Cancel Button
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel");
    }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void) pushToGameOverViewController{
    
    GameOverViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"GameOverID"];
    viewController.gameEndStatus = @"ZETRON";
    //viewController.session = self.session;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)setupPlayerView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:self options:nil];
    PlayerView *playerView = [views firstObject];
    
    //    playerView.showsDrawCount = YES;
    //    playerView.showsFPS = YES;
    //    playerView.showsNodeCount = YES;
    
    playerView.frameInterval = 2;
    playerView.layer.cornerRadius = self. peripheralView.frame.size.width / 2;
    playerView.layer.cornerRadius = self.peripheralView.frame.size.height / 2;
    playerView.clipsToBounds = YES;
    playerView.backgroundColor = [SKColor clearColor];
    
    //adding new view container
    
    [self.peripheralView addSubview:playerView];
    
    PlayerScene *newScene = [[PlayerScene alloc] initWithSize:CGSizeMake(200, 200)];
    [playerView presentScene:newScene];
}




@end
