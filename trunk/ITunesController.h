//
//  ITunesController.h
//  Bruckner
//
//  Created by Johannes on 22.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BrucknerITunesEvents.h"

@interface ITunesController : NSObject {
	int currentTrackId;
	long long int currentPlaylistId;
	BOOL playlistChanged;
	
	BOOL shuffleMode;
	BOOL repeatMode;
}

@property (readwrite) BOOL shuffleMode;
@property (readwrite) BOOL repeatMode;

- (IBAction) playPause:(id)sender;
- (IBAction) nextTrack:(id)sender;
- (IBAction) prevTrack:(id)sender;
- (IBAction) changeRating:(id)sender;

- (BOOL) playlistDidChange;
- (void) finishLaunching;



@end
