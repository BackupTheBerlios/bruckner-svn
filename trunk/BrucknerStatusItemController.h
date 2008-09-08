//
//  BrucknerStatusItemController.h
//  Bruckner
//
//  Created by Johannes on 06.09.08.
//  Copyright 2008 Johannes Tanzler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MAAttachedWindow;
@class BrucknerView;
@class BrucknerStatusItemView;

@interface BrucknerStatusItemController : NSObject {
	IBOutlet MAAttachedWindow *attachedWindow;
	IBOutlet BrucknerView *statusItemBrucknerView;
	
	NSStatusItem *statusItem;
	BrucknerStatusItemView *statusItemView;

}

@end
