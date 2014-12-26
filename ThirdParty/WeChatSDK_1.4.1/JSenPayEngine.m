//
//  JSenPayEngine.m
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "JSenPayEngine.h"
#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"
#import "Define.h"
#import "AFHTTPRequestOperationManager.h"
@implementation JSenPayEngine


+ (instancetype)sharePayEngine {
    static JSenPayEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block {
    [[JSenPayEngine sharePayEngine] paymentWithInfo:payInfo result:block];
}

- (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block {
    _finishBlock = [block copy];
    
    NSString *orderID = payInfo[kOrderID];
//    NSString *total = payInfo[kTotalAmount];
//    NSString *produceDes = payInfo[kProductDescription];
//    NSString *productName = payInfo[kProductName];
//    NSString *notifyURL = payInfo[kNotifyURL];
    
    if (orderID.length == 0) {
        orderID = [self generateTradeNO];
    }
    if (_partnerKey.length == 0 || _sellerKey.length == 0) {
        NSError *err = [NSError errorWithDomain:@"partner或seller参数为空" code:-1 userInfo:nil];
        if (_finishBlock) {
            _finishBlock(-1, nil, nil, err, nil);
        }
        return ;
    }
    
    
      //将商品信息拼接成字符串
}


/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

#pragma mark - 
#pragma mark - 微信支付过程


- (void)wxPayAction{
    NSString *strUrl = @"https://api.weixin.qq.com/cgi-bin/token";
    
    NSDictionary *param = @{
                            @"appid":kWXAppID,
                            @"secret":kWXAppSecret,
                            @"grant_type":@"client_credential"
                            };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        _accessToken = [responseObject objectForKey:@"access_token"];
        [self prepay];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)prepay {
    //https://api.weixin.qq.com/pay/genprepay?access_token=ACCESS_TOKEN
    
    
    NSMutableData *postData = [self getProductArgs];
    NSString *strUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?&access_token=%@",_accessToken];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessMgr  = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    sessMgr.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSessionDataTask *task = [sessMgr dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"%@  %@",responseObject,error);
        
        int errorCode = [responseObject[@"errcode"] intValue];
       NSString *ss = responseObject[@"errmsg"];
        NSLog(@"*****%@", ss);
        if (0 == errorCode) {
            self.prepayid = responseObject[@"prepayid"];
            [self pay];
        }
        
        if ([responseObject[@"errcode"]integerValue] == 49004) {
            NSLog(@"%@",responseObject[@"errmsg"]);
            
        }
    }];
    
    [task resume];
    
    
}
/*
 app_signature 生成方法:  [self genSign:params]
 A)参与签名的字段包括:appid、appkey、noncer、package、timestamp 以及 traceid
 B)对所有待签名参数按照字段名的 ASCII 码从小到大排序(字典序)后,使用 URL 键值对的 格式(即 key1=value1&key2=value2...)拼接成字符串 string1。 注意:所有参数名均为小写字符
 C)对 string1 作签名算法,字段名和字段值都采用原始值,不进行 URL 转义。具体签名算法 为 SHA1
 */
- (NSMutableData *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr];
    // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    self.package = [self genPackage];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:kWXAppKey forKey:@"appkey"];
    [params setObject:self.nonceStr forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:self.package forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData];
}

#pragma mark  开始支付
- (void)pay{
    //构造支付请求
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = kWXPartnerId;
    request.prepayId = self.prepayid;
    request.package = @"Sign=WXPay";
    request.nonceStr = self.nonceStr;
    request.timeStamp = [self.timeStamp integerValue];
    
    //构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:kWXAppKey forKey:@"appkey"];
    [params setObject:request.nonceStr forKey:@"noncestr"];
    [params setObject:request.package forKey:@"package"];
    [params setObject:request.partnerId forKey:@"partnerid"];
    [params setObject:request.prepayId forKey:@"prepayid"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    request.sign = [self genSign:params];
    
    
    
    [WXApi safeSendReq:request];
    
}
//MARK: 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
- (NSString *)genPackage{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:@"千足金箍棒" forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://weixin.qq.com" forKey:@"notify_url"];
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"];
    [params setObject:kWXPartnerId forKey:@"partner"];
    [params setObject:[CommonUtil getIPAddress:YES] forKey:@"spbill_create_ip"];
    [params setObject:@"1" forKey:@"total_fee"];
    
    NSArray *allKeys =nil;
    allKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        NSComparisonResult comRes = [str1 compare:str2 ];
        return comRes;
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in allKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    [package appendString:@"key="];
    
    [package appendString:kWXPartnerKey];
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString];
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in allKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    return result;
}
//MARK: 时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}


//MARK: 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪

- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

//MARK: sign
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [CommonUtil sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}


/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}


@end
