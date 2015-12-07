//////
//////  ViewController.m
//////  PPBlueTooth
//////
//////  Created by Fatima Zenine Villanueva on 11/9/15.
//////  Copyright © 2015 apps. All rights reserved.
//////
////  PPBlueTooth
////
////  Created by Fatima Zenine Villanueva on 11/9/15.
////  Copyright © 2015 apps. All rights reserved.
////
//
//#import "StartScreenVC.h"
//#import <MultipeerConnectivity/MultipeerConnectivity.h>
//#import "PlayerCharacter.h"
//#import "PlayerManager.h"
//#import "BTLECentralViewController.h"
//#import "BTLEPeripheralViewController.h"
//
//
//@interface StartScreenVC () <MCBrowserViewControllerDelegate, MCSessionDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
//@property (weak, nonatomic) IBOutlet UILabel *labelTest;
//@property (nonatomic) NSString *message;
//
//@property (nonatomic) UIAlertController *alertController;
//@property (nonatomic) PlayerCharacter *player;
//@property (nonatomic) PlayerManager *data;
//@property (nonatomic, strong) NSString *userName;
//
//
//@end
//
//@implementation StartScreenVC
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.player = [[PlayerCharacter alloc]init];
//    
//    self.data = [PlayerManager sharedInstance];
//    [self.data initializeModel];
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    self.session.delegate = self;
//    self.backgroundButton.enabled = NO;
//    
//    if (self.player.userName.length == 0) {
//        [self alertControllerShow];
//    }
//}
//
//#pragma mark
//#pragma mark - Alert Controller User Name
//- (void)alertControllerShow{
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:@"Zitch"
//                                          message:@"Who are you?"
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSLog(@"Pressed Okay");
//        self.player.userName = alertController.textFields.firstObject.text;
//        NSLog(@"Username: %@", self.player.userName);
//        
//        self.player.zitronUserName = [NSString stringWithFormat:@"Zitron-%@",self.player.userName];
//        
//        [self.data.player addObject:self.player];
//        
//        NSLog(@"Data Player: %@", self.data.player);
//        
//        [self runAdvertiser];
//    }];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    [alertController addAction:ok];
//    [alertController addAction:cancel];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Username";
//    }];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//#pragma mark
//#pragma mark - Run Advertiser
//- (void)runAdvertiser {
//    
//    // Added a player object with property MCPeerID
//    self.player.mcPeerID = [[MCPeerID alloc]initWithDisplayName:self.player.zitronUserName];
//    //MCPeerID *peerId = [[MCPeerID alloc]initWithDisplayName:self.player.zitronUserName];
//    
//    self.session = [[MCSession alloc]initWithPeer:self.player.mcPeerID];
////    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:ppService discoveryInfo:nil session:self.session];
//    [self.advertiser start];
//}
//
//- (IBAction)showMutlipeer:(id)sender {
//    [self requireDeviceConnected];
//}
//
//#pragma mark
//#pragma mark - Convenience methods
//- (void)requireDeviceConnected
//{
//    if (self.session.connectedPeers.count == 0) {
//        self.browserController;
//       // = [[MCBrowserViewController alloc] initWithServiceType:ppService session:self.session];
//
//        self.browserController.delegate = self;
//        self.backgroundButton.enabled = YES;
//        [self presentViewController:self.browserController animated:YES completion:nil];
//    } else {
//        self.backgroundButton.enabled = YES;
//    }
//}
//
//#pragma mark
//#pragma mark - MCBrowserViewControllerDelegate
//// Notifies the delegate, when the user taps the done button.
//- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self pushToGameplayVC];
//    }];
//}
//
//-(void) pushToGameplayVC{
//    
//    BTLECentralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"CentralID"];
//#import "StartScreenVC.h"
//#import <MultipeerConnectivity/MultipeerConnectivity.h>
//#import "PlayerCharacter.h"
//#import "PlayerManager.h"
//#import "BTLECentralViewController.h"
//#import "BTLEPeripheralViewController.h"
//
//
//@interface StartScreenVC () <MCBrowserViewControllerDelegate, MCSessionDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
//@property (weak, nonatomic) IBOutlet UILabel *labelTest;
//@property (nonatomic) NSString *message;
//
//@property (nonatomic) UIAlertController *alertController;
//@property (nonatomic) PlayerCharacter *player;
//@property (nonatomic) PlayerManager *data;
//@property (nonatomic, strong) NSString *userName;
//
//
//@end
//
//@implementation StartScreenVC
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.player = [[PlayerCharacter alloc]init];
//    
//    self.data = [PlayerManager sharedInstance];
//    [self.data initializeModel];
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    self.session.delegate = self;
//    self.backgroundButton.enabled = NO;
//    
//    if (self.player.userName.length == 0) {
//        [self alertControllerShow];
//    }
//}
//
//#pragma mark
//#pragma mark - Alert Controller User Name
//- (void)alertControllerShow{
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:@"Zitch"
//                                          message:@"Who are you?"
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSLog(@"Pressed Okay");
//        self.player.userName = alertController.textFields.firstObject.text;
//        NSLog(@"Username: %@", self.player.userName);
//        
//        self.player.zitronUserName = [NSString stringWithFormat:@"Zitron-%@",self.player.userName];
//        
//        [self.data.player addObject:self.player];
//        
//        NSLog(@"Data Player: %@", self.data.player);
//        
//        [self runAdvertiser];
//    }];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    [alertController addAction:ok];
//    [alertController addAction:cancel];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Username";
//    }];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//#pragma mark
//#pragma mark - Run Advertiser
//- (void)runAdvertiser {
//    
//    // Added a player object with property MCPeerID
//    self.player.mcPeerID = [[MCPeerID alloc]initWithDisplayName:self.player.zitronUserName];
//    //MCPeerID *peerId = [[MCPeerID alloc]initWithDisplayName:self.player.zitronUserName];
//    
//    self.session = [[MCSession alloc]initWithPeer:self.player.mcPeerID];
////    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:ppService discoveryInfo:nil session:self.session];
//<<<<<<< HEAD
////    
//=======
//    
//>>>>>>> 19597cff4bc0217a8322130f393e77c22630ed35
//    [self.advertiser start];
//}
//
//- (IBAction)showMutlipeer:(id)sender {
//    [self requireDeviceConnected];
//}
//
//#pragma mark
//#pragma mark - Convenience methods
//- (void)requireDeviceConnected
//{
//    if (self.session.connectedPeers.count == 0) {
//<<<<<<< HEAD
//        self.browserController;
//       // = [[MCBrowserViewController alloc] initWithServiceType:ppService session:self.session];
//=======
////        self.browserController
////        = [[MCBrowserViewController alloc] initWithServiceType:ppService session:self.session];
//>>>>>>> 19597cff4bc0217a8322130f393e77c22630ed35
//        self.browserController.delegate = self;
//        self.backgroundButton.enabled = YES;
//        [self presentViewController:self.browserController animated:YES completion:nil];
//    } else {
//        self.backgroundButton.enabled = YES;
//    }
//}
//
//#pragma mark
//#pragma mark - MCBrowserViewControllerDelegate
//// Notifies the delegate, when the user taps the done button.
//- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self pushToGameplayVC];
//    }];
//}
//
//-(void) pushToGameplayVC{
//    
////    BTLECentralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"CentralID"];
////    
////    [self presentViewController:viewController animated:YES completion:nil];
//    
//    BTLEPeripheralViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"Test"];
//    
//    [self presentViewController:viewController animated:YES completion:nil];
//
//    
//}
//
//// Notifies delegate that the user taps the cancel button.
//- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma mark
//#pragma mark - MCSession Send Message
//- (IBAction)backgroundButtonDidTouch:(id)sender {
//    NSError *error;
//    NSString *hey = @"hey";
//    NSData *data = [hey dataUsingEncoding:NSUTF8StringEncoding];
//    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
//}
//
//#pragma mark
//#pragma mark - Used MCSessionDelegate Methods
//- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
//    // If the message is the virus person
//    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    msg = [peerID.displayName stringByAppendingFormat:@": %@", msg];
//    NSLog(@"%@",msg);
//    self.message = msg;
//}
//
//- (IBAction)showMessage:(id)sender {
//    self.labelTest.text = self.message;
//    NSLog(@"self.message: %@", self.message);
//}
//
//
//#pragma mark
//#pragma mark - Unused MCSession Methods
//- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {}
//- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{}
//- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{}
//- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{}
//
//
//@end
