//
//  AutoScrollView.m
//  TestScrollView
//
//  Created by 波波 on 14-3-16.
//  Copyright (c) 2014年 lanou3g.com  蓝鸥科技. All rights reserved.
//

#import "AutoScrollView.h"
#import "UIImageView+WebCache.h"
#import "BeeCool_Client_IOS-Swift.h"
#define kPageControlHeight 20
#define kPageControlPadding 20

@interface UIScrollView (ScrollViewPageNo)

- (NSInteger)pageNo;

@end

@implementation UIScrollView (ScrollViewPageNo)

- (NSInteger)pageNo
{
    int pageNo = self.contentOffset.x / self.frame.size.width + 0.5;
    return pageNo;
}

@end

@interface AutoScrollView ()
{
    UIScrollView *_scrollView;
    NSTimer *_timer;
    BOOL _autoScrollFlag;
    
    id _target;
    SEL _action;
}

@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation AutoScrollView

- (oneway void)release
{
    if (2 == self.retainCount) {
        [_timer invalidate];
    }
    
    [super release];
}

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame imageNames:nil];
    return self;
}

- (void)createScrollView
{
    _autoScrollFlag = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setScrollsToTop:NO];
    [self addSubview:_scrollView];
    
    //  代理指针不能用retain只能用assign的原因是防止父对象做子对象代理的时候产生循环引用
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //  设置是否分页显示
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeMake(self.bounds.size.width, 0)];
    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * 0.9, self.bounds.size.width, self.bounds.size.height * 0.1)];
//    view.backgroundColor = [UIColor blackColor];
//    view.alpha = 0.6;
//    [self addSubview:view];
//    [view release];
//    
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * 0.9, self.bounds.size.width, self.bounds.size.height * 0.1)];
//    self.titleLabel.backgroundColor = [UIColor clearColor];
//    self.titleLabel.text = @"活动介绍轮播";
//    self.titleLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.titleLabel];
//    [self.titleLabel release];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [tap setNumberOfTouchesRequired:1];
//    [_scrollView addGestureRecognizer:tap];
//    [tap release];
}

//  designate initializer
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames
{
    self = [self initWithFrame:frame imagePaths:nil];
    self.imageNames = imageNames;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imagePaths:(NSArray *)imagePaths
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollView];
        self.showPageControl = YES;
        self.pageControlAlignment = AutoScrollViewPageControlAlignmentCenter;
        self.imagePaths = imagePaths;
    }
    return self;
}


+ (instancetype)autoScrollViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames
{
    AutoScrollView *autoScorllView = [[AutoScrollView alloc] initWithFrame:frame imageNames:imageNames];
    return [autoScorllView autorelease];
}

+ (instancetype)autoScrollViewWithFrame:(CGRect)frame imagePaths:(NSArray *)imagePaths
{
    AutoScrollView *autoScorllView = [[AutoScrollView alloc] initWithFrame:frame imagePaths:imagePaths];
    return [autoScorllView autorelease];
}


- (NSArray *)imageNames2imagePaths:(NSArray *)imageNames
{
    NSMutableArray *imagePaths = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString *imageName in imageNames) {
        NSArray *nameArray = [imageName componentsSeparatedByString:@"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[nameArray firstObject] ofType:[nameArray lastObject]];
        [imagePaths addObject:imagePath];
    }
    return [[imagePaths retain] autorelease];
}

-(void)setImageUrls:(NSArray *)imageUrls{
    
    if (_imageUrls == imageUrls) {
        return;
    }
    [_imageUrls release];
    _imageUrls = [imageUrls copy];
    self.imageNames = nil;
//    self.imageNames = imageUrls;
    [self setScrollViewSubimages:_imageUrls isUrl:YES];
}


-(void)setImageModels:(NSArray *)imageModels{
    if (_imageModels == imageModels) {
        return;
    }
    [_imageModels release];
    _imageModels = [imageModels copy];
    NSMutableArray *images = [NSMutableArray array];
    for (NSDictionary *dic in imageModels) {
        [images addObject:[dic objectForKey:@"ImgUrl"]];
    }
    self.imageUrls = images;
}


- (void)setImageNames:(NSArray *)imageNames
{
    if (_imageNames == imageNames) {
        return;
    }
    
    [_imageNames release];
    _imageNames = [imageNames copy];
    
    self.imagePaths = [self imageNames2imagePaths:self.imageNames];
}

- (void)setImagePaths:(NSArray *)imagePaths
{
    if (_imagePaths == imagePaths) {
        return;
    }
    
    [_imagePaths release];
    _imagePaths = [imagePaths copy];
    [self setScrollViewSubimages:_imagePaths isUrl:NO];
}

- (void)setScrollViewSubimages:(NSArray *)array isUrl:(BOOL)isUrl{
    for (UIView *aView in _scrollView.subviews) {
        [aView removeFromSuperview];
    }
    CGSize contentSize = _scrollView.bounds.size;
    contentSize.width *= [array count] + 2;
    //  设置可滚动区域
    [_scrollView setContentSize:contentSize];
    
    CGRect rect = _scrollView.bounds;
    
    //  在最前面添加最后一页
    UIImageView *aView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    NSString *imagePath = [array lastObject];
    if (isUrl) {
        [aView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
       
    }else {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [aView setImage:image];
    }
    
    [_scrollView addSubview:aView];
    
    for (int i = 0; i < array.count; i++) {
        rect.origin.x += rect.size.width;
        //        rect.origin.x = i * rect.size.width;
        UIImageView *aView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        aView.userInteractionEnabled = YES;
        Tap *tap = [[Tap alloc] initWithTarget:self action:@selector(tap:)];
        tap.flag = i;
        
        [aView addGestureRecognizer:tap];
        [tap release];
        //        UIImage *image = [UIImage imageNamed:[_imageNames objectAtIndex:i]];  //  初始化成功后会被系统缓存 不能释放
        NSString *imagePath = array[i];
        if (isUrl) {
            [aView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
//            [aView setBackgroundColor:[UIColor redColor]];
        }else {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [aView setImage:image];
        }

        [_scrollView addSubview:aView];
    }
    
    //  在最后面添加第一页
    rect.origin.x += rect.size.width;
    UIImageView *bView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    imagePath = [array firstObject];
    
    if (isUrl) {
        [bView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    }else {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [bView setImage:image];
    }

    [_scrollView addSubview:bView];
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
    
    [_pageControl setNumberOfPages:array.count];
    self.pageControlAlignment = self.pageControlAlignment;
}



- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    [_timer invalidate]; _timer = nil;
    if (_timeInterval > 0.0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timeUp:) userInfo:nil repeats:YES];
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    if (showPageControl == _showPageControl) {
        return;
    }
    
    _showPageControl = showPageControl;
    if (_showPageControl) {
        self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2 * kPageControlHeight, self.frame.size.width, kPageControlHeight)] autorelease];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [self addSubview:self.pageControl];
        
    } else {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
}

- (void)timeUp:(id)sender
{
    if (_autoScrollFlag) {
        CGPoint contentOffset = CGPointMake((_scrollView.pageNo + 1) * _scrollView.bounds.size.width, 0);
        [_scrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)tap:(Tap *)tap
{
    [_target performSelector:_action withObject:tap];
}

- (void)setPageControlAlignment:(AutoScorllViewPageControlAlignment)pageControlAlignment
{
    if (_pageControlAlignment == pageControlAlignment) {
        return;
    }
    
    if (! _showPageControl) {
        return;
    }
    
    self.showPageControl = YES;
    CGRect rect = self.pageControl.frame;
    CGSize size = [self.pageControl sizeForNumberOfPages:_imagePaths.count];
    rect.size.width = size.width + kPageControlPadding * 2;
    _pageControlAlignment = pageControlAlignment;
    switch (_pageControlAlignment) {
        case AutoScrollViewPageControlAlignmentLeft:
            rect.origin.x = 0;
            break;
        case AutoScrollViewPageControlAlignmentCenter:
            rect.origin.x = (self.bounds.size.width - rect.size.width) / 2;
            break;
        case AutoScrollViewPageControlAlignmentRight:
            rect.origin.x = self.bounds.size.width - rect.size.width;
            break;
    }
    [_pageControl setFrame:rect];
}

- (NSInteger)pageNo
{
    return self.pageControl.currentPage;
}

#pragma mark -
#pragma mark scrollView delegate method

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _autoScrollFlag = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _autoScrollFlag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    int pageCount = 0;
    if (self.imageUrls) {
        pageCount = self.imageUrls.count;
    } else if (self.imageNames) {
        pageCount = self.imageNames.count;
    }
    
    int pageNo = scrollView.pageNo;
    if (pageNo == _currentPage) {
        return;
    }
    _currentPage = pageNo;
    pageNo--;
    CGPoint contentOffset = scrollView.contentOffset;
    if (-1 == pageNo) {
        contentOffset.x += scrollView.frame.size.width * pageCount;
        [scrollView setContentOffset:contentOffset];
        pageNo = pageCount - 1;
    }else if (pageCount == pageNo){
        contentOffset.x -= scrollView.frame.size.width * pageCount;
        [scrollView setContentOffset:contentOffset];
        pageNo = 0;
    }
    
    if (_pageControl) {
        [_pageControl setCurrentPage:pageNo];
    }
}



@end
