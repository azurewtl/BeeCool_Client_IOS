//
//  myAnnotation.m
//  BeeCool_Client_IOS
//
//  Created by ; on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "myAnnotation.h"

@implementation myAnnotation
- (CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D center;
    center.latitude = 40.029915;
    center.longitude=116.347082;
    return center;
}
- (NSString *)title{
    return  @"北京大学";
}
- (NSString *)subtitle{
    return @"你所查询的位置";
}
@end
