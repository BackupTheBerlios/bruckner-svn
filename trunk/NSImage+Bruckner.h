//
//  NSImage+Bruckner.h
//  Bruckner
//
//  Created by Johannes on 29.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ETTrack;

#define BRUCKNER_ALBUMART_SIZE 120

@interface NSImage (Bruckner)

- (CGImageRef) cgImage;
+ (NSImage *) albumArtImageForTrack:(ETTrack *)track;


@end
