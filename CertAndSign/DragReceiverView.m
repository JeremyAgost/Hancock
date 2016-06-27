//
//  DragReceiverView.m
//  CertAndSign
//
//  Created by Jeremy Agostino on 6/27/16.
//  Copyright © 2016 GroundControl. All rights reserved.
//

#import "DragReceiverView.h"
#import "ViewController.h"

@implementation DragReceiverView

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
	return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
	return NSDragOperationCopy;
}

- (void)awakeFromNib
{
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
	
	if (1 == filenames.count) {
		id vc = NSApp.mainWindow.contentViewController;
		if ([vc isKindOfClass:[ViewController class]]) {
			[vc handleDraggedFilename:filenames[0]];
		}
	}
	
	return NO;
}

@end
