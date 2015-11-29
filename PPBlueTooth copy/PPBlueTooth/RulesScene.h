//
//  RulesScene.h
//  ZetronFeatures
//
//  Created by Daniel Distant on 11/19/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RulesScene : SKScene

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) SKSpriteNode *zetron;
@property (nonatomic) SKSpriteNode *healthyRunner;
@property (nonatomic) SKSpriteNode *infectedRunner;
@property (nonatomic) SKSpriteNode *viralRunner;
@property (nonatomic) SKSpriteNode *viralRunnerCaught;
@property (nonatomic) SKSpriteNode *zetronProgressBar;
@property (nonatomic) SKSpriteNode *runningGround;
@property (nonatomic) SKSpriteNode *stillGround;

@end
