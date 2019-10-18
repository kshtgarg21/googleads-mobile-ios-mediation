//
//  GADMAdapterNexage.m
//
// @copyright Copyright (c) 2018 Verizon. All rights reserved.
//

#import "GADMAdapterNexage.h"
#import "GADMVerizonMediaConstants.h"
#import "GADMVerizonConsent_Internal.h"
#import <GoogleMobileAds/GADRequest.h>
#import <VerizonAdsCore/VASPEXRegistry.h>
#import <VerizonAdsCore/VASAds+Private.h>
#import <VerizonAdsURIExperience/VerizonAdsURIExperience.h>

@implementation GADMAdapterNexage

- (id)initWithGADMAdNetworkConnector:(id<GADMAdNetworkConnector>)gadConnector
{
    if (self = [super initWithGADMAdNetworkConnector:gadConnector]) {
        [self initializeVASAds];
    }
    
    return self;
}

- (instancetype)initWithRewardBasedVideoAdNetworkConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)rewardConnector
{
    if (self = [super initWithRewardBasedVideoAdNetworkConnector:rewardConnector]) {
        [self initializeVASAds];
    }
    return self;
}

- (void)initializeVASAds
{
    //Position
    NSDictionary *credentials = [self.connector credentials];
    if(credentials[kGADNexagePosition] != nil)
    {
        self.placementID = credentials[kGADNexagePosition];
    }
    
    //Site ID
    NSString *siteId = credentials[kGADNexageDCN];
    if (siteId.length == 0) {
        siteId = [[NSBundle mainBundle] objectForInfoDictionaryKey:kGADVerizonSiteId];
    }
    
    if([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        VASAds.logLevel = VASLogLevelError;
        
        if([VASAds sharedInstance].initialized == NO) {
            [VASStandardEdition initializeWithSiteId:siteId];
        }
        self.vasAds = [VASAds sharedInstance];
        [GADMVerizonConsent.sharedInstance updateConsentInfo];
    }
}

@end
