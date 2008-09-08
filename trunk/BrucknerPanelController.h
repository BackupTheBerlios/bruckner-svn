//
//  BrucknerPanelController.h
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ITunesController;

@interface BrucknerPanelController : NSObject {
	IBOutlet ITunesController *iTunesController;
	IBOutlet NSPanel *brucknerPanel;
	
	IBOutlet NSTextField *trackField;
	IBOutlet NSTextField *albumField;
	IBOutlet NSTextField *artistField;
	IBOutlet NSTextField *playlistField;
	IBOutlet NSImageView *albumArtView;
	IBOutlet NSLevelIndicator *ratingIndicator;
	IBOutlet NSTextField *timePlayedField;
	IBOutlet NSTextField *timeRemainingField;
	
	IBOutlet NSPopUpButton *albumPopup;
	IBOutlet NSPopUpButton *playlistPopup;
	
	IBOutlet NSLevelIndicator *timeIndicator;
	int timePlayed;
	int timeRemaining;
	NSTimer *timer;
}
@property (readwrite) int timePlayed;

- (IBAction) changeTrackPosition:(id)sender;

@end