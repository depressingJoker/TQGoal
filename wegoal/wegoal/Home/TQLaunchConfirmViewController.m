//
//  TQLaunchConfirmViewController.m
//  wegoal
//
//  Created by joker on 2017/3/13.
//  Copyright © 2017年 xdkj. All rights reserved.
//

#import "TQLaunchConfirmViewController.h"
#import "TQTeamInformationView.h"
#import "TQMatchInformationCell.h"
#import "TQMatchRefereeCell.h"
#import "TQMatchServiceCell.h"
#import "TQLaunchServiceViewController.h"
#import "TQLaunchInvitateViewController.h"
#import "TQInvitatePopViewController.h"

#define kTQMatchInformationCellIdentifier   @"TQMatchInformationCell"
#define kTQMatchRefereeCellIdentifier       @"TQMatchRefereeCell"
#define kTQMatchServiceCellIdentifier       @"TQMatchServiceCell"
@interface TQLaunchConfirmViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *packupImageView;
}

@property (strong, nonatomic) TQTeamInformationView *topView;
@property (strong, nonatomic) UITableView *detailTableView;
@property (strong, nonatomic) UIButton *nextStep;

@property (assign, nonatomic) BOOL isRefereePackup;
@property (assign, nonatomic) BOOL isServicePackup;

@end

@implementation TQLaunchConfirmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认约战";
    self.view.backgroundColor = kMainBackColor;
    
    _isRefereePackup = NO;
    _isServicePackup = NO;
    
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.nextStep];
    _topView.teamInfo = _teamData;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _isRefereePackup = NO;
//        _isServicePackup = NO;
//        
//        [self.view addSubview:self.detailTableView];
//        [self.view addSubview:self.nextStep];
//    }
//    return self;
//}
//
//- (void)reloadData
//{
//    [_detailTableView reloadData];
//    _topView.teamInfo = _teamData;
//}

- (TQTeamInformationView *)topView
{
    if (!_topView) {
        _topView = [[TQTeamInformationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.viewMode = TeamTopViewModeTeam;
    }
    return _topView;
}

- (UITableView *)detailTableView
{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT - 44) style:UITableViewStylePlain];
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
        _detailTableView.backgroundColor = kMainBackColor;
        [_detailTableView registerNib:[UINib nibWithNibName:@"TQMatchInformationCell" bundle:nil] forCellReuseIdentifier:kTQMatchInformationCellIdentifier];
        [_detailTableView registerNib:[UINib nibWithNibName:@"TQMatchRefereeCell" bundle:nil] forCellReuseIdentifier:kTQMatchRefereeCellIdentifier];
        [_detailTableView registerNib:[UINib nibWithNibName:@"TQMatchServiceCell" bundle:nil] forCellReuseIdentifier:kTQMatchServiceCellIdentifier];
        _detailTableView.tableHeaderView = self.topView;
    }
    return _detailTableView;
}

- (UIButton *)nextStep
{
    if (!_nextStep) {
        _nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStep.frame = CGRectMake(0, VIEW_HEIGHT - 44, SCREEN_WIDTH, 44);
        _nextStep.backgroundColor = kRedBackColor;
        [_nextStep setTitle:@"确认约战" forState:UIControlStateNormal];
        _nextStep.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStep addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStep;
}


#pragma mark - events

- (void)confirmAction
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"Id"] = _teamData.teamId;
    params[@"userName"] = USER_NAME;
    params[@"gameDate"] = [NSDate datestrFromDate:_matchData[@"time"] withDateFormat:kDateFormatter1];
    params[@"gameWeek"] = [TQCommon weekStringFromDate:_matchData[@"time"]];
    TQPlaceModel *placeData = _matchData[@"place"];
    params[@"gamePlace"] = placeData.name;
    params[@"gamePlaceId"] = placeData.gamePlaceId;
    params[@"placeFee"] = placeData.price;
    params[@"gameRules"] = _matchData[@"system"];
    if (_refereeData.isSelected) {
        params[@"refereeServiceId"] = _refereeData.serviceId;
    }
    if (_servicesArray.count > 0) {
        params[@"otherServiceIdAndCount"] = [self getServiceStr];
    }

    [JOIndicatorView showInView:self.detailTableView];
    [[AFServer sharedInstance]POST:URL(kTQDomainURL, kSetEnroll) parameters:params filePath:nil finishBlock:^(id result) {
        [JOIndicatorView hiddenInView:weakSelf.detailTableView];
        if (result[@"status"] != nil && [result[@"status"] integerValue] == 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //约战发起成功，通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kLaunchMatchSuccess object:nil userInfo:nil];
                //弹出邀请
                [weakSelf popInviteVC];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JOToast showWithText:result[@"msg"]];
            });
        }
        
    } failedBlock:^(NSError *error) {
        [JOIndicatorView hiddenInView:weakSelf.detailTableView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [JOToast showWithText:@"网络连接失败，请稍后再试！"];
        });
    }];
    
}

//跳转到邀请界面
- (void)popInviteVC
{
    TQInvitatePopViewController *inviteVC = [[TQInvitatePopViewController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 20)];
    inviteVC.view.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) weakSelf = self;
    inviteVC.inviteBlock = ^(InviteType type){
        switch (type) {
            case InviteTypeCancel:
                [weakSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                break;
                
            case InviteTypeWechat:
                break;
                
            case InviteTypeTimeLine:
                break;
                
            case InviteTypeQQ:
                break;
                
            case InviteTypeTeam:
            {
                [weakSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                //跳转到邀请好友界面
                TQLaunchInvitateViewController *launchInviteVC = [[TQLaunchInvitateViewController alloc] init];
                [weakSelf.navigationController pushViewController:launchInviteVC animated:YES];
                break;
            }
                
            default:
                break;
        }
    };
    [self presentPopupViewController:inviteVC animationType:MJPopupViewAnimationFade];
}

- (NSString *)getServiceStr
{
    NSMutableArray *array = [NSMutableArray array];
    for (TQServiceModel *serviceData in _servicesArray) {
        [array addObject:@{@"id":serviceData.serviceId, @"num":@(serviceData.amount)}];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSString *str = @"[";
//    for (TQServiceModel *serviceData in _servicesArray) {
//        str = [str stringByAppendingString:[NSString stringWithFormat:@"{id:%@,num:%ld}", serviceData.serviceId, serviceData.amount]];
//        if ([_servicesArray indexOfObject:serviceData] < _servicesArray.count - 1) {
//            str = [str stringByAppendingString:@","];
//        }
//    }
//    str = [str stringByAppendingString:@"]"];
//    return str;
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_servicesArray && _servicesArray.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_refereeData.isSelected) {
            return 5;
        } else {
            return 4;
        }
    } else {
        if (_isServicePackup) {
            return 0;
        } else {
            return _servicesArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row >= 0 && indexPath.row < 4) {
            TQMatchInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:kTQMatchInformationCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"TQMatchInformationCell" owner:nil options:nil].firstObject;
            }
            cell.noticeView.hidden = YES;
            switch (indexPath.row) {
                case 0:
                    cell.infoImageView.image = [UIImage imageNamed:@"match_time"];
                    cell.infoTitleLabel.text = @"约战时间";
                    cell.infoContentLabel.text = [NSDate datestrFromDate:_matchData[@"time"] withDateFormat:kDateFormatter2];
                    break;
                case 1:
                    cell.infoImageView.image = [UIImage imageNamed:@"match_ground"];
                    cell.infoTitleLabel.text = @"约战场地";
                    cell.infoContentLabel.text = ((TQPlaceModel *)_matchData[@"place"]).name;
                    break;
                case 2:
                    cell.infoImageView.image = [UIImage imageNamed:@"ground_pay"];
                    cell.infoTitleLabel.text = @"场地费用";
                    cell.infoContentLabel.text = [NSString stringWithFormat:@"￥%@", ((TQPlaceModel *)_matchData[@"place"]).price?:@""];
                    cell.noticeView.hidden = NO;
                    break;
                case 3:
                    cell.infoImageView.image = [UIImage imageNamed:@"race_system"];
                    cell.infoTitleLabel.text = @"赛制";
                    cell.infoContentLabel.text = _matchData[@"system"];
                    break;
                    
                default:
                    cell.infoImageView.image = nil;
                    cell.infoTitleLabel.text = @"---";
                    cell.infoContentLabel.text = @"---";
                    break;
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            TQMatchRefereeCell *cell = [tableView dequeueReusableCellWithIdentifier:kTQMatchRefereeCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"TQMatchRefereeCell" owner:nil options:nil].firstObject;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakSelf = self;
            cell.isPackup = _isRefereePackup;
            cell.canSelected = NO;
            if (_refereeData) {
                cell.refereeData = _refereeData;
            } else {
                [cell clearInformation];
            }
            cell.block = ^(BOOL isPackup){
                weakSelf.isRefereePackup = isPackup;
                [weakSelf.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            };
            return cell;
        }
    } else {
        TQMatchServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kTQMatchServiceCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TQMatchServiceCell" owner:nil options:nil].firstObject;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.canSelected = NO;
        if (indexPath.row < _servicesArray.count) {
            cell.serviceData = _servicesArray[indexPath.row];
        } else {
            [cell clearInformation];
        }
        return cell;
    }

}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row >= 0 && indexPath.row < 4) {
            return 37.f;
        } else {
            if (_isRefereePackup) {
                return 40.f;
            } else {
                return 120.f;
            }
        }
    } else {
        return 80.f;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 44.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.f)];
    headerView.backgroundColor = kMainBackColor;
    
    UIView *subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, 39.f)];
    subHeaderView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:subHeaderView];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 50, 15)];
    titleLbl.textColor = kNavTitleColor;
    titleLbl.font = [UIFont systemFontOfSize:12.f];
    titleLbl.text = @"约服务";
    packupImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 22, 15, 10, 6)];
    if (_isServicePackup) {
        packupImageView.image = [UIImage imageNamed:@"drop_gray"];
    } else {
        packupImageView.image = [UIImage imageNamed:@"packup_gray"];
    }
    [subHeaderView addSubview:titleLbl];
    [subHeaderView addSubview:packupImageView];
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packupServiceView)];
    [subHeaderView addGestureRecognizer:tapGesture];
    
    return headerView;
}

- (void)packupServiceView
{
    _isServicePackup = !_isServicePackup;
//    [_detailTableView reloadData];
    [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

@end


