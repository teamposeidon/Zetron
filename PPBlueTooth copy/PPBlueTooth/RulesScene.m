//
//  RulesScene.m
//  ZetronFeatures
//
//  Created by Daniel Distant on 11/19/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "RulesScene.h"

@implementation RulesScene

-(void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated) {
        [self createSceneContents];
        self.backgroundColor = [SKColor clearColor];
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.contentCreated = YES;
    }
    
}

- (void) createSceneContents {
    
    [self createRunnerNodeWithAnimation];
    [self createZetronNodeWithAnimation];
    
//currently this animation looks like crap, don't use it
    
//    [self createRunningGround];
}

- (void) createRunningGround {
    self.runningGround = [SKSpriteNode spriteNodeWithImageNamed:@"runningGround1"];
    self.runningGround.size = CGSizeMake(350, 70);
    self.runningGround.zPosition = -1.0;
    self.runningGround.position = CGPointMake(175, 35);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"runningGround1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"runningGround2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"runningGround3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"runningGround4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"runningGround5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"runningGround6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"runningGround7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"runningGround8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"runningGround9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"runningGround9"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"runningGround10"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"runningGround12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"runningGround13"];
    SKTexture *texture14 = [SKTexture textureWithImageNamed:@"runningGround14"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13, texture14] timePerFrame:0.3];
    
    [self addChild:self.runningGround];
    
    [self.runningGround runAction:[SKAction repeatActionForever:animation]];
}



- (void) createRunnerNodeWithAnimation {
    
    self.healthyRunner = [SKSpriteNode spriteNodeWithImageNamed:@"runner1"];
    self.healthyRunner.size = CGSizeMake(140, 140);
    self.healthyRunner.position = CGPointMake(360, 50);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"runner1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"runner2"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self addChild:self.healthyRunner];
    
    [self.healthyRunner runAction:[SKAction repeatActionForever:animation]];
    
    SKAction *moveRunnerLeft = [SKAction moveToX:170 duration:3];
    
    [self.healthyRunner runAction:moveRunnerLeft completion:^{
        [self createInfectedRunnerNodeWithAnimation];
        [self.healthyRunner removeFromParent];
    }];
    
}

- (void) createZetronNodeWithAnimation {
    
    self.zetron = [SKSpriteNode spriteNodeWithImageNamed:@"zetron1"];
    self.zetron.position = CGPointMake(20, 50);
    self.zetron.size = CGSizeMake(80, 80);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"zetron1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"zetron2"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self addChild:self.zetron];
    
    [self.zetron runAction:[SKAction repeatActionForever:animation]];
    
    SKAction *moveZetronRight = [SKAction moveToX:130 duration:3];
    
    [self.zetron runAction:moveZetronRight];
}

- (void) moveZetronLeft {
    [self.zetron runAction:[SKAction moveToX:-25 duration:3] completion:^{
        [self.zetron removeFromParent];
    }];
}

- (void) createInfectedRunnerNodeWithAnimation {
    
    self.infectedRunner = [SKSpriteNode spriteNodeWithImageNamed:@"infectedRunner1"];
    self.infectedRunner.position = CGPointMake(170, 50);
    self.infectedRunner.size = CGSizeMake(140, 140);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"infectedRunner1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"infectedRunner2"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self addChild:self.infectedRunner];
    
    [self.infectedRunner runAction:[SKAction repeatAction:animation count:5] completion:^{
        [self.infectedRunner removeFromParent];
        [self createZetronRunnerCaughtNodeWithAnimation];
    }];
    [self createZetronProgressBarWithAnimation];
    
}

- (void) createZetronProgressBarWithAnimation {
    self.zetronProgressBar = [SKSpriteNode spriteNodeWithImageNamed:@"infectedRunner1"];
    self.zetronProgressBar.position = CGPointMake(170, 75);
    self.zetronProgressBar.size = CGSizeMake(140, 140);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"zetronProgressBar1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"zetronProgressBar2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"zetronProgressBar3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"zetronProgressBar4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"zetronProgressBar5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"zetronProgressBar6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"zetronProgressBar7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"zetronProgressBar8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"zetronProgressBar9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"zetronProgressBar10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"zetronProgressBar11"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11] timePerFrame:0.18];
    
    [self addChild:self.zetronProgressBar];
    
    [self.zetronProgressBar runAction:animation completion:^{
        [self.zetronProgressBar removeFromParent];
    }];
}

- (void) createZetronRunnerCaughtNodeWithAnimation {
    
    self.viralRunnerCaught = [SKSpriteNode spriteNodeWithImageNamed:@"ZetronRunnerRedCaught1"];
    self.viralRunnerCaught.position = CGPointMake(170, 50);
    self.viralRunnerCaught.size = CGSizeMake(140, 140);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"ZetronRunnerRedCaught1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"ZetronRunnerRedCaught1"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self addChild:self.viralRunnerCaught];
    
    [self.viralRunnerCaught runAction:[SKAction repeatAction:animation count:2] completion:^{
        [self moveZetronLeft];
        [self.viralRunnerCaught removeFromParent];
        [self createZetronRunnerRedNodeWithAnimation];
    }];
    
}

- (void) createZetronRunnerRedNodeWithAnimation {
    
    self.viralRunner = [SKSpriteNode spriteNodeWithImageNamed:@"zetronRunnerRed1"];
    self.viralRunner.size = CGSizeMake(140, 140);
    self.viralRunner.position = CGPointMake(170, 50);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"zetronRunnerRed2"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"zetronRunnerRed1"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self addChild:self.viralRunner];
    
    [self.viralRunner runAction:[SKAction repeatAction:animation count:10] completion:^{
        [self moveZetronRunnerRight];
    }];
}

- (void) moveZetronRunnerRight {
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"zetronRunnerRed2"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"zetronRunnerRed1"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self.viralRunner runAction:[SKAction repeatActionForever:animation]];
    
    [self.viralRunner runAction:[SKAction moveToX:225 duration:3]];
    [self createHealthyRunnerNodeWithAnimation];
    
}

- (void) createHealthyRunnerNodeWithAnimation {
    
    self.healthyRunner = [SKSpriteNode spriteNodeWithImageNamed:@"runner1"];
    self.healthyRunner.position = CGPointMake(360, 50);
    self.healthyRunner.size = CGSizeMake(140, 140);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"runner1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"runner2"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture2, texture1] timePerFrame:0.2];
    
    [self addChild:self.healthyRunner];
    
    [self.healthyRunner runAction:[SKAction repeatActionForever:animation]];
    
    SKAction *moveRunnerLeft = [SKAction moveToX:280 duration:3];
    
    [self.healthyRunner runAction:moveRunnerLeft completion:^{
        [self moveRunnersOffScreen];
    }];
    
}

- (void) moveRunnersOffScreen {
    [self.healthyRunner runAction:[SKAction moveToX:410 duration:2]];
    [self.viralRunner runAction:[SKAction moveToX:410 duration:2.5] completion:^{
        [self.healthyRunner removeFromParent];
        [self.viralRunner removeFromParent];
        self.contentCreated = NO;
        [self createSceneContents];
    }];
}

@end
