//
//  BrucknerStatusItemView.h
//  Bruckner
//
//  Created by Johannes on 22.08.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppController;

@interface BrucknerStatusItemView : NSView {
	BOOL clicked;
}


#pragma mark Notifications
extern NSString * const BrucknerShowStatusItemWindowNotification;

@end
