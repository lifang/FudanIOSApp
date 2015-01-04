//
//  NetworkInterface.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/9.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"
#import "MBProgressHUD.h"

typedef enum {
    requestSuccess = 0,
    requestTokenOverdue = -2,
}RequestCode;

//注册
static NSString *s_register_method = @"studentRegister";
//登录
static NSString *s_login_method = @"studentLogin";
//退出
static NSString *s_loginOut_method = @"studentLoginOut";
//修改用户信息
static NSString *s_modify_method = @"studentModification";
//修改密码
static NSString *s_modifyPsd_method = @"studentModifyPassword";
//获取验证码
static NSString *s_activationCode_method = @"getActivationCode";
//找回密码
static NSString *s_findPsd_method = @"studentFindPassword";
//Pre-Arrival、Arrival、Campus列表
static NSString *s_directoryList_method = @"getContents";
//Pre-Arrival、Arrival、Campus详情
static NSString *s_directoryDetail_method = @"getContent";
//event未读数量
static NSString *s_eventsCount_method = @"getEventsCount";
//event列表
static NSString *s_eventList_method = @"getEvents";
//event详情
static NSString *s_eventDetail_method = @"getEvent";
//event报名
static NSString *s_eventJoin_method = @"joinEvent";
//around列表
static NSString *s_aroundList_method = @"getArounds";
//around详情
static NSString *s_aroundDetail_method = @"getAround";
//通知列表
static NSString *s_notificationList_method = @"getNotifications";
//通知详情
static NSString *s_notificationDetail_method = @"getNotification";
//通知改为已读状态
static NSString *s_notificationStatus_method = @"readAllNotification";
//判断token是否失效
static NSString *s_checkToken_method = @"getStudentTokenStatus";
//检测是否有新消息
static NSString *s_checkMessage_method = @"getNotificationUnReadCount";

@interface NetworkInterface : NSObject

/*!
 @abstract 注册
 @param activation      激活码
 @param studentEmail    邮箱
 @param studentPassword 密码
 @param mobilePhone     手机号(可空)
 @result finish  请求回调结果
 */
+ (void)registerWithActivation:(NSString *)activation
                  studentEmail:(NSString *)studentEmail
               studentPassword:(NSString *)studentPassword
                   mobilePhone:(NSString *)mobilePhone
                      finished:(requestDidFinished)finish;

/*!
 @abstract 登录
 @param email      邮箱
 @param password    密码(传入时未加密)
 @param deviceToken 设备号
 @param encrypt    是否已经加密
 @result finish  请求回调结果
 */
+ (void)loginWithStudentEmail:(NSString *)email
              studentPassword:(NSString *)password
                  deviceToken:(NSString *)deviceToken
               alreadyEncrypt:(BOOL)encrypt
                     finished:(requestDidFinished)finish;

/*!
 @abstract 退出
 @param studentID     登录成功返回
 @param token         登录成功返回
 @result finish  请求回调结果
 */
+ (void)loginOutWithStudentID:(NSString *)studentID
                        token:(NSString *)token
                     finished:(requestDidFinished)finish;

/*!
 @abstract 修改用户信息
 @param studentID     登录成功返回
 @param token         登录成功返回
 @param mobilePhone   手机号
 @param email         邮箱
 @param activationCode    激活码
 @result finish  请求回调结果
 */
+ (void)modifyUserInfoWithStudentID:(NSString *)studentID
                              token:(NSString *)token
                        mobilePhone:(NSString *)mobilePhone
                       studentEmail:(NSString *)email
                     activationCode:(NSString *)activationCode
                           finished:(requestDidFinished)finish;

/*!
 @abstract 修改密码
 @param studentID     登录成功返回
 @param token         登录成功返回
 @param oldPsd      旧密码
 @param newPsd      新密码
 @result finish  请求回调结果
 */
+ (void)modifyPasswordWithStudentID:(NSString *)studentID
                              token:(NSString *)token
                        oldPassword:(NSString *)oldPsd
                           password:(NSString *)newPsd
                           finished:(requestDidFinished)finish;

/*!
 @abstract 获取验证码
 @param email   验证码
 @result finish  请求回调结果
 */
+ (void)getValidateCodeWithEmail:(NSString *)email
                        finished:(requestDidFinished)finish;

/*!
 @abstract 找回密码
 @param email   验证码
 @param activationCode   验证码
 @param password   新密码
 @result finish  请求回调结果
 */
+ (void)findPasswordWithStudentEmail:(NSString *)email
                      activationCode:(NSString *)activationCode
                     studentPassword:(NSString *)password
                            finished:(requestDidFinished)finish;

/*!
 @abstract Pre-Arrival、Arrival、Campus列表
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param type   1.Pre-Arrival 2.Arrival 3.Campus
 @result finish  请求回调结果
 */
+ (void)directoryListWithStudentID:(NSString *)studentID
                             token:(NSString *)token
                              type:(int)type
                          finished:(requestDidFinished)finish;

/*!
 @abstract Pre-Arrival、Arrival、Campus列表
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param directoryID  文章ID
 @result finish  请求回调结果
 */
+ (void)directoryDetailWithStudentID:(NSString *)studentID
                               token:(NSString *)token
                         directoryID:(NSString *)directoryID
                            finished:(requestDidFinished)finish;

/*!
 @abstract event未读数量
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @result finish  请求回调结果
 */
+ (void)getEventCountWithStudentID:(NSString *)studentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish;

/*!
 @abstract event列表
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param type   event分类类型
 @param page   分页参数
 @param rows  分页参数
 @result finish  请求回调结果
 */
+ (void)eventListWithStudentID:(NSString *)studentID
                         token:(NSString *)token
                          type:(int)type
                          page:(int)page
                          rows:(int)rows
                      finished:(requestDidFinished)finish;

/*!
 @abstract event详情
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param eventID  eventID
 @result finish  请求回调结果
 */
+ (void)eventDetailWithStudentID:(NSString *)studentID
                           token:(NSString *)token
                         eventID:(NSString *)eventID
                        finished:(requestDidFinished)finish;

/*!
 @abstract event报名
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param eventID  eventID
 @result finish  请求回调结果
 */
+ (void)joinEventWithStudentID:(NSString *)studentID
                         token:(NSString *)token
                       eventID:(NSString *)eventID
                      finished:(requestDidFinished)finish;

/*!
 @abstract around列表
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param type   around分类类型
 @param page   分页参数
 @param rows  分页参数
 @result finish  请求回调结果
 */
+ (void)aroundListWithStudentID:(NSString *)studentID
                          token:(NSString *)token
                           type:(int)type
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract around详情
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param aroundID  aroundID
 @result finish  请求回调结果
 */
+ (void)aroundDetailWithStudentID:(NSString *)studentID
                            token:(NSString *)token
                         aroundID:(NSString *)aroundID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 通知列表
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param status   new 0, recent 1, all 2
 @param page   分页参数
 @param rows  分页参数
 @result finish  请求回调结果
 */
+ (void)notificationListWithStudentID:(NSString *)studentID
                                token:(NSString *)token
                               status:(int)status
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish;

/*!
 @abstract 通知详情
 @param studentID   登录成功后返回
 @param token  登录成功后返回
 @param notificationID 通知ID
 @result finish  请求回调结果
 */
+ (void)notificationDetailWithStudentID:(NSString *)studentID
                                  token:(NSString *)token
                         notificationID:(NSString *)notificationID
                               finished:(requestDidFinished)finish;

/*!
 @abstract 通知改为已读
 @param studentID   登录成功后返回
 @param token       登录成功后返回
 @result finish  请求回调结果
 */
+ (void)notificationSetReadStatusWithStudentID:(NSString *)studentID
                                         token:(NSString *)token
                                      finished:(requestDidFinished)finish;

/*!
 @abstract 判断token是否失效
 @param studentID   登录成功后返回
 @param token 登录成功后返回
 @parm deviceToken 设备号
 @result finish  请求回调结果
 */
+ (void)checkTokenWithStudentID:(NSString *)studentID
                          token:(NSString *)token
                    deviceToken:(NSString *)deviceToken
                       finished:(requestDidFinished)finish;

/*!
 @abstract 检测是否有新消息
 @param studentID   登录成功后返回
 @param token 登录成功后返回
 @result finish  请求回调结果
 */
+ (void)checkMessageWithStudentID:(NSString *)studentID
                            token:(NSString *)token
                         finished:(requestDidFinished)finish;

/*!
 从App Store检测新版本
 */
+ (void)checkVersionFinished:(requestDidFinished)finish;

@end
