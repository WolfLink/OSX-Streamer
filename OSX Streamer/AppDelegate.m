//
//  AppDelegate.m
//  OSX Streamer
//
//  Created by Marc Davis on 1/28/15.
//  Copyright (c) 2015 Marc Davis. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *preset;
    switch ([ud integerForKey:@"quality"]) {
        case 0:
            preset = AVCaptureSessionPresetLow;
            break;
        case 1:
            preset = AVCaptureSessionPresetMedium;
            break;
        case 2:
            preset = AVCaptureSessionPresetHigh;
            break;
        case 3:
            preset = AVCaptureSessionPreset1280x720;
            break;
        case 4:
            preset = AVCaptureSessionPreset960x540;
            break;
        default:
            preset = AVCaptureSessionPresetMedium;
            break;
    }
    
    
    _dataConnection = [[Sendificator alloc] init];
    
    AVCaptureScreenInput * screen = [[AVCaptureScreenInput alloc] initWithDisplayID:kCGDirectMainDisplay];
    screen.capturesCursor = false;
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = preset;
    [_session addInput:screen];
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    output.alwaysDiscardsLateVideoFrames = true;
    //[output setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelF] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.marcdavis.iOS-Streaming-queue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    [_session addOutput:output];
    [_session startRunning];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    //CMBlockBufferRef ref = CMSampleBufferGetDataBuffer(sampleBuffer);
    //[_dataConnection.outStr write: maxLength:1000000];
    [_dataConnection sendBuffer:sampleBuffer];
    //NSLog(@"%@", sampleBuffer);
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
