//
//  AVAudioPlayerPool.h
//  PPBlueTooth
//
//  Created by Natalia Estrella on 12/6/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger, AudioPlayerState) {
    //pregame play
    //not in danger
    //in danger
    //going into virus
    //post game play
    
    AudioPlayerStatePregame,
    AudioPlayerStateHealthy,
    AudioPlayerStateViral,
    AudioPlayerStateClosePoximity,
    AudioPlayerStatePostGame
};

@interface AVAudioPlayerPool : NSObject

@property (nonatomic) AudioPlayerState playerStates;

+ (instancetype) sharedInstance;

-(void)playTransitionAudio;
@end
