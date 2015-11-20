//
//  PlayerCharacter.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/12/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PlayerCharacter : NSObject

@property (nonatomic) BOOL virus;
@property (nonatomic) BOOL infected;
@property (nonatomic) BOOL healthy;

@property (nonatomic) NSUInteger rand;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *zitronUserName;
@property (nonatomic, strong) MCPeerID *mcPeerID;

@end







