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
	return [self allowedDraggingOperationForSender:sender];
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
	return [self allowedDraggingOperationForSender:sender];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
	if ([self allowedDraggingOperationForSender:sender] == NSDragOperationNone) {
		return NO;
	}
	
	NSArray * filenames = [sender.draggingPasteboard propertyListForType:NSFilenamesPboardType];
	
	id vc = [self mainViewController];
	for (NSString * filename in filenames) {
		[vc handleDraggedFilename:filename];
	}
	
	return YES;
}

- (NSDragOperation)allowedDraggingOperationForSender:(id<NSDraggingInfo>)sender
{
	if ([sender.draggingPasteboard.types containsObject:NSFilenamesPboardType] ) {
		if (sender.draggingSourceOperationMask & NSDragOperationCopy) {
			return NSDragOperationCopy;
		}
	}
	
	return NSDragOperationNone;
}

- (ViewController *)mainViewController
{
	for (NSWindow * window in NSApp.orderedWindows) {
		id vc = window.contentViewController;
		if ([vc isKindOfClass:[ViewController class]]) {
			return vc;
		}
	}
	return nil;
}

- (void)awakeFromNib
{
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

@end
