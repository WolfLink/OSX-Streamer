//
//  Sendificator.m
//  test
//
//  Created by Marc Davis on 1/27/15.
//  Copyright (c) 2015 Marc Davis. All rights reserved.
//

#import "Sendificator.h"

@implementation Sendificator
-(id)init {
    self = [super init];
    if (self) {
        sendNext = true;
        _localID = [[MCPeerID alloc] initWithDisplayName:@"OSX Streamer"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString * str = [ud stringForKey:@"CID"];
        if (str == nil) {
            str = @"OSX-iOS";
        }
        
        NSUInteger count = 0, length = [str length];
        NSRange range = NSMakeRange(0, length);
        while(range.location != NSNotFound)
        {
            range = [str rangeOfString: @"cake" options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
            }
        }
        if (count > 2) {
            str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        if (str.length > 16) {
            str = [str substringToIndex:16];
        }
        
        NSLog(@"Starting service with service name: %@", str);
        _localSession = [[MCSession alloc] initWithPeer:_localID];
        _localSession.delegate = self;
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_localID discoveryInfo:nil serviceType:str];
        _advertiser.delegate = self;
        [_advertiser startAdvertisingPeer];
        NSLog(@"should be searching for peer");
    }
    return self;
}


-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    NSLog(@"Found peer");
    _partnerID = peerID;
    invitationHandler(true, _localSession);
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"State changed");
    if (state == MCSessionStateConnected) {
        //_outStr = [self startStreamingData];
        NSLog(@"connected...");
        [_advertiser stopAdvertisingPeer];
    }
    else if(state == MCSessionStateNotConnected){
        //_outStr = nil;
        NSLog(@"not connected.");
        [_advertiser startAdvertisingPeer];
    }
}

-(void)sendBuffer:(CMSampleBufferRef)buffer {
    if(_partnerID != nil){
        [_localSession sendData:[self dataForImageBuffer:buffer] toPeers:_localSession.connectedPeers withMode:MCSessionSendDataReliable error:nil];
    }
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    sendNext = true;
}
-(NSData *)dataForImageBufferV2:(CMSampleBufferRef)buf{
    CVImageBufferRef img = CMSampleBufferGetImageBuffer(buf);
    CVPixelBufferLockBaseAddress(img, 0);
    void * pt = CVPixelBufferGetBaseAddress(img);
    NSData *returnData = [NSData dataWithBytes:pt length:CVPixelBufferGetDataSize(img)];
    NSLog(@"%zu\n%zu\n%zu\n\n", CVPixelBufferGetWidth(img), CVPixelBufferGetHeight(img), CVPixelBufferGetBytesPerRow(img));
    CVPixelBufferUnlockBaseAddress(img, 0);
    return returnData;
    //return [NSData dataWithBytes:rawData length:CMBlockBufferGetDataLength(dataToSend)];
}
-(NSData *)dataForImageBuffer:(CMSampleBufferRef)buf {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(buf);
    CIImage *img = [CIImage imageWithCVImageBuffer:imageBuffer];
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithCIImage:img];
    NSData* dat = [rep representationUsingType:NSJPEGFileType properties:nil];
    return dat;
}
-(NSOutputStream *)startStreamingData {
    return [_localSession startStreamWithName:@"vidStr" toPeer:_partnerID error:nil];
}



// Create a UIImage from sample buffer data
- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return (quartzImage);
}

@end
