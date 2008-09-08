//
//  AppController.m
//  Bruckner
//
//  Created by Johannes on 22.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <EyeTunes/EyeTunes.h>
#import <Carbon/Carbon.h>
#import "AppController.h"
#import "NSImage+Bruckner.h"
#import "BrucknerITunesEvents.h"

@implementation AppController
@synthesize brucknerPanel;

#pragma mark Notification handlers

- (void) handlePlayingNewSong:(NSNotification *)n
{
	EyeTunes *e = [EyeTunes sharedInstance];
	ETTrack *track = [e currentTrack];
	NSImage *image;

	[currentSongMenuItem setTitle:[track name]];
	
	if ([[track artwork] count] != 0)
		image = [[[track artwork] objectAtIndex:0] retain];
	else
		image = [NSImage albumArtImageForTrack:track];
	
	[NSApp setApplicationIconImage:image];
	[image release];
}

- (void) handleStopped:(NSNotification *)n
{
	[NSApp setApplicationIconImage:[NSImage imageNamed:@"BB"]];
	[currentSongMenuItem setTitle:@"Bruckner"];
}


#pragma mark Global Hot Key

- (void)animationDidStop:(CAAnimation *)theAnimation
		finished:(BOOL)flag
{
	if ([brucknerPanel alphaValue] == 0.0)
		[brucknerPanel orderOut:self];
}

enum BrucknerHotKey {
	BRUCKNER_HOTKEY_SHOW_WINDOW = 1
};


void
showAndHideBrucknerPanel (id myself)
{
	NSWindow *brucknerPanel = [myself brucknerPanel];
	if ([brucknerPanel isVisible]) {
		// just start the animation and order out in animationDidStop.
		[[brucknerPanel animator] setAlphaValue:0.0];
	} else {
		[brucknerPanel makeKeyAndOrderFront:myself];
		[[brucknerPanel animator] setAlphaValue:1.0];
	}
	
}

OSStatus 
handleHotKey (EventHandlerCallRef nextHandler, 
	      EventRef theEvent, 
	      void *userData)
{
	EventHotKeyID hkCom;
	GetEventParameter (theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL,
			   sizeof (hkCom), NULL, &hkCom);

	switch (hkCom.id) {
		case BRUCKNER_HOTKEY_SHOW_WINDOW:
			showAndHideBrucknerPanel (userData);
			break;
		default:
			break;
	}
	return noErr;
}

- (void) registerHotKey
{
	EventHotKeyRef hotKeyRef;
	EventHotKeyID hotkeyID;
	EventTypeSpec eventType;
	
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind = kEventHotKeyPressed;
	
	// we pass 'self' as userData, so we can access it from C-functions
	InstallApplicationEventHandler (&handleHotKey, 1, &eventType, self, NULL);
	
	hotkeyID.signature = 'bhsw';	// Bruckner Hotkey Show Window
	hotkeyID.id = BRUCKNER_HOTKEY_SHOW_WINDOW;
	RegisterEventHotKey(kVK_F6, 0, hotkeyID, GetApplicationEventTarget(), 0, &hotKeyRef); 
}

#pragma mark Delegate Methods

/*
- (void) applicationDidBecomeActive:(NSNotification *)n
{
	if (![brucknerPanel isVisible]) {
		[brucknerPanel makeKeyAndOrderFront:self];
		[[brucknerPanel animator] setAlphaValue:1.0];
	}
		
}
*/
 
- (void) applicationDidFinishLaunching:(NSNotification *)n
{
	[iTunesController finishLaunching];
}

- (void) applicationWillTerminate:(NSNotification *)n
{
	[brucknerDesktopWindow saveFrameUsingName:@"BrucknerDesktopWindow"]; 
}


#pragma mark Initialization

- (void) awakeFromNib
{
	CAAnimation *anim = [CABasicAnimation animation];
	[anim setDelegate:self];
	[brucknerPanel setAnimations:[NSDictionary dictionaryWithObject:anim
								 forKey:@"alphaValue"]];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
	       selector:@selector (handlePlayingNewSong:)
		   name:BrucknerPlayingNewSongNotification
		 object:nil];
	[nc addObserver:self
	       selector:@selector (handleStopped:)
		   name:BrucknerStoppedNotification
		 object:nil];
	
	[self registerHotKey];
}



@end
