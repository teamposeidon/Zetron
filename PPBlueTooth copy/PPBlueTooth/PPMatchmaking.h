//
//  PPMatchmaking.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/9/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol PPMatchmakingDelegate;


@interface PPMatchmaking : NSObject

#pragma mark
#pragma mark - Properties

@property (nonatomic, strong) MCSession *session;
/// Delegate for the PartyTime methods
@property (nonatomic, weak) id<PPMatchmakingDelegate> delegate;

/// Query whether the client has joined the party
@property (nonatomic, readonly) BOOL connected;
/// Returns the current client's MCPeerID
@property (nonatomic, readonly, strong) MCPeerID *peerID;
/// Returns an array of MCPeerIDs which represents the connected peers. Doesn't include the current client's peer ID.
@property (nonatomic, readonly) NSArray *connectedPeers;
/// Returns the serviceType which was passed in when the object was initialized.
@property (nonatomic, readonly, strong) NSString *serviceType;
/// Returns the display name which was passed in when the object was initialized.
/// If no display name was specified, it defaults to [UIDevice currentDevice].name]
@property (nonatomic, readonly, strong) NSString *displayName;

#pragma mark
#pragma mark - Initialization

- (instancetype)initWithServiceType:(NSString *)serviceType;

- (instancetype)initWithServiceType:(NSString *)serviceType
                        displayName:(NSString *)displayName;

- (void)joinParty;

- (void)stopAcceptingGuests;

- (void)leaveParty;


- (BOOL)sendData:(NSData *)data
        withMode:(MCSessionSendDataMode)mode
           error:(NSError **)error;


- (BOOL)sendData:(NSData *)data
         toPeers:(NSArray *)peerIDs
        withMode:(MCSessionSendDataMode)mode
           error:(NSError **)error;


- (NSOutputStream *)startStreamWithName:(NSString *)streamName
                                 toPeer:(MCPeerID *)peerID
                                  error:(NSError **)error;


- (NSProgress *)sendResourceAtURL:(NSURL *)resourceURL
                         withName:(NSString *)resourceName
                           toPeer:(MCPeerID *)peerID
            withCompletionHandler:(void (^)(NSError *error))completionHandler;

@end


@protocol PPMatchmakingDelegate <NSObject>

@required
- (void)partyTime:(PPMatchmaking *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers;

- (void)partyTime:(PPMatchmaking *)partyTime
failedToJoinParty:(NSError *)error;

@optional
- (void)partyTime:(PPMatchmaking *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID;

- (void)partyTime:(PPMatchmaking *)partyTime
 didReceiveStream:(NSInputStream *)stream
         withName:(NSString *)streamName
         fromPeer:(MCPeerID *)peerID;

- (void)partyTime:(PPMatchmaking *)partyTime
didStartReceivingResourceWithName:(NSString *)resourceName
         fromPeer:(MCPeerID *)peerID
     withProgress:(NSProgress *)progress;

- (void)partyTime:(PPMatchmaking *)partyTime
didFinishReceivingResourceWithName:(NSString *)resourceName
         fromPeer:(MCPeerID *)peerID
            atURL:(NSURL *)localURL
        withError:(NSError *)error;

@end
