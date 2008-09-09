//
//  BrucknerITunesEvents.h
//  Bruckner
//
//  Created by Johannes on 24.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#pragma mark Notifications
extern NSString * const BrucknerITunesTerminatedNotification;
extern NSString * const BrucknerITunesLaunchedNotification;

extern NSString * const BrucknerPlayingNewSongNotification; // posted when UI update is needed
extern NSString * const BrucknerPlayPauseNotification;
extern NSString * const BrucknerPlayingNotification;
extern NSString * const BrucknerPausedNotification;
extern NSString * const BrucknerStoppedNotification;
extern NSString * const BrucknerNextTrackNotification;
extern NSString * const BrucknerPrevTrackNotification;

extern NSString * const BrucknerShuffledNotification;
extern NSString * const BrucknerRepeatModeNotification;