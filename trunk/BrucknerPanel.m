//
//  BrucknerPanel.m
//  Bruckner
//
//  Created by Johannes on 07.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <EyeTunes/EyeTunes.h>
#import "BrucknerPanel.h"
#import "ETPlaylist+Bruckner.h"

@implementation BrucknerPanel

// TODO: add user preferences for shortcuts and fix this class

#define BRUCKNER_KEY_ESCAPE		53
#define BRUCKNER_KEY_SPACE		49
#define BRUCKNER_KEY_LEFT	       123
#define BRUCKNER_KEY_RIGHT	       124
#define BRUCKNER_KEY_N			45
#define BRUCKNER_KEY_B			11
#define BRUCKNER_KEY_P			35
#define BRUCKNER_KEY_R			15
#define BRUCKNER_KEY_S			 1
#define BRUCKNER_KEY_Q			12
#define BRUCKNER_KEY_NUMERIC_FOUR	86
#define BRUCKNER_KEY_NUMERIC_FIVE	87
#define BRUCKNER_KEY_NUMERIC_SIX	88
#define BRUCKNER_KEY_NUMERIC_ZERO	82

- (void) keyDown:(NSEvent *)event
{
	if ([event isARepeat])
		return;

	EyeTunes *e = [EyeTunes sharedInstance];
	ETPlaylist *playlist = [e currentPlaylist];

	switch ([event keyCode]) {
		case BRUCKNER_KEY_ESCAPE:
			[self performClose:event];
			break;
		case BRUCKNER_KEY_SPACE:
		case BRUCKNER_KEY_P:
		case BRUCKNER_KEY_NUMERIC_ZERO:
		case BRUCKNER_KEY_NUMERIC_FIVE:			
			[e playPause];
			break;
		case BRUCKNER_KEY_LEFT:
		case BRUCKNER_KEY_B:
		case BRUCKNER_KEY_NUMERIC_FOUR:			
		case NSLeftArrowFunctionKey:
			[e previousTrack];
			break;
		case BRUCKNER_KEY_RIGHT:
		case BRUCKNER_KEY_N:
		case BRUCKNER_KEY_NUMERIC_SIX:			
		case NSRightArrowFunctionKey:
			[e nextTrack];
			break;
		case BRUCKNER_KEY_S:
			if ([playlist isShuffled])
				[playlist setShuffled:NO];
			else
				[playlist setShuffled:YES];
			break;
		case BRUCKNER_KEY_R:
			//[e switchRepeat];
			break;
		default:
			break;
	}
}


@end
