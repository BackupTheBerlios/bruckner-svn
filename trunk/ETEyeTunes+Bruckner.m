//
//  ETEyeTunes+Bruckner.m
//  Bruckner
//
//  Created by Johannes on 08.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import "ETEyeTunes+Bruckner.h"
#import <EyeTunes/EyeTunes.h>

@implementation EyeTunes (Bruckner)

- (void) setPlayerPosition:(int)newPosition
{
	if (![self setPropertyWithInteger:newPosition
				  forDesc:ET_APP_PLAYER_POSITION]) {
		;	// silently ignore any error
	}
}

@end
