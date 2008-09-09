//
//  ITunesController.m
//  Bruckner
//
//  Created by Johannes on 22.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//



#import "ITunesController.h"
#import <EyeTunes/EyeTunes.h>
#import "ETPlaylist+Bruckner.h"

@implementation ITunesController
@synthesize shuffleMode;
@synthesize repeatMode;

#pragma mark Utility methods

- (BOOL) iTunesIsRunning
{
	BOOL running = NO;
	for (NSDictionary *d in [[NSWorkspace sharedWorkspace] launchedApplications]) {
		if ([@"iTunes" isEqualToString:[d objectForKey:@"NSApplicationName"]]) {
			running = YES;
		}
	}
	return running;
}


- (BOOL) trackDidChange
{
	if (currentTrackId == -1)
		return YES;
	else
		return ([[[EyeTunes sharedInstance] currentTrack] databaseId] != currentTrackId);
}


- (BOOL) playlistDidChange
{
	return playlistChanged;
}


# pragma mark Actions

- (IBAction) playPause:(id)sender
{
	EyeTunes *e = [EyeTunes sharedInstance];
	[e playPause];
	[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerPlayPauseNotification
							    object:self];
}

- (IBAction) nextTrack:(id)sender
{
	EyeTunes *e = [EyeTunes sharedInstance];
	[e nextTrack];
	[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerNextTrackNotification
							    object:self];
}

- (IBAction) prevTrack:(id)sender
{
	EyeTunes *e = [EyeTunes sharedInstance];
	[e previousTrack];
	[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerPrevTrackNotification
							    object:self];
}

- (IBAction) changeRating:(id)sender
{
	NSLevelIndicator *indicator = sender;
	int newRating = ([indicator intValue] * 20);
	[[[EyeTunes sharedInstance] currentTrack] setRating:newRating];
}

#pragma mark Repeat & Shuffle

- (void) setRepeatMode:(BOOL)newMode
{
	if (repeatMode != newMode) {
		ETPlaylist *playlist = [[EyeTunes sharedInstance] currentPlaylist];
		DescType mode;
		if (newMode)
			mode = kETRepeatModeAll;
		else
			mode = kETRepeatModeOff;

		[playlist setPropertyWithEnum:mode
					 forDesc:ET_PLAYLIST_PROP_REPEAT];
	}
	repeatMode = newMode;
}

- (void) setShuffleMode:(BOOL)newMode
{
	if (shuffleMode != newMode) {
		ETPlaylist *playlist = [[EyeTunes sharedInstance] currentPlaylist];
		[playlist setPropertyWithInteger:(int) newMode
					 forDesc:ET_PLAYLIST_PROP_SHUFFLE];
	}
	shuffleMode = newMode;
}


- (void) checkRepeatAndShuffle 
{
	ETPlaylist *playlist = [[EyeTunes sharedInstance] currentPlaylist];
	BOOL shuffle = [playlist getPropertyAsIntegerForDesc:ET_PLAYLIST_PROP_SHUFFLE];
	if (shuffle != shuffleMode)
		[self setShuffleMode:shuffle];
	
	DescType repeat = [playlist getPropertyAsEnumForDesc:ET_PLAYLIST_PROP_REPEAT];
	BOOL newRepeat;
	switch (repeat) {
		case kETRepeatModeOne:
			// not implemented yet, leave everything unchanged:
			newRepeat = repeatMode;
			break;
		case kETRepeatModeAll:
			newRepeat = YES;
			break;		
		case kETRepeatModeOff:		
		default:
			newRepeat = NO;
			break;
	}
	
	if (repeatMode != newRepeat)
		[self setRepeatMode:newRepeat];
}

#pragma mark Controll iTunes

- (void) workspaceDidLaunchApplicationNotification:(NSNotification *)n
{
	NSString *app = [[n userInfo] objectForKey:@"NSApplicationBundleIdentifier"];
	if (![app isEqualToString:@"com.apple.iTunes"])
		return;

	[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerITunesLaunchedNotification
							    object:self];
	
	currentTrackId = -1;	
	currentPlaylistId = -1;
}


- (void) workspaceDidTerminateApplicationNotification:(NSNotification *)n
{
	NSString *app = [[n userInfo] objectForKey:@"NSApplicationBundleIdentifier"];
	if ([app isEqualToString:@"com.apple.iTunes"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerITunesTerminatedNotification							    object:self];
	}
}


- (IBAction) startITunes:(id)sender
{
	(void) [[NSWorkspace sharedWorkspace] launchApplication:@"iTunes"];
}




#pragma mark ITunes Notifications


- (void) handleITunesPlayerInfo:(NSNotification *)notification
{
	NSString *state = [[notification userInfo] objectForKey:@"Player State"];
	EyeTunes *e = [EyeTunes sharedInstance];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	playlistChanged = NO;
	
	if ([state isEqualToString:@"Paused"]) {
		[nc postNotificationName:BrucknerPausedNotification object:self];
	} else if ([state isEqualToString:@"Playing"]) {
		if ([self trackDidChange]) {
			currentTrackId = [[e currentTrack] databaseId];
			
			if (currentPlaylistId != [[e currentPlaylist] persistentId]) {
				playlistChanged = YES;
				currentPlaylistId = [[e currentPlaylist] persistentId];				
				//[self checkRepeatAndShuffle];
			}
					
			[nc postNotificationName:BrucknerPlayingNewSongNotification object:self];
		}
		else {
			[nc postNotificationName:BrucknerPlayingNotification object:self];			
		}
	} else if ([state isEqualToString:@"Stopped"]) {
		[nc postNotificationName:BrucknerStoppedNotification object:self];
	}
}


// sourceSaved is also called some seconds after you change 
// 'shuffle' or 'repeat' in iTunes
- (void) handleITunesSourceSaved:(NSNotification *)notification
{
	[self checkRepeatAndShuffle];
}


#pragma mark Startup

// This isn't called in awakeFromNib for startup speed reasons only.
- (void) finishLaunching
{
	if (![self iTunesIsRunning]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerITunesTerminatedNotification
								    object:self];
	} else {
		EyeTunes *e = [EyeTunes sharedInstance];	
		if ([e currentTrack]) {
			// we make sure, UI is updated to current song, even if we're paused.
			[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerPlayingNewSongNotification
									    object:self];
			currentTrackId = [[e currentTrack] databaseId];
			currentPlaylistId = [[e currentPlaylist] persistentId];
			playlistChanged = YES;
		}
		
		[self checkRepeatAndShuffle];
	
		switch ([e playerState]) {
			case kETPlayerStatePlaying:
				// we've already updated UI above.
				break;
			case kETPlayerStatePaused:
				[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerPausedNotification
										    object:self];			
			default:
				break;
		}
	}
	
	NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
	[nc addObserver:self 
	       selector:@selector (workspaceDidTerminateApplicationNotification:)
		   name:NSWorkspaceDidTerminateApplicationNotification
		 object:nil];
	[nc addObserver:self 
	       selector:@selector (workspaceDidLaunchApplicationNotification:)
		   name:NSWorkspaceDidLaunchApplicationNotification
		 object:nil];
}

- (void) awakeFromNib
{
	NSDistributedNotificationCenter *dc = [NSDistributedNotificationCenter defaultCenter];
	[dc addObserver:self
	       selector:@selector (handleITunesPlayerInfo:)
		   name:@"com.apple.iTunes.playerInfo"
		 object:nil];
	[dc addObserver:self
	       selector:@selector (handleITunesSourceSaved:)
		   name:@"com.apple.iTunes.sourceSaved"
		 object:nil];	
}

- (id) init
{
	self = [super init];
	if (!self)
		return nil;
	
	// we guess iTunes doesn't use these IDs
	currentTrackId = -1;	
	currentPlaylistId = -1;
	playlistChanged = YES;
	
	[self setShuffleMode:NO];
	[self setRepeatMode:NO];
	
	return self;
}

- (void) dealloc
{
	NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
	[nc removeObserver:self];

	NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
	[dnc removeObserver:self name:NSWorkspaceDidLaunchApplicationNotification object:nil];
	[dnc removeObserver:self name:NSWorkspaceDidTerminateApplicationNotification object:nil];
	
	[super dealloc];
}

@end
