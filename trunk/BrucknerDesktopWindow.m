//
//  DesktopWindow.m
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "BrucknerDesktopWindow.h"


@implementation BrucknerDesktopWindow


// based on http://www.cimgf.com/cocoa-code-snippets/nswindow-snippets/

- (void) awakeFromNib
{
	[self setFrameUsingName:@"BrucknerDesktopWindow"];
}

- (id) initWithContentRect:(NSRect)contentRect
		 styleMask:(unsigned int)aStyle
		   backing:(NSBackingStoreType)bufferingType
		     defer:(BOOL)flag
{
	if (![super initWithContentRect:contentRect 
			      styleMask:NSBorderlessWindowMask 
				backing:bufferingType 
				  defer:flag])
		return nil;
	
	
	[self setLevel:kCGDesktopWindowLevel];
	[self setMovableByWindowBackground:YES];
	[self setBackgroundColor: [NSColor clearColor]];
	[self setOpaque:NO];
	[self setAcceptsMouseMovedEvents:YES];
	
	return self;
}


@end
