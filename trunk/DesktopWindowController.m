//
//  DesktopWindowController.m
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "DesktopWindowController.h"
#import "ITunesController.h"
#import "BrucknerAlbumArtView.h"
#import "NSImage+Bruckner.h"
#import <EyeTunes/EyeTunes.h>

@implementation DesktopWindowController

#pragma mark Notification handlers

- (void) handlePlayingNewSong:(NSNotification *)notification
{
	EyeTunes *e = [EyeTunes sharedInstance];
	ETTrack *track = [e currentTrack];
	
	[trackField setStringValue:[track name]];
	NSString *s = [NSString stringWithFormat:@"%@ – %@", [track album], [track artist]];
	[albumAndArtistField setStringValue:s];
	
	
	if ([[track artwork] count] != 0) {
		NSImage *albumArt = [[track artwork] objectAtIndex:0];
		[albumArtView displayImage:albumArt];
	} else {
		NSImage *image = [NSImage albumArtImageForTrack:track];
		[albumArtView displayImage:image];	
		[image release];
	}
}

- (void) handleITunesLaunched:(NSNotification *)notification
{
	// we do nothing here and just wait for a BrucknerPlayingNewSongNotification.
}

- (void) handleITunesTerminated:(NSNotification *)notification
{
	[trackField setStringValue:@""];
	[albumAndArtistField setStringValue:@""];
	[albumArtView displayImage:[NSImage imageNamed:@"Bruckner150"]];
}

#pragma mark Delegate Methods

- (BOOL) windowShouldClose:(id)window
{
	return YES;
}


#pragma mark Initialize

- (void) awakeFromNib
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
	       selector:@selector (handlePlayingNewSong:)
		   name:BrucknerPlayingNewSongNotification
		 object:nil];
	
	[nc addObserver:self
	       selector:@selector (handleITunesTerminated:)
		   name:BrucknerITunesTerminatedNotification
		 object:nil];
	[nc addObserver:self
	       selector:@selector (handleITunesLaunched:)
		   name:BrucknerITunesLaunchedNotification
		 object:nil];
	
	[trackField setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
	[albumAndArtistField setFont:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]]];			
}

- (void) dealloc
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}

@end
