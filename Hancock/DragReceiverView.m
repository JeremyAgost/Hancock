//
//  DragReceiverView.m
//  CertAndSign
//
//  Created by Jeremy Agostino on 6/27/16.
//  Copyright © 2016 GroundControl. All rights reserved.
//

#import "DragReceiverView.h"
#import "ViewController.h"
#import "AppDelegate.h"

@implementation DragReceiverView

/*
 * These methods indicate that we support the given drag operation type
 */

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
	return [self allowedDraggingOperationForSender:sender];
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
	return [self allowedDraggingOperationForSender:sender];
}

/*
 * This method receives the drag operation, with a file list
 */

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
	if ([self allowedDraggingOperationForSender:sender] == NSDragOperationNone) {
		return NO;
	}
	
	NSArray * filenames = [sender.draggingPasteboard propertyListForType:NSFilenamesPboardType];
	
	id vc = [(AppDelegate*)NSApp.delegate mainViewController];
	for (NSString * filename in filenames) {
		[vc handleDraggedFilename:filename];
	}
	
	return YES;
}

/*
 * Explicitly support only "Filenames" to be dragged in, with "Copy" behavior
 */

- (NSDragOperation)allowedDraggingOperationForSender:(id<NSDraggingInfo>)sender
{
	if ([sender.draggingPasteboard.types containsObject:NSFilenamesPboardType] ) {
		if (sender.draggingSourceOperationMask & NSDragOperationCopy) {
			return NSDragOperationCopy;
		}
	}
	
	return NSDragOperationNone;
}

/*
 * Register for drag and drop support
 */

- (void)awakeFromNib
{
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

@end
