//
//  Vertify.h
//  VoteAge
//
//  Created by caiyang on 14/11/26.
//  Copyright (c) 2014年 azure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMS_SDK/SMS_SDK.h"
@interface Vertify : NSObject
-(void)phone:(NSString *)phonestr block:(void(^)(int result))block;
+(void)getphone:(NSString *)phonestr block:(void(^)(int result))block;
-(void)vertifynumber:(NSString *)verstr block:(void(^)(int result))block;
+(void)getvertifynumber:(NSString *)verstr block:(void(^)(int result))block;
@end
