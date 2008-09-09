//
//  ETPlaylist.h
//  Bruckner
//
//  Created by Johannes on 09.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <EyeTunes/EyeTunes.h>

@interface ETPlaylist (Bruckner)

- (BOOL) setPropertyWithEnum:(DescType)value forDesc:(DescType)descType;
- (void) setShuffled:(BOOL)shuffled;
- (BOOL) isShuffled;
@end
