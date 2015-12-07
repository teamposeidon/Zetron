//
//  AVAudioPlayerPool.m
//  PPBlueTooth
//
//  Created by Natalia Estrella on 12/6/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "AVAudioPlayerPool.h"




@interface AVAudioPlayerPool()<AVAudioPlayerDelegate>
@property (nonatomic) NSMutableArray *players;

@property (nonatomic) AVAudioPlayer *introAudio;
@property (nonatomic) AVAudioPlayer *gamePlayAudio;
@property (nonatomic) AVAudioPlayer *warningAudio;
@property (nonatomic) AVAudioPlayer *transitionAudio;

@end

@implementation AVAudioPlayerPool

+ (instancetype) sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (AVAudioPlayer *)playerWithURL:(NSURL *)url {
    NSMutableArray* availablePlayers = [[self players] mutableCopy];
    
    // Try and find a player that can be reused and is not playing
    [availablePlayers filterUsingPredicate:[NSPredicate
                                            predicateWithBlock:^BOOL(AVAudioPlayer* evaluatedObject,
                                                                     NSDictionary *bindings) {
                                                return evaluatedObject.playing == NO && [evaluatedObject.url
                                                                                         isEqual:url];
                                            }]];
    
    // If we found one, return it
    if (availablePlayers.count > 0) {
        return [availablePlayers firstObject];
    }
    
    // Didn't find one? Create a new one
    NSError* error = nil;
    AVAudioPlayer* newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                                      error:&error];
    
    if (newPlayer == nil) {
        NSLog(@"Couldn't load %@: %@", url, error);
        return nil;
    }
    
    [[self players] addObject:newPlayer];
    
    return newPlayer;
    
}

//
//IntroAudio
//Begins intro audio
-(void)playIntroAudio{
    if (self.introAudio == nil) {
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"GlassCandy"
                                             withExtension:@"mp3"];
        self.introAudio = [[AVAudioPlayerPool sharedInstance] playerWithURL:url];
    }
    
    [self.introAudio play];
}

//Stops song warning user of nearby virus
-(void)stopIntroAudio {
    [self.introAudio stop];
}

//
// GamePlayAudio
//Begins song that will play throughout gameplay
-(void)playGamePlayAudio {
    if (self.gamePlayAudio == nil) {
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"LazerhawkOverdrive"
                                             withExtension:@"mp3"];
        self.gamePlayAudio = [[AVAudioPlayerPool sharedInstance] playerWithURL:url];
    }
    [self raisesGamePlayAudio];
    [self.gamePlayAudio play];
}

//Stops song that will play throughout gameplay
-(void)stopGamePlayAudio {
    [self.gamePlayAudio stop];
}

//Lowers audio leading into virus mode
-(void)lowersGamePlayAudio {
    self.gamePlayAudio.volume = 0.3f;
}

//Raises audio leading into virus mode
-(void)raisesGamePlayAudio {
    self.gamePlayAudio.volume = 1.0f;
}


//
//TransitionAudio
//Plays audio leading into virus mode
-(void)playTransitionAudio {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"Gunnbladez"
                                         withExtension:@"wav"];
    self.transitionAudio = [[AVAudioPlayerPool sharedInstance] playerWithURL:url];

    [self.transitionAudio play];

    self.transitionAudio.numberOfLoops = 1;
    self.transitionAudio.delegate = self;
    
    [self lowersGamePlayAudio];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (player == self.transitionAudio) {
        [self raisesGamePlayAudio];
        self.transitionAudio = nil;
    }
}

//
//WarningAudio
//Begins song warning user of nearby virus
-(void)playWarningAudio{
    if (self.warningAudio == nil) {
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"newglitch"
                                             withExtension:@"wav"];
        self.warningAudio = [[AVAudioPlayerPool sharedInstance] playerWithURL:url];
    }
    [self lowersGamePlayAudio];
    [self.warningAudio play];
}

//Stops song warning user of nearby virus
-(void)stopWarningAudio {
    [self.warningAudio stop];
}



- (void)setPlayerStates:(AudioPlayerState)playerStates {
    
    NSLog(@"Player State: %@", @(playerStates));

    _playerStates = playerStates;
    
    switch (playerStates) {
        case AudioPlayerStatePregame:
            [self playIntroAudio];
            [self stopGamePlayAudio];
            [self stopWarningAudio];
            break;
            
        case AudioPlayerStateViral:
        case AudioPlayerStatePostGame:
        case AudioPlayerStateHealthy:
            [self playGamePlayAudio];
            [self stopIntroAudio];
            [self stopWarningAudio];
            break;
            
        case AudioPlayerStateClosePoximity:
            [self playWarningAudio];
            [self stopIntroAudio];
            break;

        default:
            break;
    }
}
@end
