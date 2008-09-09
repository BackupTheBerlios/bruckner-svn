//
//  ETPlaylist.m
//  Bruckner
//
//  Created by Johannes on 09.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <EyeTunes/EyeTunes.h>
#import <EyeTunes/ETDebug.h>

@implementation ETPlaylist (Bruckner)

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
