//
//  PlayerScene.h
//  PPBlueTooth
//
//  Created by Daniel Distant on 12/1/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerScene : SKScene

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) SKSpriteNode *healthyPlayer;
@property (nonatomic) SKSpriteNode *infectedPlayer;
@property (nonatomic) SKSpriteNode *viralPlayer;
@property (nonatomic) UIButton *button;
@property (nonatomic) NSString *checkString;

@end
