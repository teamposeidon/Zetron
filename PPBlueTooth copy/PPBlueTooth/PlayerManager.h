//
//  PlayerManager.h
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/14/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerManager : NSObject

@property (nonatomic) NSMutableArray *player;

- (void) initializeModel;

+ (PlayerManager *) sharedInstance; //method that creates an instance of class

@end
