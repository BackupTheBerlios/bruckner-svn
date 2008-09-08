//
//  BrucknerPanelController.m
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <EyeTunes/EyeTunes.h>
#import "BrucknerPanelController.h"
#import "ITunesController.h"
#import "NSImage+Bruckner.h"
#import "ETEyeTunes+Bruckner.h"


@implementation BrucknerPanelController
@synthesize timePlayed;

- (NSString *) timeStringForSeconds:(int)time
{
	int hours, minutes, seconds;
	int t = time;
	NSString *signStr;
	
	if (t < 0)
		t *= (-1);
	
	seconds = t % 60;
	t /= 60;
	minutes = t % 60;
	t /= 60;
	hours = t % 24;
	
	if (time < 0)
		signStr = @"-";
	else
		signStr = @"";
	
	if (hours != 0)
		return [NSString stringWithFormat:@"%@%02d:%02d:%02d", signStr, hours, minutes, seconds];
	else
		return [NSString stringWithFormat:@"%@%02d:%02d", signStr, minutes, seconds];
}

- (void) setControllsToNil
{
	[albumArtView setImage:nil];
	[playlistPopup setMenu:nil];
	[albumPopup setMenu:nil];
	[trackField setStringValue:@""];
	[albumField setStringValue:@""];
	[artistField setStringValue:@""];
	[playlistField setStringValue:@"Playlist:"];
	[ratingIndicator setFloatValue:0];
	[timePlayedField setStringValue:@"00:00"];
	[timeRemainingField setStringValue:@"-00:00"];
}

- (void) updateTime:(NSTimer *)timer
{
	EyeTunes *e = [EyeTunes sharedInstance];
	[self setTimePlayed:[e playerPosition]];
	timeRemaining = ([[e currentTrack] duration] - timePlayed) * (-1);	
	[timePlayedField setStringValue:[self timeStringForSeconds:timePlayed]];
	[timeRemainingField setStringValue:[self timeStringForSeconds:timeRemaining]];
	
}


#pragma mark Popup Menus

- (void) _dummySelector {}

- (void) playTrackSelectedIn:(NSPopUpButton *)popup
{
	ETTrack *track = [[popup selectedItem] representedObject];
	EyeTunes *e = [EyeTunes sharedInstance];
	[e playTrack:track];
}

- (void) handleAlbumTrackSelected:(id)sender
{
	[self playTrackSelectedIn:albumPopup];
}

- (void) handlePlaylistTrackSelected:(id)sender
{
	[self playTrackSelectedIn:playlistPopup];
}


- (void) fillAlbumPopup
{
	EyeTunes *e = [EyeTunes sharedInstance];
	ETTrack *track = [e currentTrack];
	
	NSMenu *popupMenu = [[NSMenu alloc] initWithTitle:[track album]];
	NSArray *albumTracks = [e search:[e libraryPlaylist]
			       forString:[track album]
				 inField:kETSearchAttributeAlbums];
	
	// Album Title and Album Artist
	[popupMenu addItemWithTitle:[track album]
			     action:@selector (_dummySelector:) 
		      keyEquivalent:@""];
	if ([[e currentTrack] compilation]) {
		[popupMenu addItemWithTitle:[track albumArtist] 
				     action:@selector (_dummySelector:)
			      keyEquivalent:@""];
	} else {
		[popupMenu addItemWithTitle:[track artist] 
				     action:@selector (_dummySelector:)
			      keyEquivalent:@""];
	}
	[popupMenu addItem:[NSMenuItem separatorItem]];
	
	// TODO Do this better
	// We assume that all tracks with the same album title and same albumArtist are a compilation.
	// Furthermore, we assume that an album is defined by "all tracks with same artist and same album title".
	// This is more a try-and-error-based solution, than a very sophisticated one. Better ideas?
	for (ETTrack *t in albumTracks) {
		
		// Searching for 'Greatest Hits II', we also get 'Greatest Hits III'
		if (![[t album] isEqualToString:[track album]])
			continue;
		
		
		if ([t compilation]) {
			if (![[t albumArtist] isEqualToString:[track albumArtist]]) {
				continue;
			}
		} else {
			if (![[t artist] isEqualToString:[track artist]])
				continue;
		}
		
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[t name]
							      action:@selector (handleAlbumTrackSelected:)
						       keyEquivalent:@""];
	
		[item setRepresentedObject:t];
		[item setTarget:self];
		[popupMenu addItem:item];
		[item release];
	}
	
	[albumPopup setMenu:popupMenu];
	[popupMenu release];
	[albumPopup selectItemWithTitle:[track name]];
	
}

- (void) fillPlaylistPopup
{
	EyeTunes *e = [EyeTunes sharedInstance];
	if ([iTunesController playlistDidChange]) {
		
		[playlistField setStringValue:[[e currentPlaylist] name]];
		
		NSMenu *popupMenu = [[NSMenu alloc] initWithTitle:[[e currentPlaylist] name]];
		
		[popupMenu addItemWithTitle:[[e currentPlaylist] name] 
				     action:@selector(_dummySelector:) 
			      keyEquivalent:@""];
		[popupMenu addItem:[NSMenuItem separatorItem]];
		
		for (ETTrack *t in [[e currentPlaylist] tracks]) {
			NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[t name]
								      action:@selector (handlePlaylistTrackSelected:)
							       keyEquivalent:@""];
			
			[item setRepresentedObject:t];
			[item setTarget:self];
			[popupMenu addItem:item];
			[item release];
		}
		[playlistPopup setMenu:popupMenu];
		[popupMenu release];
	}
	[playlistPopup selectItemWithTitle:[[e currentTrack] name]]; 	
}


#pragma mark Actions

- (IBAction) changeTrackPosition:(id)sender
{
	NSLevelIndicator *indicator = sender;
	EyeTunes *e = [EyeTunes sharedInstance];
	[e setPlayerPosition:[indicator intValue]];
}

#pragma mark Notification Handlers

- (void) iTunesTerminated:(NSNotification *)notification
{
	[self setControllsToNil];
}

- (void) handleStopped:(NSNotification *)notification
{
	if (timer) {
		[timer invalidate];
		[timer release];
	}
}

- (void) handlePlayingNewSong:(NSNotification *)notification
{
	EyeTunes *e = [EyeTunes sharedInstance];
	ETTrack *track = [e currentTrack];

	[timePlayedField setStringValue:@"00:00"];
	[timeRemainingField setStringValue:@"00:00"];
	
	timePlayed = [e playerPosition];
	timeRemaining = [track duration] * (-1);
	
	[timeIndicator setMaxValue:(double)[track duration]];
	
	// start timer.
	if (timer) {
		[timer invalidate];
		[timer release];
	}
	timer = [[NSTimer scheduledTimerWithTimeInterval:.5
						  target:self
						selector:@selector (updateTime:)
						userInfo:e
						 repeats:YES] retain];

	[trackField setStringValue:[track name]];
	[albumField setStringValue:[track album]];
	[artistField setStringValue:[track artist]];
	[ratingIndicator setFloatValue:[track rating] / 20.0];

	NSImage *albumArt;
	if ([[track artwork] count] != 0) {
		albumArt = [[track artwork] objectAtIndex:0];
	} else {
		albumArt = [NSImage albumArtImageForTrack:track];
	}
	[albumArtView setImage:albumArt];	// can be nil
	
	[self fillAlbumPopup];
	[self fillPlaylistPopup];		
}

- (void)animationDidStop:(CAAnimation *)theAnimation
		finished:(BOOL)flag
{
	if ([brucknerPanel alphaValue] == 0.0)
		[brucknerPanel orderOut:self];
}

- (void) windowDidResignKey:(NSNotification *)notification
{
	// just start the animation and order out in animationDidStop.
	[[brucknerPanel animator] setAlphaValue:0.0];
}

#pragma mark Delegate Methods

- (BOOL) windowShouldClose:(id)window
{
	// don't allow the window to be closed.
	// just start the animation and order out in animationDidStop.
	[[brucknerPanel animator] setAlphaValue:0.0];
	return NO;
}

#pragma mark Initialization

- (void) awakeFromNib
{
	[trackField setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
	       selector:@selector (handlePlayingNewSong:)
		   name:BrucknerPlayingNewSongNotification
		 object:nil];
	[nc addObserver:self
	       selector:@selector (iTunesTerminated:)
		   name:BrucknerITunesTerminatedNotification
		 object:nil];
	
	[nc addObserver:self
	       selector:@selector (windowDidResignKey:)
		   name:NSWindowDidResignKeyNotification
		 object:nil];
	
	CAAnimation *anim = [CABasicAnimation animation];
	[anim setDelegate:self];
	[brucknerPanel setAnimations:[NSDictionary dictionaryWithObject:anim
								 forKey:@"alphaValue"]];
	
	[self setControllsToNil];
}

- (void) dealloc
{
	[iTunesController release];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}


@end
