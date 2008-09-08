//
//  NSImage+Bruckner.m
//  Bruckner
//
//  Created by Johannes on 29.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "NSImage+Bruckner.h"
#import <EyeTunes/EyeTunes.h>

@implementation NSImage (Bruckner)

// from http://developer.apple.com/technotes/tn2005/tn2143.html

CGImageRef CreateCGImageFromData(NSData* data)
{
	CGImageRef imageRef = NULL;
	CGImageSourceRef sourceRef;
	
	sourceRef = CGImageSourceCreateWithData ((CFDataRef)data, NULL);
	if (sourceRef) {
		imageRef = CGImageSourceCreateImageAtIndex (sourceRef, 0, NULL);
		CFRelease (sourceRef);
	}
	
	return imageRef;
}



- (CGImageRef) cgImage
{
	//NSSize size = NSMakeSize(150, 150);
	//[self setSize:size];
	NSData* data = [self TIFFRepresentation];
	return CreateCGImageFromData (data);
}

+ (NSImage *) albumArtImageForTrack:(ETTrack *)track
{
	NSImage *image = [NSImage imageNamed:@"Cover.png"];
	NSString *album, *artist;
	NSSize size;	
	NSMutableDictionary *attributes;
	
	album = [track album];
	if ([track compilation])
		artist = [track albumArtist];
	else
		artist = [track artist];
	
	
	attributes = [[NSMutableDictionary alloc] init];
	[attributes setObject:[NSColor blackColor]
		       forKey:NSForegroundColorAttributeName];
	[attributes setObject:[NSFont fontWithName:@"Chalkboard Bold" size:14.0]
		       forKey:NSFontAttributeName];
	
	[image lockFocus];
	
	size = [album sizeWithAttributes:attributes];
	[album drawAtPoint:NSMakePoint(150 / 2 - size.width / 2, 95)
	    withAttributes:attributes];
	
	
	[attributes setObject:[NSFont fontWithName:@"Chalkboard" size:12.0]
		       forKey:NSFontAttributeName];
	size = [artist sizeWithAttributes:attributes];
	[artist drawAtPoint:NSMakePoint(150 / 2 - size.width / 2, 50)
	     withAttributes:attributes];
	
	[image unlockFocus];
	
	[attributes release];
	return image;
}


@end
