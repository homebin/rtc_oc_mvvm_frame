//
//  HBHttpClient.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBHttpClient.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

typedef NS_ENUM(NSUInteger, HBHttpRequestType) {
    HBRequestType_Get        = 1,
    HBRequestType_Post       = 2
};

static AFHTTPSessionManager *_sessionManager                                = nil;
static NSMutableArray *_requestTasks                                        = nil;
static NSDictionary *_httpHeaders                                           = nil;
static NSString *_baseUrl                                                   = nil;
static HBRequestType _requestType                                           = HBRequestType_PlainText;
static HBResponseType _responseType                                         = HBResponseType_JSON;
static NSTimeInterval _timeOut                                              = 15;

@implementation HBHttpClient

#pragma mark -- Public
+ (NSString *)baseUrl
{
    return _baseUrl;
}

+ (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout
{
    _timeOut = timeout;
    if(_sessionManager)
    {
        _sessionManager.requestSerializer.timeoutInterval = timeout;
    }
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders
{
    _httpHeaders = httpHeaders;
    if(_sessionManager)
    {
        for (NSString *key in httpHeaders.allKeys)
        {
            if (httpHeaders[key] != nil)
            {
                [_sessionManager.requestSerializer setValue:httpHeaders[key] forHTTPHeaderField:key];
            }
        }
    }
}

#pragma mark -- Task
+ (void)cancelAllRequest
{
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HBURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            if ([task isKindOfClass:[HBURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url
{
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        @weakify(self)
        [[self allTasks] enumerateObjectsUsingBlock:^(HBURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            @strongify(self)
            if ([task isKindOfClass:[HBURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url])
            {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

#pragma mark -- Get
+ (nullable HBURLSessionTask *)getWithUrl:(NSString *)url
                                  success:(HBSuccessBlock _Nullable)success
                                     fail:(HBFailureBlock _Nullable)fail
{
    return [self getWithUrl:url params:nil progress:nil success:success fail:fail];
}

+ (nullable HBURLSessionTask *)getWithUrl:(NSString *)url
                                   params:(NSDictionary * _Nullable)params
                                  success:(HBSuccessBlock _Nullable)success
                                     fail:(HBFailureBlock _Nullable)fail
{
    return [self getWithUrl:url params:params progress:NULL success:success fail:fail];
}

+ (nullable HBURLSessionTask *)getWithUrl:(NSString *)url
                                   params:(NSDictionary * _Nullable)params
                                 progress:(HBGetProgress _Nullable)progress
                                  success:(HBSuccessBlock _Nullable)success
                                     fail:(HBFailureBlock _Nullable)fail
{
    return [self requestWithUrl:url
                httpRequestType:HBRequestType_Get
                         params:params
                       progress:progress
                        success:success
                           fail:fail];
}

#pragma mark -- Post
+ (nullable HBURLSessionTask *)postWithUrl:(NSString *)url
                                    params:(NSDictionary *)params
                                   success:(HBSuccessBlock _Nullable)success
                                      fail:(HBFailureBlock _Nullable)fail
{
    return [self postWithUrl:url params:params progress:nil success:success fail:fail];
}

+ (nullable HBURLSessionTask *)postWithUrl:(NSString *)url
                                    params:(NSDictionary *)params
                                  progress:(HBPostProgress _Nullable)progress
                                   success:(HBSuccessBlock _Nullable)success
                                      fail:(HBFailureBlock _Nullable)fail
{
    return [self requestWithUrl:url
                httpRequestType:HBRequestType_Post
                         params:params
                       progress:progress
                        success:success
                           fail:fail];
}

#pragma mark -- Upload
+ (nullable HBURLSessionTask *)uploadWithImage:(UIImage *)image
                                           url:(NSString *)url
                                      fileName:(NSString * _Nullable )fileName
                                          name:(NSString *)name
                                      mimeType:(NSString *)mimeType
                                    parameters:(NSDictionary * _Nullable)parameters
                                      progress:(HBUploadProgress _Nullable)progress
                                       success:(HBSuccessBlock _Nullable)success
                                          fail:(HBFailureBlock _Nullable)fail
{
    NSString *uploadStr = [self baseUrl];
    
    if(uploadStr)
    {
        uploadStr = [uploadStr stringByAppendingString:url];
    }
    else
    {
        uploadStr = url;
    }
    
    NSURL *uploadURL = [NSURL URLWithString:uploadStr];
    
    if(!uploadURL)
    {
        ERROR(@"uploadURL无效，无法生成URL。如果URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    @weakify(self)
    HBURLSessionTask *session = [manager POST:uploadStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        {
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            NSString *imageFileName = fileName;
            if (fileName == nil || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
            }
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        {
            if(progress != nil && uploadProgress != nil)
            {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        {
            @strongify(self)
            task != nil ? [[self allTasks] removeObject:task] : NULL;
            [self successResponse:responseObject callback:success];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        {
            @strongify(self)
            task != nil ? [[self allTasks] removeObject:task] : NULL;
            [self handleCallbackWithError:error fail:fail];
        }
    }];
    
    if (session) {
        [session resume];
        [[self allTasks] addObject:session];
    }
    return session;
}

+ (nullable HBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                                   uploadingFile:(NSString *)uploadingFile
                                        progress:(HBUploadProgress _Nullable)progress
                                         success:(HBSuccessBlock _Nullable)success
                                            fail:(HBFailureBlock _Nullable)fail
{
    NSString *uploadStr = [self baseUrl];
    
    if(uploadStr)
    {
        uploadStr = [uploadStr stringByAppendingString:url];
    }
    else
    {
        uploadStr = url;
    }
    
    NSURL *uploadURL = [NSURL URLWithString:uploadStr];
    
    if(!uploadURL)
    {
        ERROR(@"uploadURL无效，无法生成URL。如果URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    @weakify(self)
    HBURLSessionTask *session = [manager uploadTaskWithRequest:[NSURLRequest requestWithURL:uploadURL] fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        {
            if(progress != nil && uploadProgress != nil)
            {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        {
            @strongify(self)
            session != nil ? [[self allTasks] removeObject:session] : NULL;
            error != nil ? [self handleCallbackWithError:error fail:fail] : [self successResponse:responseObject callback:success];
        }
    }];
    
    if (session) {
        [session resume];
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark -- Download
+ (nullable HBURLSessionTask *)downloadWithUrl:(NSString *)url
                                    saveToPath:(NSString *)saveToPath
                                      progress:(HBDownloadProgress _Nullable)progress
                                       success:(HBSuccessBlock _Nullable)success
                                       failure:(HBFailureBlock _Nullable)failure
{
    NSString *downLoadStr = [self baseUrl];
    
    if(downLoadStr)
    {
        downLoadStr = [downLoadStr stringByAppendingString:url];
    }
    else
    {
        downLoadStr = url;
    }
    
    NSURL *downLoadURL = [NSURL URLWithString:downLoadStr];
    
    if(!downLoadURL)
    {
        ERROR(@"downLoadURL无效，无法生成URL。如果URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    @weakify(self)
    HBURLSessionTask *session = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:downLoadURL] progress:^(NSProgress * _Nonnull downloadProgress) {
        {
            if(progress != nil && downloadProgress != nil)
            {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        {
            return [NSURL fileURLWithPath:saveToPath];
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        {
            @strongify(self)
            [[self allTasks] removeObject:session];
            if (error == nil) {
                if (success) {
                    success(filePath.absoluteString);
                }
            } else {
                [self handleCallbackWithError:error fail:failure];
            }
        }
    }];
    
    if (session) {
        [session resume];
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark -- Private
+ (AFHTTPSessionManager *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sessionManager == nil)
        {
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            AFHTTPSessionManager *manager = nil;
            if ([self baseUrl] != nil)
            {
                manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
            }
            else
            {
                manager = [AFHTTPSessionManager manager];
            }
            
            switch (_requestType) {
                case HBRequestType_JSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case HBRequestType_PlainText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            switch (_responseType) {
                case HBResponseType_JSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case HBResponseType_XML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case HBResponseType_Data: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            for (NSString *key in _httpHeaders.allKeys) {
                if (_httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            manager.requestSerializer.timeoutInterval = _timeOut;
            
            // AFSSLPinningModeCertificate 使用证书验证模式
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            securityPolicy.allowInvalidCertificates = YES;
#if DEBUG
            securityPolicy.validatesDomainName = NO;
#endif
            manager.securityPolicy = securityPolicy;
            
            manager.operationQueue.maxConcurrentOperationCount = 3;
            
            _sessionManager = manager;
        }
    });
    return _sessionManager;
}

+ (nullable HBURLSessionTask *)requestWithUrl:(NSString *)url
                              httpRequestType:(HBHttpRequestType)httpRequestType
                                       params:(NSDictionary * _Nullable)params
                                     progress:(HBDownloadProgress _Nullable)progress
                                      success:(HBSuccessBlock _Nullable)success
                                         fail:(HBFailureBlock _Nullable)fail
{
    NSString *requestStr = [self baseUrl];
    
    if(requestStr)
    {
        requestStr = [requestStr stringByAppendingString:url];
    }
    else
    {
        requestStr = url;
    }
    
    NSURL *requestURL = [NSURL URLWithString:requestStr];
    
    if(!requestURL)
    {
        ERROR(@"downLoadURL无效，无法生成URL。如果URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    HBURLSessionTask *session = nil;
    if (httpRequestType == HBRequestType_Get)
    {
        session = [manager GET:requestStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            {
                (progress != nil && downloadProgress != nil) ? progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount) : NULL;
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            {
                task != nil ? [[self allTasks] removeObject:task] : NULL;
                [self successResponse:responseObject callback:success];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            {
                task != nil ? [[self allTasks] removeObject:task] : NULL;
                [self handleCallbackWithError:error fail:fail];
            }
        }];
    }
    else if (httpRequestType == HBRequestType_Post)
    {
        session = [manager POST:requestStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            {
                (progress != nil && downloadProgress != nil) ? progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount) : NULL;
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            {
                task != nil ? [[self allTasks] removeObject:task] : NULL;
                [self successResponse:responseObject callback:success];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            {
                task != nil ? [[self allTasks] removeObject:task] : NULL;
                [self handleCallbackWithError:error fail:fail];
            }
        }];
    }
    
    if (session)
    {
        [[self allTasks] addObject:session];
    }
    
    return session;
}


+ (NSMutableArray *)allTasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_requestTasks == nil)
        {
            _requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return _requestTasks;
}


+ (void)successResponse:(id _Nullable)responseData callback:(HBSuccessBlock)success
{
    success ? success([self tryToParseData:responseData]) : NULL;
}

+ (id)tryToParseData:(id _Nullable)responseData
{
    if ([responseData isKindOfClass:[NSData class]])
    {
        // 尝试解析成JSON
        if (responseData == nil)
        {
            return responseData;
        }
        else
        {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            return error != nil ? responseData : response;
        }
    }
    else
    {
        return responseData;
    }
}

+ (void)handleCallbackWithError:(NSError * _Nullable )error fail:(HBFailureBlock)fail
{
    fail ? fail(error) : NULL;
}

@end
