//
//  AlbumArtView.m
//  Bruckner
//
//  Created by Johannes on 27.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "BrucknerAlbumArtView.h"
#import <QuartzCore/CoreAnimation.h>
#import <EyeTunes/EyeTunes.h>
#import "NSImage+Bruckner.h"

/*
   NOTE: the whole Core Animation stuff sucks. Strictly speaking, this whole class sucks.
   I guess I should study the Core Animation documentation.
 
   For now, the mouseEntered & mouseExited stuff is more or less just a "prove of concept".
   I hope you get the idea, what Bruckner should do.
 */

@implementation BrucknerAlbumArtView

- (void) drawRect:(NSRect)rect 
{
	NSRect bounds = [self bounds];
	[[NSColor colorWithCalibratedWhite:0.0 alpha:0.8] set];
	[NSBezierPath fillRect:bounds];
}


// TODO: non-square album art images shouldn't be scaled to 150x150
- (void) displayImage:(NSImage *)image
{
	if (cgImage)
		CGImageRelease (cgImage);
	cgImage = [image cgImage];
	imageLayer.contents = (id) cgImage;
}


#pragma mark Mouse Events

- (void) mouseEntered:(NSEvent *)event
{
	imageLayer.anchorPoint = CGPointMake(0.5, 0);
	[brucknerView setHidden:NO];
	[brucknerView setNeedsDisplay:YES];
}

- (void) mouseExited:(NSEvent *)event
{
	[brucknerView setHidden:YES];
	imageLayer.anchorPoint = CGPointMake(0.5, 0.5);
}

#pragma mark Initialization

- (void) setupLayers
{
	imageLayer = [CALayer layer];

	// 150x150 hardcoded here!
	imageLayer.frame = CGRectMake (0, 0, 150, 150);
	imageLayer.bounds = CGRectMake (0, 0, 150, 150);
	imageLayer.anchorPoint = CGPointMake(0.5, 0.5);
	imageLayer.position = CGPointMake ([self frame].size.width / 2, [self frame].size.height / 2);
	imageLayer.contents = (id) cgImage;
	
	[[self layer] addSublayer:imageLayer];
}


- (void) viewDidMoveToWindow
{
	int options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect;
	NSTrackingArea *ta;
	ta = [[NSTrackingArea alloc] initWithRect:NSZeroRect
					  options:options
					    owner:self
					 userInfo:nil];
	[self addTrackingArea:ta];
	[ta release];
}


- (void) awakeFromNib
{
	[self setWantsLayer:YES];
	[self setupLayers];
}

- (void) dealloc
{
	CGImageRelease (cgImage);
	[super dealloc];
}


@end
