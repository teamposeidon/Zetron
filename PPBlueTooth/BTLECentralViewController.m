

#import "BTLECentralViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "GameOverViewController.h"
#import "BTLEPeripheralViewController.h"
#import "Parse.h"


#import "TransferService.h"

@interface BTLECentralViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UITextView  *textView;
@property (strong, nonatomic) CBCentralManager   *centralManager;
@property (strong, nonatomic) CBPeripheral       *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData      *data;
@property (weak, nonatomic) IBOutlet UIView      *centralView;
@property (nonatomic) NSString                   *stringFromData;

// Timer for Shadow
@property (nonatomic) NSTimer   *timer;
@property (nonatomic) BOOL      countDown;
@property (nonatomic) double    counter;

//Sound
@property (nonatomic) AVAudioPlayer *player;

//Timer for Scanning
@property (nonatomic) NSTimer *scanTimer;

//Round Timer
@property (nonatomic) NSTimer *roundTimer;
@property (nonatomic) NSTimeInterval roundTimeLeft;
@property (strong, nonatomic) IBOutlet UILabel *roundTimerLabel;
@property (nonatomic) BOOL timerIsOn;

// Download
@property (nonatomic) UIProgressView *progressBar;
@property (nonatomic) UILabel *progressBarLabel;
@property (nonatomic) BOOL progressBarIncreasing;
@property (nonatomic) NSNumber *decibelBar;
@property (nonatomic) NSNumber *prevDeciBar;
@property (nonatomic) NSNumber *nuDeciBar;

@property (nonatomic) NSTimer *testTimer;

@end



@implementation BTLECentralViewController

static int progCount = 0;
int rssiCount = 0;
BOOL rssiSetNum;

BOOL alreadyVirus = NO;


#pragma mark
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _data = [[NSMutableData alloc] init];
    
    [self drawCircle];
    
    [self setUpDropShadowSideBar];
    
    [self setUpAdvertisingTimer];
    
    //self.timerIsOn = NO;
    
    [self startGameTimer];
    
    //[self loadProgressBar];
    
    //[self setupPlayerView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    //sound
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate.audioPlayerStartMusic stop];
    
    [appDelegate.audioPlayerGameMusic play];
    
    // Starts the moving gradient effect
    [self.progressView startAnimating];
    
    // Continuously updates the progress value using random values
//    [self simulateProgress];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
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
    
    self.roundTimeLeft = 10;
}

-(void) countDown:(NSTimer *)timer {
    self.roundTimeLeft--;
//    self.roundTimerLabel.text = [NSString stringWithFormat:@":%.2f",self.roundTimeLeft];
//    NSLog(@"Round Time Left:%.2f",self.roundTimeLeft);

    if (self.roundTimeLeft == -1){
        [self.roundTimer invalidate];
        [self pushToGameOverViewController];
    }
    else {
        self.roundTimerLabel.text = @(self.roundTimeLeft).stringValue;
    }
}

#pragma mark
#pragma mark - Custom Progress Bar
//- (void)simulateProgress {
//    
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
//        CGFloat progress  = [self.progressView progress] + increment;
//        [self.progressView setProgress:progress];
//        if (progress < 1.0) {
//            
//            [self simulateProgress];
//        }
//    });
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark
#pragma mark - Load Progress Bar
- (void) loadProgressBar {
    UIProgressView* prog = [[UIProgressView alloc] init];
    self.progressBar = prog;
    self.progressBar.progressTintColor = [UIColor colorWithRed:1.000 green:0.869 blue:0.275 alpha:1.000];
    self.progressBar.trackTintColor = [UIColor darkGrayColor];
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat w = 150;
    CGFloat h = 20;
    [self.progressBar addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBar attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w]];
    [self.progressBar addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBar attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h]];
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3.8 ,80,w,h)];
    [v addSubview:self.progressBar];
    [v addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBar attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:v attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [v addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBar attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:v attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 4;
    
    [self.view addSubview: v];
    
    //creating progress bar label and adding to subview
    self.progressBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3.8, 30, 150, 25)];
    self.progressBarLabel.text = [NSString stringWithFormat:@"virus loading: %d%%", progCount];
    self.progressBarLabel.textAlignment = NSTextAlignmentCenter;
    self.progressBarLabel.font = [UIFont fontWithName:@"Menlo" size:12];
    self.progressBarLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.progressBarLabel];
}

// This is called from virusUploadTime ()
- (void) redVirusUploadProgress {
    [self.progressView setProgress:(self.progressView.progress + 0.01)];
    [self updateProgressBarLabel];
}

// This is called when RSSI hits the RED ZONE
- (void) virusUpoloadTime {
    
    NSTimer *downloadVirusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                   target:self
                                                                 selector:@selector(redVirusUploadProgress)
                                                                 userInfo:nil
                                                                  repeats:YES];
    
}

- (void) updateProgressBarLabel {
    // updates the percentage on virus download
    progCount = self.progressView.progress * 100;
    self.progressBarLabel.text = [NSString stringWithFormat:@"virus loading %d%%", progCount];
}


#pragma mark
#pragma mark - Draw Circle
- (void)drawCircle {
    self.centralView.layer.cornerRadius = self.centralView.frame.size.width / 2;
    self.centralView.layer.cornerRadius = self.centralView.frame.size.height / 2;
    
    // Custom Progress View
    CGRect frame = CGRectMake(0,0, self.centralView.frame.size.width, self.centralView.frame.size.height);
    self.progressView = [[GradientProgressView alloc] initWithFrame:frame];
    self.progressView.layer.cornerRadius = self.progressView.frame.size.width / 2;
    self.progressView.layer.cornerRadius = self.progressView.frame.size.height / 2;
    self.progressView.clipsToBounds = YES;
    
    [self.centralView addSubview:self.progressView];

}


#pragma mark
#pragma mark - Drop Shadow Side Bar
- (void)setUpDropShadowSideBar {
    
    // Side Bar Timer Animation
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(updateShadowTimer)
                                                userInfo:nil
                                                 repeats:YES];
    self.counter = 2.0;
    self.countDown = NO;
    
    // Side Bar Setup Drop Shadow
    [self dropShadowSideBar:self.centralView];
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
    
    self.centralView.layer.shadowOpacity = opacity;
}





/** ***************************************** **/

/** ***************************************** **/
/** **  CENTRAL METHODS ARE DECLARED BELOW ** **/
/** ***************************************** **/

/** ***************************************** **/


#pragma mark
#pragma mark - Central Methods
/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...

    // ... so start scanning
    [self scan];
    
}


/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
    
    NSLog(@"Scanning started");
}
- (void)setUpAdvertisingTimer{
    
    self.scanTimer = [NSTimer timerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(fireScanner:)
                                                 userInfo:nil
                                                  repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];  
    [runLoop addTimer:self.scanTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)fireScanner:(NSTimer *)timer{
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
   // NSLog(@"Scanning!");
}


/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is, 
 *  we start the connection process
 */



- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (RSSI.integerValue > -32 && RSSI.integerValue ) {
        
        alreadyVirus = YES;
        
        [self.centralView setBackgroundColor:[UIColor redColor]];
        
        NSTimer *waitSeconds = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                     target:self
                                                                   selector:@selector(virusUpoloadTime)
                                                                   userInfo:nil
                                                                    repeats:NO];

        if (self.progressView.progress == 1.0){
            [waitSeconds invalidate];
            
            BTLEPeripheralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"PeripheralID"];
            viewController.timeLeftContinued = self.roundTimerLabel.text;
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
        
    } else if (RSSI.integerValue < -55 && alreadyVirus == NO) {
        
        if (self.prevDeciBar == nil && rssiCount == 0){
            self.prevDeciBar = self.decibelBar;
            rssiCount = 1;
        }
        if (rssiCount == 1){
            self.nuDeciBar = self.decibelBar;
            rssiSetNum = YES;
            rssiCount = 2;
        }
        
        if (self.prevDeciBar != nil && self.nuDeciBar != nil){
            if (rssiSetNum == YES){
                NSLog(@"Running Third");
                self.prevDeciBar = self.decibelBar;
                rssiSetNum = NO;
            } else {
                self.nuDeciBar = self.decibelBar;
                rssiSetNum = YES;
            }
            if (self.nuDeciBar < self.prevDeciBar){
                self.progressBarIncreasing = YES;
                [self.progressView setProgress:(self.progressView.progress + 0.09)];
                [self updateProgressBarLabel];
                
            } else if (self.nuDeciBar > self.prevDeciBar){
                self.progressBarIncreasing = NO;
                [self.progressView setProgress:(self.progressView.progress - 0.09)];
                [self updateProgressBarLabel];
                
            }
        }
        
        [self.centralView setBackgroundColor:[UIColor yellowColor]];
        
    }  else if (RSSI.integerValue < -75 && alreadyVirus == NO) {
        [self.progressView setProgress:(self.progressView.progress - 0.00)];
        [self.centralView setBackgroundColor:[UIColor greenColor]];
    }
    

    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    // Ok, it's in range - have we already seen it?
    if (self.discoveredPeripheral != peripheral) {
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    if (self.timerIsOn == NO){
//        [self startGameTimer];
//        self.timerIsOn = YES;
//    }
    
    NSLog(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];

    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}


/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
     
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}


/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // We have, so show the data,
        //[self.textView setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        //[self.roundTimerLabel setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        //NSString* newStr = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        
//        if (self.timerIsOn == NO){
//            NSString *timeString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
//            NSTimeInterval timeLeft = [timeString doubleValue] - 1;
//            self.roundTimeLeft = timeLeft;
//            [self startGameTimer];
//            self.timerIsOn = YES;
//            NSLog(@"Round Timer Started");
//        }
        
        // Cancel our subscription to the characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [self.centralManager cancelPeripheralConnection:peripheral];
//    } else if ([stringFromData isEqualToString:@"endGame"]){
//        
//        [self pushToGameOverViewController];
    }

    // Otherwise, just add the data on to what we already have
    [self.data appendData:characteristic.value];
    
    // Log it
    NSLog(@"Received: %@", stringFromData);
}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    // We're disconnected, so start scanning again
    [self scan];
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}
- (void) pushToGameOverViewController{
    GameOverViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"GameOverID"];
    //viewController.session = self.session;
    viewController.gameEndStatus = @"Survivor";
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)setupPlayerView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:self options:nil];
    PlayerView *playerView = [views firstObject];
    
    //    playerView.showsDrawCount = YES;
    //    playerView.showsFPS = YES;
    //    playerView.showsNodeCount = YES;
    
    playerView.frameInterval = 2;
    playerView.layer.cornerRadius = self.centralView.frame.size.width / 2;
    playerView.layer.cornerRadius = self.centralView.frame.size.height / 2;
    playerView.clipsToBounds = YES;
    playerView.backgroundColor = [SKColor clearColor];
    
    //adding new view container
    
    [self.centralView addSubview:playerView];
    
    PlayerScene *newScene = [[PlayerScene alloc] initWithSize:CGSizeMake(200, 200)];
    [playerView presentScene:newScene];
}

@end
