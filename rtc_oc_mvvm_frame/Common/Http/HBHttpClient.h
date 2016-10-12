//
//  HBHttpClient.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HBDownloadProgress)(int64_t bytesRead, int64_t totalBytesRead);
typedef void (^HBUploadProgress)(int64_t bytesWritten, int64_t totalBytesWritten);

typedef HBDownloadProgress HBGetProgress;
typedef HBDownloadProgress HBPostProgress;

@class NSURLSessionTask;
typedef NSURLSessionTask HBURLSessionTask;

typedef NS_ENUM(NSUInteger, HBResponseType) {
    HBResponseType_JSON     = 1,
    HBResponseType_XML      = 2,
    HBResponseType_Data     = 3
};

typedef NS_ENUM(NSUInteger, HBRequestType) {
    HBRequestType_JSON       = 1,
    HBRequestType_PlainText  = 2
};

@interface HBHttpClient : NSObject

+ (void)setBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

+ (void)setTimeout:(NSTimeInterval)timeout;
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

#pragma mark -- Get
+ (nullable HBURLSessionTask *)getWithUrl:(NSString *)url
                                  success:(HBSuccessBlock _Nullable)success
                                     fail:(HBFailureBlock _Nullable)fail;

+ (nullable HBURLSessionTask *)getWithUrl:(NSString *)url
                                   params:(NSDictionary * _Nullable)params
                                  success:(HBSuccessBlock _Nullable)success
                                     fail:(HBFailureBlock _Nullable)fail;

+ (nullable HBURLSessionTask *)getWithUrl:(NSString *)url
                                   params:(NSDictionary * _Nullable)params
                                 progress:(HBGetProgress _Nullable)progress
                                  success:(HBSuccessBlock _Nullable)success
                                     fail:(HBFailureBlock _Nullable)fail;

#pragma mark -- Post
+ (nullable HBURLSessionTask *)postWithUrl:(NSString *)url
                                    params:(NSDictionary *)params
                                   success:(HBSuccessBlock _Nullable)success
                                      fail:(HBFailureBlock _Nullable)fail;

+ (nullable HBURLSessionTask *)postWithUrl:(NSString *)url
                                    params:(NSDictionary *)params
                                  progress:(HBPostProgress _Nullable)progress
                                   success:(HBSuccessBlock _Nullable)success
                                      fail:(HBFailureBlock _Nullable)fail;

#pragma mark -- Upload
+ (nullable HBURLSessionTask *)uploadWithImage:(UIImage *)image
                                           url:(NSString *)url
                                      fileName:(NSString * _Nullable )fileName
                                          name:(NSString *)name
                                      mimeType:(NSString *)mimeType
                                    parameters:(NSDictionary * _Nullable)parameters
                                      progress:(HBUploadProgress _Nullable)progress
                                       success:(HBSuccessBlock _Nullable)success
                                          fail:(HBFailureBlock _Nullable)fail;

+ (nullable HBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                                   uploadingFile:(NSString *)uploadingFile
                                        progress:(HBUploadProgress _Nullable)progress
                                         success:(HBSuccessBlock _Nullable)success
                                            fail:(HBFailureBlock _Nullable)fail;

+ (nullable HBURLSessionTask *)downloadWithUrl:(NSString *)url
                                    saveToPath:(NSString *)saveToPath
                                      progress:(HBDownloadProgress _Nullable)progress
                                       success:(HBSuccessBlock _Nullable)success
                                       failure:(HBFailureBlock _Nullable)failure;

#pragma mark -- Task
+ (void)cancelAllRequest;
+ (void)cancelRequestWithURL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
