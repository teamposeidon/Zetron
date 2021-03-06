//
//  PlayerScene.m
//  PPBlueTooth
//
//  Created by Daniel Distant on 12/1/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "PlayerScene.h"

@implementation PlayerScene

-(void)didMoveToView:(SKView *)view {
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.button];
    
    self.contentCreated = NO;
    
    if (!self.contentCreated) {
        [self createSceneContents];
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.contentCreated = YES;
    }
    
}

- (void) createSceneContents {
    [self createHealthyPlayerLooksLeftRightAnimation];
}


- (void) createHealthyPlayerLooksLeftRightAnimation {
    [self removeAllChildren];
    
    self.healthyPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerHealthyLooksLeftRight1"];
    self.healthyPlayer.size = CGSizeMake(200, 200);
    self.healthyPlayer.anchorPoint = CGPointMake(0,0);
    
    self.checkString = @"playerHealthy";
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerHealthyLooksLeftRight11"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11] timePerFrame:0.15];
    
    [self addChild:self.healthyPlayer];
    
    [self.healthyPlayer runAction:[SKAction repeatAction:animation count:2] completion:^{
        [self.healthyPlayer removeFromParent];
        [self createHealthyPlayerBlinksAnimation];
    }];
    
}

- (void) createHealthyPlayerBlinksAnimation {
    
    self.healthyPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerHealthyBlinks1"];
    self.healthyPlayer.size = CGSizeMake(200, 200);
    self.healthyPlayer.anchorPoint = CGPointMake(0,0);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks11"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks13"];
    SKTexture *texture14 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks14"];
    SKTexture *texture15 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks15"];
    SKTexture *texture16 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks16"];
    SKTexture *texture17 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks17"];
    SKTexture *texture18 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks18"];
    SKTexture *texture19 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks19"];
    SKTexture *texture20 = [SKTexture textureWithImageNamed:@"PlayerHealthyBlinks20"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13, texture14, texture15, texture16, texture17, texture18, texture19, texture20] timePerFrame:0.06];
    
    [self addChild:self.healthyPlayer];
    
    [self.healthyPlayer runAction:animation completion:^{
        [self.healthyPlayer removeFromParent];
        [self createHealthyPlayerSmilesAnimation];
    }];
}

- (void) createHealthyPlayerSmilesAnimation {
    
    self.healthyPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerHealthySmiles1"];
    self.healthyPlayer.size = CGSizeMake(200, 200);
    self.healthyPlayer.anchorPoint = CGPointMake(0,0);
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles11"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"PlayerHealthySmiles13"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13] timePerFrame:0.08];
    
    [self addChild:self.healthyPlayer];
    
    [self.healthyPlayer runAction:animation completion:^{
        [self.healthyPlayer removeFromParent];
        [self createHealthyPlayerLooksLeftRightAnimation];
    }];

}

- (void) createInfectedPlayerYellsAnimation {
    
    [self removeAllChildren];
    
    self.infectedPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerInfectedYells1"];
    self.infectedPlayer.size = CGSizeMake(200, 200);
    self.infectedPlayer.anchorPoint = CGPointMake(0,0);
    
    self.checkString = @"playerInfected";
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells11"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells13"];
    SKTexture *texture14 = [SKTexture textureWithImageNamed:@"PlayerInfectedYells14"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13, texture14] timePerFrame:0.15];
    
    [self addChild:self.infectedPlayer];
    
    [self.infectedPlayer runAction:[SKAction repeatActionForever:animation]];
}

- (void) createInfectedPlayerGoesViralAnimation {
    
    [self removeAllChildren];
    
    self.infectedPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerInfectedGoesViral1"];
    self.infectedPlayer.size = CGSizeMake(200, 200);
    self.infectedPlayer.anchorPoint = CGPointMake(0,0);
    
    self.checkString = @"playerGoesViral";
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral11"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral13"];
    SKTexture *texture14 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral14"];
    SKTexture *texture15 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral15"];
    SKTexture *texture16 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral16"];
    SKTexture *texture17 = [SKTexture textureWithImageNamed:@"PlayerInfectedGoesViral17"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13, texture14, texture15, texture16, texture17] timePerFrame:0.08];
    
    [self addChild:self.infectedPlayer];
    
    [self.infectedPlayer runAction:[SKAction repeatActionForever:animation]];
}

- (void) createViralPlayerAnimation {
    
    [self removeAllChildren];
    
    self.viralPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerInfectedGoesViral1"];
    self.viralPlayer.size = CGSizeMake(200, 200);
    self.viralPlayer.anchorPoint = CGPointMake(0,0);
    
    self.checkString = @"playerViral";
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerViral1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerViral2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerViral3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerViral4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerViral5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerViral6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerViral7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerViral8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerViral9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerViral10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerViral11"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"PlayerViral12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"PlayerViral13"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13] timePerFrame:0.1];
    
    [self addChild:self.viralPlayer];
    
    [self.viralPlayer runAction:[SKAction repeatActionForever:animation]];
}

- (void) createViralPlayerDisappearsAnimation {
    
    [self removeAllChildren];
    
    self.viralPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerViralDisappears1"];
    self.viralPlayer.size = CGSizeMake(200, 200);
    self.viralPlayer.anchorPoint = CGPointMake(0,0);
    
    self.checkString = @"playerViralDisappears";
    
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears3"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears4"];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears5"];
    SKTexture *texture6 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears6"];
    SKTexture *texture7 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears7"];
    SKTexture *texture8 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears8"];
    SKTexture *texture9 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears9"];
    SKTexture *texture10 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears10"];
    SKTexture *texture11 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears11"];
    SKTexture *texture12 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears12"];
    SKTexture *texture13 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears13"];
    SKTexture *texture14 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears14"];
    SKTexture *texture15 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears15"];
    SKTexture *texture16 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears16"];
    SKTexture *texture17 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears17"];
    SKTexture *texture18 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears18"];
    SKTexture *texture19 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears19"];
    SKTexture *texture20 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears20"];
    SKTexture *texture21 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears21"];
    SKTexture *texture22 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears22"];
    SKTexture *texture23 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears23"];
    SKTexture *texture24 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears24"];
    SKTexture *texture25 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears25"];
    SKTexture *texture26 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears26"];
    SKTexture *texture27 = [SKTexture textureWithImageNamed:@"PlayerViralDisappears27"];
    
    SKAction *animation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13, texture14, texture15, texture16, texture17, texture18, texture19, texture20, texture21, texture22, texture23, texture24, texture25, texture26, texture27] timePerFrame:0.1];
    
    [self addChild:self.viralPlayer];
    
    [self.viralPlayer runAction:[SKAction repeatActionForever:animation]];
}

- (void) buttonTapped {
    
    if ([self.checkString isEqualToString:@"playerHealthy"]) {
        [self createInfectedPlayerYellsAnimation];
        
    } else if ([self.checkString isEqualToString:@"playerInfected"]) {
        [self createInfectedPlayerGoesViralAnimation];
        
    } else if ([self.checkString isEqualToString:@"playerGoesViral"]) {
        [self createViralPlayerAnimation];
        
    } else if ([self.checkString isEqualToString:@"playerViral"]) {
        [self createViralPlayerDisappearsAnimation];
        
    } else if ([self.checkString isEqualToString:@"playerViralDisappears"]) {
        [self createHealthyPlayerBlinksAnimation];
    } else {
        NSLog(@"button tapped");
    }
    
}


@end
