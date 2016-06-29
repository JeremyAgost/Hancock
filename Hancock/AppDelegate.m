//
//  AppDelegate.m
//  CertAndSign
//
//  Created by Jeremy Agostino on 6/27/16.
//  Copyright © 2016 GroundControl. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Security/Security.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	// We may need to ask the user for permission to sign
	SecKeychainSetUserInteractionAllowed(true);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
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

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
	[[self mainViewController] handleDraggedFilename:filename];
	return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames
{
	id vc = [self mainViewController];
	for (NSString * filename in filenames) {
		[vc handleDraggedFilename:filename];
	}
}

@end
