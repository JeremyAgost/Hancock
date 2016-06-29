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
@property (nonatomic, weak) IBOutlet NSButton * unsignButton;
@property (nonatomic, weak) IBOutlet NSButton * signButton;
@property (nonatomic, weak) IBOutlet NSProgressIndicator * spinner;

@property (nonatomic, strong) NSMutableArray * loadedIdentities;
@property (nonatomic, readwrite) NSInteger spinCount;

- (void)handleDraggedFilename:(NSString *)filename;

@end

