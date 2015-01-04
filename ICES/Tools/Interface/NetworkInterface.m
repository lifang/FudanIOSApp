//
//  NetworkInterface.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/9.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkInterface.h"
#import "EncryptHelper.h"

@implementation NetworkInterface

//请求post
+ (void)requestWithURL:(NSString *)urlString
                params:(NSMutableDictionary *)params
              finished:(requestDidFinished)finish {
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                                finished:finish];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    [request setPostBody:postData];
    [request start];
}

+ (void)registerWithActivation:(NSString *)activation
                  studentEmail:(NSString *)studentEmail
               studentPassword:(NSString *)studentPassword
                   mobilePhone:(NSString *)mobilePhone
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:activation forKey:@"activationCode"];
    [paramDict setObject:studentEmail forKey:@"studentEmail"];
    NSString *encryptPassword = [EncryptHelper MD5_encryptWithString:studentPassword];
    [paramDict setObject:encryptPassword forKey:@"studentPassword"];
    if (mobilePhone) {
        [paramDict setObject:mobilePhone forKey:@"studentMobilePhone"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_register_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)loginWithStudentEmail:(NSString *)email
              studentPassword:(NSString *)password
                  deviceToken:(NSString *)deviceToken
               alreadyEncrypt:(BOOL)encrypt
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:email forKey:@"studentEmail"];
    NSString *encryptPassword = password;
    if (!encrypt) {
        encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    }
    [paramDict setObject:encryptPassword forKey:@"studentPassword"];
    if (deviceToken) {
        [paramDict setObject:deviceToken forKey:@"deviceToken"];
    }
    [paramDict setObject:[NSNumber numberWithInt:4] forKey:@"pushDeviceType"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_login_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)loginOutWithStudentID:(NSString *)studentID
                        token:(NSString *)token
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_loginOut_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)modifyUserInfoWithStudentID:(NSString *)studentID
                              token:(NSString *)token
                        mobilePhone:(NSString *)mobilePhone
                       studentEmail:(NSString *)email
                     activationCode:(NSString *)activationCode
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"id"];
    [paramDict setObject:token forKey:@"token"];
    if (mobilePhone) {
        [paramDict setObject:mobilePhone forKey:@"studentMobilePhone"];
    }
    [paramDict setObject:email forKey:@"studentEmail"];
    [paramDict setObject:activationCode forKey:@"activationCode"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modify_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)modifyPasswordWithStudentID:(NSString *)studentID
                              token:(NSString *)token
                        oldPassword:(NSString *)oldPsd
                           password:(NSString *)newPsd
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"id"];
    [paramDict setObject:token forKey:@"token"];
    NSString *encryptOldPassword = [EncryptHelper MD5_encryptWithString:oldPsd];
    NSString *encryptPassword = [EncryptHelper MD5_encryptWithString:newPsd];
    [paramDict setObject:encryptOldPassword forKey:@"studentOldPassword"];
    [paramDict setObject:encryptPassword forKey:@"studentPassword"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPsd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)getValidateCodeWithEmail:(NSString *)email
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:email forKey:@"email"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_activationCode_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)findPasswordWithStudentEmail:(NSString *)email
                      activationCode:(NSString *)activationCode
                     studentPassword:(NSString *)password
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:email forKey:@"studentEmail"];
    [paramDict setObject:activationCode forKey:@"activationCode"];
    NSString *encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    [paramDict setObject:encryptPassword forKey:@"studentPassword"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_findPsd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)directoryListWithStudentID:(NSString *)studentID
                             token:(NSString *)token
                              type:(int)type
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_directoryList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)directoryDetailWithStudentID:(NSString *)studentID
                               token:(NSString *)token
                         directoryID:(NSString *)directoryID
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:directoryID forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_directoryDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)getEventCountWithStudentID:(NSString *)studentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_eventsCount_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)eventListWithStudentID:(NSString *)studentID
                         token:(NSString *)token
                          type:(int)type
                          page:(int)page
                          rows:(int)rows
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_eventList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)eventDetailWithStudentID:(NSString *)studentID
                           token:(NSString *)token
                         eventID:(NSString *)eventID
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:eventID forKey:@"id"];

    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_eventDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)joinEventWithStudentID:(NSString *)studentID
                         token:(NSString *)token
                       eventID:(NSString *)eventID
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:eventID forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_eventJoin_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)aroundListWithStudentID:(NSString *)studentID
                          token:(NSString *)token
                           type:(int)type
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_aroundList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)aroundDetailWithStudentID:(NSString *)studentID
                            token:(NSString *)token
                         aroundID:(NSString *)aroundID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:aroundID forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_aroundDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)notificationListWithStudentID:(NSString *)studentID
                                token:(NSString *)token
                               status:(int)status
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:status] forKey:@"type"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_notificationList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)notificationDetailWithStudentID:(NSString *)studentID
                                  token:(NSString *)token
                         notificationID:(NSString *)notificationID
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:notificationID forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_notificationDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)notificationSetReadStatusWithStudentID:(NSString *)studentID
                                         token:(NSString *)token
                                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_notificationStatus_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)checkTokenWithStudentID:(NSString *)studentID
                          token:(NSString *)token
                    deviceToken:(NSString *)deviceToken
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"id"];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:deviceToken forKey:@"deviceToken"];
    [paramDict setObject:[NSNumber numberWithInt:4] forKey:@"pushDeviceType"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_checkToken_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)checkMessageWithStudentID:(NSString *)studentID
                            token:(NSString *)token
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:studentID forKey:@"studentId"];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_checkMessage_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                        finished:finish];
}

+ (void)checkVersionFinished:(requestDidFinished)finish {
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppID];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                                finished:finish];
    [request start];
}

@end
