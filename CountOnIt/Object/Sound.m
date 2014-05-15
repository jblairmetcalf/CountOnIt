//
//  Sound.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/11/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Sound.h"

@interface Sound ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation Sound

- (Sound *)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], path]];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (_audioPlayer == nil) NSLog(@"%@", [error description]);
    }
    return self;
}

- (void)play
{
    [self.audioPlayer play];
}

@end
