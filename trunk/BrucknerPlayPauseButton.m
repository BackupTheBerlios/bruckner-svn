//
//  BrucknerPlayPauseButton.m
//  Bruckner
//
//  Created by Johannes on 23.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "BrucknerPlayPauseButton.h"
#import "ITunesController.h"
#import <EyeTunes/EyeTunes.h>

@implementation BrucknerPlayPauseButton

- (void) setPlaying:(BOOL)isPlaying
{
	if (isPlaying) {
		[self setImage:[NSImage imageNamed:@"Pause.png"]];
	} else {
		[self setImage:[NSImage imageNamed:@"Play.png"]];
	}
}


- (void) handlePlaying:(NSNotification *)notification
{
	[self setPlaying:YES];
}


- (void) handlePaused:(NSNotification *)notification
{
	[self setPlaying:NO];
}


- (void) handlePlayPause:(NSNotification *)notification
{
	EyeTunes *e = [EyeTunes sharedInstance];
	switch ([e playerState]) {
		case kETPlayerStatePlaying:
			[self setPlaying:YES];
			break;
		case kETPlayerStateStopped:
		case kETPlayerStatePaused:
		default:
			[self setPlaying:NO];
			break;
	}
}

- (void) awakeFromNib
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
	       selector:@selector (handlePlayPause:) 
		   name:BrucknerPlayPauseNotification
		 object:nil];
	[nc addObserver:self 
	       selector:@selector (handlePaused:) 
		   name:BrucknerPausedNotification
		 object:nil];
	[nc addObserver:self 
	       selector:@selector (handlePlaying:) 
		   name:BrucknerPlayingNotification
		 object:nil];
	
	[self handlePlayPause:nil];
}


- (void) dealloc 
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}


@end
