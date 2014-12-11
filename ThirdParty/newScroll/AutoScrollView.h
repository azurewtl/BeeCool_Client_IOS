//
//  AutoScrollView.h
//  TestScrollView
//
//  Created by 波波 on 14-3-16.
//  Copyright (c) 2014年 lanou3g.com  蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tap.h"
typedef NS_ENUM(NSInteger, AutoScorllViewPageControlAlignment) {
    AutoScrollViewPageControlAlignmentLeft = 0,
    AutoScrollViewPageControlAlignmentCenter = 1,
    AutoScrollViewPageControlAlignmentRight = 2
};

@interface AutoScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imagePaths;
@property (nonatomic, copy) NSArray *imageNames;
@property (nonatomic, copy) NSArray *imageUrls;
@property (nonatomic, copy) NSArray *imageModels;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL showPageControl; //default is YES:
@property (nonatomic, assign) AutoScorllViewPageControlAlignment pageControlAlignment;

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;
- (instancetype)initWithFrame:(CGRect)frame imagePaths:(NSArray *)imagePaths;
+ (instancetype)autoScrollViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;
+ (instancetype)autoScrollViewWithFrame:(CGRect)frame imagePaths:(NSArray *)imagePaths;
-(void)setImageUrls:(NSArray *)imageUrls;
-(void)setTimeInterval:(NSTimeInterval)timeInterval;
- (void)setTarget:(id)target action:(SEL)action;
- (NSInteger)pageNo;





@end
