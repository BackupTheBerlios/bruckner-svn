//
//  DesktopWindowController.h
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ITunesController;
@class BrucknerAlbumArtView;


@interface DesktopWindowController : NSObject {
	IBOutlet ITunesController *ITunesController;
	IBOutlet NSTextField *trackField;
	IBOutlet NSTextField *albumAndArtistField;
	IBOutlet BrucknerAlbumArtView *albumArtView;
}

@end
