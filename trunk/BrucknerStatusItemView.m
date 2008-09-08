//
//  BrucknerStatusItemView.m
//  Bruckner
//
//  Created by Johannes on 22.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "BrucknerStatusItemView.h"
#import "AppController.h"

NSString * const BrucknerShowStatusItemWindowNotification = @"BrucknerShowStatusItemWindow";

@implementation BrucknerStatusItemView

- (void) mouseDown:(NSEvent *)event
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	/*
	// Handle double click, ignore triple click
	if ([event clickCount] >= 2) {
		[nc postNotificationName:BrucknerPlayPauseNotification object:self];
		clicked = NO;
		[self setNeedsDisplay:YES];
		return;
	}
	*/
	
	NSRect frame = [[self window] frame];
	NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
	NSValue *ptValue = [NSValue valueWithPoint:pt];
	
	[nc postNotificationName:BrucknerShowStatusItemWindowNotification 
			  object:self
			userInfo:[NSDictionary dictionaryWithObject:ptValue forKey:@"pointValue"]];
	clicked = !clicked;
	[self setNeedsDisplay:YES];
}

- (void) drawRect:(NSRect)rect 
{
	NSString *text = @"❡";
	NSColor *textColor = [NSColor controlTextColor];
	
	if (clicked) {
		textColor = [NSColor selectedMenuItemTextColor];
		[[NSColor selectedMenuItemColor] set];
		NSRectFill(rect);

	}
		
	NSFont *msgFont = [NSFont menuBarFontOfSize:15.0];
	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
	[paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
	[paraStyle setAlignment:NSCenterTextAlignment];
	[paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					 msgFont, NSFontAttributeName,
					 textColor, NSForegroundColorAttributeName,
					 paraStyle, NSParagraphStyleAttributeName,
					 nil];
	[paraStyle release];
	
	NSSize msgSize = [text sizeWithAttributes:msgAttrs];
	NSRect msgRect = NSMakeRect(0, 0, msgSize.width, msgSize.height);
	msgRect.origin.x = ([self frame].size.width - msgSize.width) / 2.0;
	msgRect.origin.y = ([self frame].size.height - msgSize.height) / 2.0;
	
	[text drawInRect:msgRect withAttributes:msgAttrs];
	
}

- (id) initWithFrame:(NSRect)frame
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	return self;
}

- (void) dealloc
{
	[super dealloc];
}


@end
