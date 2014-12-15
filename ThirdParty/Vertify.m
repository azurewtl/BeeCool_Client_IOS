//
//  Vertify.m
//  VoteAge
//
//  Created by caiyang on 14/11/26.
//  Copyright (c) 2014年 azure. All rights reserved.
//

#import "Vertify.h"
#import <SMS_SDK/SMS_SDK.h>
#import <UIKit/UIKit.h>

@implementation Vertify
-(void)phone:(NSString *)phonestr block:(void (^)(int))block{

    [SMS_SDK getVerifyCodeByPhoneNumber:phonestr AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if(1 == state){
            block(1);
        }else if(0 == state){
            block(0);
        }
    }];
}
+(void)getphone:(NSString *)phonestr block:(void (^)(int))block{
    Vertify *vertify = [[Vertify alloc]init];
    [vertify phone:phonestr block:block];
}
-(void)vertifynumber:(NSString *)verstr block:(void (^)(int))block{
    [SMS_SDK commitVerifyCode:verstr result:^(enum SMS_ResponseState state) {
        if(1 == state){
            block(1);
        }else if (0 == state) {
            block(0);
        }
    }];
}
+(void)getvertifynumber:(NSString *)verstr block:(void (^)(int))block{
    Vertify *vertify = [[Vertify alloc]init];
    [vertify vertifynumber:verstr block:block];
}
@end
