//
//  AlbumArtView.h
//  Bruckner
//
//  Created by Johannes on 27.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BrucknerView;

@interface BrucknerAlbumArtView : NSView {
	CGImageRef cgImage;
	CALayer *imageLayer;
	IBOutlet BrucknerView *brucknerView;
}

- (void) displayImage:(NSImage *)image;

@end
