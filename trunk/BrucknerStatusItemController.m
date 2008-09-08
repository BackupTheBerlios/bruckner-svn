//
//  BrucknerStatusItemController.m
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "BrucknerStatusItemController.h"
#import "BrucknerStatusItemView.h"
#import "MAAttachedWindow.h"

@implementation BrucknerStatusItemController

- (void) closeAttachedWindow
{
	[attachedWindow setDelegate:nil];
	[attachedWindow release];
	attachedWindow = nil;
}


- (void) toggleAttachedWindowAtPoint:(NSPoint)pt
{
	/*
	// Attach/detach window.
	if (!attachedWindow) {
		attachedWindow = [[MAAttachedWindow alloc] initWithView:statusItemBrucknerView
							attachedToPoint:pt
							       inWindow:nil
								 onSide:MAPositionBottom
							     atDistance:0.0];
		[attachedWindow setBorderWidth:0.5];
		[attachedWindow setViewMargin:0.0];
		[attachedWindow makeKeyAndOrderFront:self];
	} else {
		[self closeAttachedWindow];
	} 
	*/
}


- (void) handleShowStatusItemWindow:(NSNotification *)notification
{
	NSValue *pointValue = [[notification userInfo] objectForKey:@"pointValue"];
	[self toggleAttachedWindowAtPoint:[pointValue pointValue]];
}



- (void) createStatusItem
{
	float width = 30.0;
	float height = [[NSStatusBar systemStatusBar] thickness];
	NSRect viewFrame = NSMakeRect(0, 0, width, height);
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
	statusItemView = [[[BrucknerStatusItemView alloc] 
			   initWithFrame:viewFrame] autorelease];
	[statusItem setView:statusItemView];	
}

- (void) awakeFromNib
{
	[self createStatusItem];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
	       selector:@selector (handleShowStatusItemWindow:)
		   name:BrucknerShowStatusItemWindowNotification
		 object:nil];	
}

- (void) dealloc
{
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
	[super dealloc];
}


@end
