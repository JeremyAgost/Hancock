//
//  ViewController.m
//  CertAndSign
//
//  Created by Jeremy Agostino on 6/27/16.
//  Copyright © 2016 GroundControl. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>

void _IdentApplier(CFDictionaryRef value, void *context)
{
	ViewController * controller = (__bridge id)context;
	auto attributes = (__bridge NSDictionary *)value;
	
	NSString * label = attributes[(__bridge NSString *)kSecAttrLabel];
	if (label.length > 0) {
		[controller.popup addItemWithTitle:label];
	}
}

@implementation ViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	[self.view registerForDraggedTypes:@[(__bridge id)kUTTypeFileURL]];
	
	[self validateButtons];

	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		
		SecKeychainSetUserInteractionAllowed(true);
		
		// Ask for basically all identities in the keychain
		auto query = @{
					   (__bridge NSString *)kSecClass:(__bridge NSString *)kSecClassIdentity,
					   (__bridge NSString *)kSecReturnAttributes: @(YES),
					   (__bridge NSString *)kSecMatchLimit: @(255),
					   };
		
		OSStatus oserr;
		CFArrayRef identsCF = NULL;
		oserr = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&identsCF);
		
		if (oserr != 0) {
			// TODO handle error
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[self.popup removeAllItems];
			
			CFArrayApplyFunction(identsCF, CFRangeMake(0, CFArrayGetCount(identsCF)),
								 (CFArrayApplierFunction)_IdentApplier, (__bridge void*)self);
			CFRelease(identsCF);
			
			[self validateButtons];
		});
	});
}

- (void)setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	
	[self validateButtons];
}

- (void)validateButtons
{
	self.popup.enabled = self.popup.numberOfItems > 0;
	self.signButton.enabled = self.popup.enabled && self.chosenFileURL != nil;
	
	auto filename = self.chosenFileURL.lastPathComponent;
	self.chooseButton.title = filename.length > 0 ? filename : @"Choose File...";
	
	self.signButton.title = @"Sign!";
}

- (IBAction)actionChooseFile:(id)sender
{
	auto openPanel = [NSOpenPanel new];
	openPanel.canChooseFiles = YES;
	openPanel.canChooseDirectories = NO;
	openPanel.canCreateDirectories = NO;
	openPanel.allowsMultipleSelection = NO;
	openPanel.title = @"Choose a file to sign";
	auto result = [openPanel runModal];
	
	if (result == NSFileHandlingPanelOKButton) {
		self.chosenFileURL = openPanel.URL;
	}
	
	[self validateButtons];
}

- (IBAction)actionSignFile:(id)sender
{
	auto signFileURL = self.chosenFileURL;
	auto chosenIdentityLabel = self.popup.titleOfSelectedItem;
	
	if (signFileURL != nil && chosenIdentityLabel.length > 0) {
		
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			
			NSData * data = [NSData dataWithContentsOfURL:signFileURL];
			if (data.length == 0) {
				// TODO handle error
				return;
			}
			
			// Ask for basically identity matching our label
			auto query = @{
						   (__bridge NSString *)kSecClass:(__bridge NSString *)kSecClassIdentity,
						   (__bridge NSString *)kSecReturnRef: @(YES),
						   (__bridge NSString *)kSecMatchLimit: @(1),
						   (__bridge NSString *)kSecAttrLabel: chosenIdentityLabel,
						   };
			
			OSStatus oserr;
			SecIdentityRef ident = NULL;
			oserr = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&ident);
			
			if (oserr != 0) {
				// TODO handle error
				return;
			}
			
			CFDataRef outDataCF = NULL;
			oserr = CMSEncodeContent(ident, NULL, NULL, false, kCMSAttrNone,
									 data.bytes, data.length, &outDataCF);
			
			CFRelease(ident);
			
			if (oserr != 0) {
				// TODO handle error
				return;
			}
			
			NSData * outData = CFBridgingRelease(outDataCF);
			auto originalFilename = signFileURL.lastPathComponent;
			
			auto basename = [originalFilename stringByDeletingPathExtension];
			auto newFilename = [NSString stringWithFormat:@"%@-Signed.%@", basename, originalFilename.pathExtension];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				
				auto savePanel = [NSSavePanel new];
				savePanel.canCreateDirectories = YES;
				savePanel.nameFieldStringValue = newFilename;
				savePanel.title = @"Choose where to save signed data";
				[savePanel runModal];
				
				auto saveURL = savePanel.URL;
				[outData writeToURL:saveURL atomically:YES];
			});
		});
	}
}

- (void)handleDraggedFilename:(NSString *)filename
{
	self.chosenFileURL = [NSURL fileURLWithPath:filename];
	[self actionSignFile:self];
}

@end
