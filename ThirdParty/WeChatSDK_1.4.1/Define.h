//
//  Define.h
//  testAliPay
//
//  Created by JSen on 14/11/3.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//
/*
 微信支付参数：
注意 ：参数需要你自己提供
 */
#define kWXAppID @"wx51b75b45569c1381"
#define kWXAppSecret @"0996a915d7fdad46ffefca2f9033b210"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
#define  kWXPartnerKey @"T6PFFfBxinc3r1xdI8mf7aKMtwwNPLEo"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
#define  kWXAppKey @"ckiSt15xvafMOW1OtN8tQptbldF0pQvs"

/**
 *  微信公众平台商户模块生成的ID
 */
#define kWXPartnerId  @"1224831801"