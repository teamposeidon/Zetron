//
//  PlayerManager.m
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/14/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

+ (PlayerManager *) sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) initializeModel {
    
    if (self.player == nil){
        self.player = [[NSMutableArray alloc] init];
    } else {
        nil;
    }
}

@end
