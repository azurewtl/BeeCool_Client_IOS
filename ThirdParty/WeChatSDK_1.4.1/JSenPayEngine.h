//
//  JSenPayEngine.h
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonUtil.h"
#import "AFURLSessionManager.h"
#import "WXApiObject.h"
#import "WXApi.h"

static NSString *const kOrderID = @"OrderID";
static NSString *const kTotalAmount = @"TotalAmount";
static NSString *const kProductDescription = @"productDescription";
static NSString *const kProductName = @"productName";
static NSString *const kNotifyURL = @"NotifyURL";


static NSString *const kAppSchema = @"JsenTestAlipay";

typedef void(^paymentFinishCallBack)(int statusCode, NSString *statusMessage, NSString *resultString, NSError *error, NSData *data);


@interface JSenPayEngine : NSObject {
    
    NSString *_schema;
    NSString *_partnerKey;
    NSString *_sellerKey;
   // NSString *_RSAPrivateKey;
 //   NSString *_RSAPublicKey;
    
    paymentFinishCallBack _finishBlock;
    SEL _resultSEL;
}


+ (instancetype)sharePayEngine;

//+ (void)connectAliPayWithSchema:(NSString *)schema
//                        partner:(NSString *)partnerKey
//                         seller:(NSString *)sellerKey
//                  RSAPrivateKey:(NSString *)privateKey
//                  RSAPublicKey :(NSString *)publicKey;

+ (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block;

/*
 由于微信支付有部分工作需要服务器来做故这里只是放一个示例，以助大家了解整个过程，实际开发中不能这么做
 微信支付过程
 1.获取accessToken
 2.获取prepayId
 3.构造支付请求(PayReq)，支付
 4.支付结束回调
 */
-(void)wxPayAction;
//
@property (copy) NSString *traceId;//商家对用户的唯一标识,如果用微信 SSO,此处建议填写 授权用户的 openid
@property (copy) NSString *timeStamp;//时间戳,为 1970 年 1 月 1 日 00:00 到请求发起时间的秒 数

@property (copy) NSString *nonceStr;//32位内的随机串,防重发

@property (copy) NSString *package;

@property (copy) NSString *prepayid;

@property (copy) NSString *accessToken;
@end
