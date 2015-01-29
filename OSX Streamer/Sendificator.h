//
//  Sendificator.h
//  test
//
//  Created by Marc Davis on 1/27/15.
//  Copyright (c) 2015 Marc Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import <AVFoundation/AVFoundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface Sendificator : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate> {
    bool sendNext;
}

@property (nonatomic) MCPeerID *localID;
@property (nonatomic) MCSession *localSession;
@property (nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic) MCPeerID *partnerID;
@property (nonatomic) NSOutputStream *outStr;

-(void)sendBuffer:(CMSampleBufferRef) buffer;

@end
