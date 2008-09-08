//
//  AppController.h
//  Bruckner
//
//  Created by Johannes on 22.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ITunesController;

@interface AppController : NSObject {
	IBOutlet ITunesController *iTunesController;
	IBOutlet NSWindow *brucknerPanel;
	IBOutlet NSWindow *brucknerDesktopWindow;
	
	IBOutlet NSMenuItem *currentSongMenuItem;
}

@property (readonly) NSWindow *brucknerPanel;

@end
