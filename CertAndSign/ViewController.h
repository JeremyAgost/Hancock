//
//  ViewController.h
//  CertAndSign
//
//  Created by Jeremy Agostino on 6/27/16.
//  Copyright © 2016 GroundControl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSPopUpButton * popup;
@property (nonatomic, weak) IBOutlet NSButton * chooseButton;
@property (nonatomic, weak) IBOutlet NSButton * signButton;

@property (nonatomic, strong) NSURL * chosenFileURL;

- (void)handleDraggedFilename:(NSString *)filename;

@end

