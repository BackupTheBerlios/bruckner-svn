//
//  ETPlaylist.m
//  Bruckner
//
//  Created by Johannes on 09.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <EyeTunes/EyeTunes.h>
#import <EyeTunes/ETDebug.h>
#import "BrucknerITunesEvents.h"

@implementation ETPlaylist (Bruckner)

- (BOOL) isShuffled
{
	return (BOOL) [self getPropertyAsIntegerForDesc:ET_PLAYLIST_PROP_SHUFFLE];
}

- (void) setShuffled:(BOOL)shuffled
{
	BOOL old = [self isShuffled];
	if (shuffled != old) {
		[self setPropertyWithInteger:(int) shuffled
				     forDesc:ET_PLAYLIST_PROP_SHUFFLE];
		
		NSDictionary *d = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:shuffled]
							      forKey:@"BrucknerEyeTunesShuffled"];
		[[NSNotificationCenter defaultCenter] postNotificationName:BrucknerShuffledNotification
								    object:self
								  userInfo:d];
	}
}


- (BOOL) setPropertyWithEnum:(DescType)value 
		     forDesc:(DescType)descType
{
	OSErr err;
	AEDesc valueDesc;
	BOOL success;
	
	err = AEBuildDesc(&valueDesc, NULL, "enum(@)", value);
	if (err != noErr) {
		ETLog(@"Error constructing parameters for set command: %d", err);
		return NO;
	}
	
	success = [self setPropertyWithValue:&valueDesc ofType:descType];
	AEDisposeDesc(&valueDesc);
	return success;
}

@end
