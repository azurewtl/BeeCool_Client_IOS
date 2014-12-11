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
    center.latitude = self.latitude;
    center.longitude= self.longtitude;
    return center;
}
- (NSString *)title{
   
    return self.detailposition;
}
- (NSString *)subtitle{
    return @"爱车所在位置";
}

@end
