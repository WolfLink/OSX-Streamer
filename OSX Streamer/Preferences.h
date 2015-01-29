//
//  Preferences.h
//  OSX Streamer
//
//  Created by Marc Davis on 1/28/15.
//  Copyright (c) 2015 Marc Davis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Preferences : NSView{
    IBOutlet NSTextField *connectionName;
    IBOutlet NSComboBox *quality;
}
-(IBAction)saveData:(id)sender;
@end
