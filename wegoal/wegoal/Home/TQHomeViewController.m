//
//  TQHomeViewController.m
//  wegoal
//
//  Created by joker on 2016/11/27.
//  Copyright © 2016年 xdkj. All rights reserved.
//

#import "TQHomeViewController.h"
#import "TQCommandView.h"
#import "TQHomeMatchCell.h"
#import "TQMatchFlowLayout.h"

#define kBadgeLabelTag               1001
#define kHomeMatchCellIdentifier     @"TQHomeMatchCell"

@interface TQHomeViewController ()<SDCycleScrollViewDelegate, TQMatchFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger scrollIndex;
}

@property (nonatomic, strong) UIScrollView *scrollView;
//banner
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
//约战
@property (nonatomic, strong) UICollectionView *matchView;
//推荐
@property (nonatomic, strong) TQCommandView *commandView;

@end

@implementation TQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollIndex = 0;
    [self setNavigationBar];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"WeGoal";
    [self setBadgeNumber:0];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_WITHOUT_TABBAR_HEIGHT)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollsToTop = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [_scrollView addSubview:self.cycleScrollView];
        [_scrollView addSubview:self.matchView];
    }
    return _scrollView;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 140/375)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"page_control_currentdot"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"page_control_dot"];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _cycleScrollView.imageURLStringsGroup = @[@"",@"",@"",@""];
    }
    return _cycleScrollView;
}

- (UICollectionView *)matchView
{
    if (!_matchView) {
        TQMatchFlowLayout *flow = [[TQMatchFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 50, 190);
        flow.minimumLineSpacing = -80;
        flow.minimumInteritemSpacing = 0;
        flow.delegate = self;
        flow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        _matchView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cycleScrollView.frame) + 15, SCREEN_WIDTH - 20, 200) collectionViewLayout:flow];
        _matchView.backgroundColor = [UIColor clearColor];
        _matchView.delegate = self;
        _matchView.dataSource = self;
        _matchView.showsHorizontalScrollIndicator = NO;
        _matchView.layer.masksToBounds = YES;
        [_matchView registerClass:[TQHomeMatchCell class] forCellWithReuseIdentifier:kHomeMatchCellIdentifier];
    }
    return _matchView;
}

#pragma mark - navigation bar 设置

- (void)setNavigationBar
{
    //背景和标题
    [self.navigationController.navigationBar setBackgroundImage:[TQCommon imageWithColor:RGB16(0x57d67e)]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjects:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:18],] forKeys:@[NSForegroundColorAttributeName,NSFontAttributeName]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


}

- (UIBarButtonItem*)buildLeftNavigationItem{
    //定位
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locationBtn setTintColor:[UIColor whiteColor]];
    [locationBtn addTarget:self action:@selector(changeLocation) forControlEvents:UIControlEventTouchUpInside];
    //label
    UILabel *cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, 30)];
    cityLbl.backgroundColor = [UIColor clearColor];
    cityLbl.textAlignment = NSTextAlignmentLeft;
    cityLbl.textColor = [UIColor whiteColor];
    cityLbl.font = [UIFont systemFontOfSize:13.f];
    cityLbl.text = @"大连市";
    [locationBtn addSubview:cityLbl];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];
    return leftBar;
}

- (UIBarButtonItem*)buildRightNavigationItem{
    //消息按钮
    UIButton *whistleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [whistleButton setFrame:CGRectMake(0, 0, 30, 30)];
    [whistleButton setImage:[UIImage imageNamed:@"whistle"] forState:UIControlStateNormal];
    [whistleButton setTintColor:[UIColor whiteColor]];
    [whistleButton addTarget:self action:@selector(showMessages) forControlEvents:UIControlEventTouchUpInside];
    //badge
    UILabel *badgeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(whistleButton.frame) - 10, -2, 12, 12)];
    badgeLbl.backgroundColor = [UIColor redColor];
    badgeLbl.layer.masksToBounds = YES;
    badgeLbl.layer.cornerRadius = 6;
    badgeLbl.font = [UIFont systemFontOfSize:8.f];
    badgeLbl.textColor = [UIColor whiteColor];
    badgeLbl.tag = kBadgeLabelTag;
    badgeLbl.textAlignment = NSTextAlignmentCenter;
    [whistleButton addSubview:badgeLbl];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:whistleButton];
    return rightBar;
}


#pragma mark - events

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    UIView *rightView = self.navigationItem.rightBarButtonItem.customView;
    UILabel *badgeLbl = [rightView viewWithTag:kBadgeLabelTag];
    if (badgeLbl == nil) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%ld", badgeNumber];
    if (badgeNumber > 99) {
        str = @"99+";
    }
    CGFloat width = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(badgeLbl.frame))
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{}
                                      context:nil].size.width + 2;
    width = MAX(width, 12);
    [badgeLbl setWidth:width];
    badgeLbl.text = str;
    //为0时隐藏
    if (badgeNumber > 0) {
        badgeLbl.hidden = NO;
    } else {
        badgeLbl.hidden = YES;
    }
    
}

- (void)showMessages
{
    NSLog(@"show message");
}

- (void)changeLocation
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"对不起，目前只支持大连市"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}


#pragma mark - TQMatchFlowLayoutDelegate

- (void)collectioViewScrollToIndex:(NSInteger)index
{
    scrollIndex = index;
    TQHomeMatchCell *cell = (TQHomeMatchCell *)[_matchView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (cell) {
        [_matchView bringSubviewToFront:cell];
    }
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TQHomeMatchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeMatchCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5.0f;
    cell.layer.masksToBounds = NO;
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shadowRadius = 5.0f;
    cell.layer.shadowOffset = CGSizeMake(3, 3);
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self collectioViewScrollToIndex:scrollIndex];
}



@end