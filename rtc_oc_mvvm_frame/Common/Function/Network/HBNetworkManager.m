//
//  HBNetworkManager.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBNetworkManager.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation HBNetworkNotify

DEF_NOTIFICATION(HBNetworkStatus_Changed);

@end

@interface HBNetworkManager()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

@end

@implementation HBNetworkManager

#pragma mark -- LifeCycle
- (id)init
{
    self = [super init];
    if(self)
    {
        self.reachability = [AFNetworkReachabilityManager sharedManager];
        [self.reachability startMonitoring];
        @weakify(self);
        [self.reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            INFO(@"** HBNetworkManager network status [%@] **", @(status));
            
            @strongify(self);
            if (status == AFNetworkReachabilityStatusNotReachable)
            {
                self.networkStatus = HBNetStatus_None;
            }
            else if (status == AFNetworkReachabilityStatusReachableViaWiFi)
            {
                self.networkStatus = HBNetStatus_Wifi;
            }
            else
            {
                self.networkStatus = HBNetStatus_WWan;
            }
            
            NSDictionary *msgObject = @{@"HBNetStatus" : @(self.networkStatus)};
            [self postNotification:HBNetworkNotify.HBNetworkStatus_Changed withObject:msgObject];
        }];
    }
    return self;
}

- (void)dealloc
{
    [self.reachability stopMonitoring];
}

#pragma mark -- public
- (BOOL)isWiFi
{
    return HBNetStatus_Wifi == self.networkStatus;
}

- (BOOL)isWWAN
{
    return HBNetStatus_WWan == self.networkStatus;
}

- (BOOL)is2G
{
    HBNetworkAccessTechValue value = [self networkAccessTechValue];
    return value == HBNetworkAccess_TechEdge || value == HBNetworkAccess_TechGPRS;
}

- (BOOL)is3G
{
    HBNetworkAccessTechValue value = [self networkAccessTechValue];
    return (value != HBNetworkAccess_TechUnknown)
        && (value != HBNetworkAccess_TechLTE)
        && (value != HBNetworkAccess_TechGPRS)
        && (value != HBNetworkAccess_TechEdge);
}

- (BOOL)is4G
{
    HBNetworkAccessTechValue value = [self networkAccessTechValue];
    return value == HBNetworkAccess_TechLTE;
}


- (NSString *)networkInfoDescription
{
    NSString *resultVal = @"";
    
    HBNetStatus status = [self networkStatus];
    if (status == HBNetStatus_Wifi)
    {
        resultVal = @"Wifi";
    }
    else if (status == HBNetStatus_WWan)
    {
        resultVal = self.networkCodeString;
        if ([self is2G])
        {
            resultVal = [NSString stringWithFormat:@"%@: 2G", resultVal];
        }
        else if ([self is4G])
        {
            resultVal = [NSString stringWithFormat:@"%@: 4G", resultVal];
        }
        else
        {
            resultVal = [NSString stringWithFormat:@"%@: 3G", resultVal];
        }
    }
    else{
        resultVal = @"No Network!";
    }
    return resultVal;
}

- (NSString *)netWorkStatusString
{
    switch (self.networkStatus)
    {
        case HBNetStatus_None:
            return @"HBNetworkStatus_NotReachable";
        case HBNetStatus_Wifi:
            return @"HBNetworkStatus_ReachableViaWiFi";
        case HBNetStatus_WWan:
            return @"HBNetworkStatus_ReachableViaWWAN";
        default:
            break;
    }
}

// 参考 : https://en.wikipedia.org/wiki/Mobile_country_code
- (HBNetworkCode)networkCode
{
    if (self.networkStatus != HBNetStatus_WWan)
    {
        return HBNetworkCode_Unknown;
    }
    
    CTTelephonyNetworkInfo* info = [CTTelephonyNetworkInfo new];
    CTCarrier* carrier = [info subscriberCellularProvider];
    
    //todo:hjm
    //NSString *networkStatus = [info currentRadioAccessTechnology];
    
    if (carrier == nil) {
        return HBNetworkCode_Unknown;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"])
    {
        return HBNetworkCode_ChinaMobile;
    }
    else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"])
    {
        return HBNetworkCode_ChinaUnion;
    }
    else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"])
    {
        return HBNetworkCode_ChinaTelecon;
    }
    else if ([code isEqualToString:@"20"])
    {
        return HBNetworkCode_ChinaTietong;
    }
    else
    {
        return HBNetworkCode_Unknown;
    }
}

- (NSString *)networkCodeString
{
    HBNetworkCode code = [self networkCode];
    NSString *codeString = @"";
    
    switch (code)
    {
        case HBNetworkCode_ChinaMobile:
            codeString = @"中国移动";
            break;
        case HBNetworkCode_ChinaUnion:
            codeString = @"中国联通";
            break;
        case HBNetworkCode_ChinaTelecon:
            codeString = @"中国电信";
            break;
        case HBNetworkCode_ChinaTietong:
            codeString = @"中国铁通";
            break;
        default:
            break;
    }
    
    return codeString;
}

- (HBNetworkAccessTechValue)networkAccessTechValue
{
    //todo:hjm
    if (self.networkStatus != HBNetStatus_WWan)
    {
        return HBNetworkAccess_TechUnknown;
    }
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *networkAccessTechValue = [networkInfo currentRadioAccessTechnology];
    
    if (!networkAccessTechValue)
    {
        return HBNetworkAccess_TechUnknown;
    }
    
    //按照占有率从高到低
    if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyLTE]){
        return HBNetworkAccess_TechLTE;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyWCDMA]){
        return HBNetworkAccess_TechWCDMA;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyEdge]){
        return HBNetworkAccess_TechEdge;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyGPRS]){
        return HBNetworkAccess_TechGPRS;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyHSDPA]){
        return HBNetworkAccess_TechHSDPA;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyHSUPA]){
        return HBNetworkAccess_TechHSUPA;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        return HBNetworkAccess_TechCDMA1x;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        return HBNetworkAccess_TechCDMAEVDORev0;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        return HBNetworkAccess_TechCDMAEVDORevA;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        return HBNetworkAccess_TechCDMAEVDORevB;
    }
    else if ([networkAccessTechValue isEqualToString:CTRadioAccessTechnologyeHRPD]){
        return HBNetworkAccess_TechHRPD;
    }
    else{
        return HBNetworkAccess_TechUnknown;
    }
}

- (NSString *)networkAccessTechValueString
{
    HBNetworkAccessTechValue value = [self networkAccessTechValue];
    NSString *valueString = @"";
    
    switch (value)
    {
        case HBNetworkAccess_TechGPRS:
            valueString = @"GPRS";
            break;
        case HBNetworkAccess_TechEdge:
            valueString = @"Edge";
            break;
        case HBNetworkAccess_TechWCDMA:
            valueString = @"WCDMA";
            break;
        case HBNetworkAccess_TechHSDPA:
            valueString = @"HSDPA";
            break;
        case HBNetworkAccess_TechHSUPA:
            valueString = @"HSUPA";
            break;
        case HBNetworkAccess_TechCDMA1x:
            valueString = @"CDMA1x";
            break;
        case HBNetworkAccess_TechCDMAEVDORev0:
            valueString = @"CDMAEVDORev0";
            break;
        case HBNetworkAccess_TechCDMAEVDORevA:
            valueString = @"CDMAEVDORevA";
            break;
        case HBNetworkAccess_TechCDMAEVDORevB:
            valueString = @"CDMAEVDORevB";
            break;
        case HBNetworkAccess_TechHRPD:
            valueString = @"HRPD";
            break;
        case HBNetworkAccess_TechLTE:
            valueString = @"LTE";
            break;
        default:
            break;
    }
    return valueString;
}

@end

