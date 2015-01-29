//
//  AppDelegate.h
//  OSX Streamer
//
//  Created by Marc Davis on 1/28/15.
//  Copyright (c) 2015 Marc Davis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "Sendificator.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) Sendificator *dataConnection;

@end

