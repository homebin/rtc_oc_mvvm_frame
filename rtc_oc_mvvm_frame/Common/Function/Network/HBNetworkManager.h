//
//  HBNetworkManager.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HBNetworkCode) {
    HBNetworkCode_Unknown = 0,
    HBNetworkCode_ChinaMobile,
    HBNetworkCode_ChinaUnion,
    HBNetworkCode_ChinaTelecon,
    HBNetworkCode_ChinaTietong
};

typedef NS_ENUM(NSUInteger, HBNetworkAccessTechValue) {
    HBNetworkAccess_TechUnknown = 0,
    HBNetworkAccess_TechGPRS,
    HBNetworkAccess_TechEdge,
    HBNetworkAccess_TechWCDMA,
    HBNetworkAccess_TechHSDPA,
    HBNetworkAccess_TechHSUPA,
    HBNetworkAccess_TechCDMA1x,
    HBNetworkAccess_TechCDMAEVDORev0,
    HBNetworkAccess_TechCDMAEVDORevA,
    HBNetworkAccess_TechCDMAEVDORevB,
    HBNetworkAccess_TechHRPD,
    HBNetworkAccess_TechLTE
};

@interface HBNetworkNotify : NSObject

AS_NOTIFICATION(HBNetworkStatus_Changed);

@end

@interface HBNetworkManager : NSObject

@property (nonatomic, assign) HBNetStatus networkStatus;

@property (nonatomic, readonly) BOOL isWiFi; /**< 是否WiFi连接 */
@property (nonatomic, readonly) BOOL isWWAN; /**< 是否3G/4G/GPRS连接 */

@property (nonatomic, readonly) BOOL is2G;
@property (nonatomic, readonly) BOOL is3G;
@property (nonatomic, readonly) BOOL is4G;

- (NSString *)networkInfoDescription;
- (NSString*)netWorkStatusString;           /** wifi 类型： None/WWAN/Wifi */
- (HBNetworkCode)networkCode;               /** 网络类型 */
- (NSString *)networkCodeString;            /** 网络类型（汉字）：中国移动/中国联通/中国电信/中国铁通 */
- (HBNetworkAccessTechValue)networkAccessTechValue;
- (NSString *)networkAccessTechValueString;

@end



NS_ASSUME_NONNULL_END




