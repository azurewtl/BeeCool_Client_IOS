//
//  myAnnotation.h
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface myAnnotation : NSObject<MKAnnotation>
@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longtitude;
@property(nonatomic)NSString *detailposition;

@end
