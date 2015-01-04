//
//  NetworkRequest.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/9.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^requestDidFinished)(BOOL success,NSData *response);

@interface NetworkRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) NSURLConnection *requestConnection;

@property (nonatomic, strong) NSMutableData *requestData;

@property (nonatomic, strong) requestDidFinished finishBlock;

- (id)initWithRequestURL:(NSString *)urlString finished:(requestDidFinished)finish;

- (void)setPostBody:(NSData *)postData;

- (void)start;

@end
