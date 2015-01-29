//
//  Preferences.m
//  OSX Streamer
//
//  Created by Marc Davis on 1/28/15.
//  Copyright (c) 2015 Marc Davis. All rights reserved.
//

#import "Preferences.h"

@interface Preferences ()

@end

@implementation Preferences

-(void)awakeFromNib {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud stringForKey:@"CID"];
    if (str == nil) {
        str = @"OSX-iOS";
        [ud setObject:str forKey:@"CID"];
        [ud synchronize];
    }
    [connectionName setStringValue:str];
    [quality selectItemAtIndex:[ud integerForKey:@"quality"]];
}
-(void)saveData:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:connectionName.stringValue forKey:@"CID"];
    [ud setInteger:quality.indexOfSelectedItem forKey:@"quality"];
    [ud synchronize];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Restart OSX Streamer"];
    [alert setInformativeText:@"The OSX Streamer app must be restarted for changes to take effect."];
    [alert runModal];
    exit(0);
}
@end
