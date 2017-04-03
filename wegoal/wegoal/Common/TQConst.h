//
//  TQConst.h
//  wegoal
//
//  Created by joker on 2016/12/20.
//  Copyright © 2016年 xdkj. All rights reserved.
//

#import <Foundation/Foundation.h>

//约战状态
//typedef NS_ENUM(NSInteger, MatchStatus){
//    MatchStatusNewJoiner = 0,     //新球员，可创建、加入球队
//    MatchStatusTeaming,           //组队中
//    MatchStatusStartUp,           //组队完成，可以发起约战
//    MatchStatusStarted,           //发起约战，等待响应
//    MatchStatusResponse,          //响应约战，等待发起方确认
//    MatchStatusConfirm,           //有人响应，等待确认
//    MatchStatusPay,               //确认约战，待支付
//    MatchStatusWaiting,           //支付完成，等待开始
//    MatchStatusProcessing,        //进行中
//    MatchStatusEvaluateSelf,      //评价己方
//    MatchStatusEvaluateOther,     //评价对手
//    MatchStatusShare,             //分享
//};

typedef NS_ENUM(NSInteger, MatchStatus){
    MatchStatusSearching = 0,     //等待应战
    MatchStatusConfirm,           //确认对手
    MatchStatusPay,               //支付
    MatchStatusWaiting,           //等待约战开始
    MatchStatusProcessing,        //赛况直播
    MatchStatusEvaluateMember,    //评价球员
    MatchStatusEvaluateOpponent,  //评价对手
    MatchStatusViewSchedule,      //查看全部赛程
    MatchStatusNotTeam,           //非队长未报名(非队长球员只能操作7、8)
};

typedef NS_ENUM(NSInteger, GameEvent){
    GameEventStart = 0,           //比赛开始
    GameEventPause,               //暂停
    GameEventEnd,                 //结束
    GameEventPlayerOn,            //球员上场
    GameEventPlayerOut,           //球员下场
    GameEventYellow,              //黄牌
    GameEventRed,                 //红牌
    GameEventGoal,                //进球
};

#define kRaceSystemArray   @[@"5人制",@"7/8/9人制",@"11人制"]

#define kYellowKeyArray   @[@"GK"]
#define kYellowValueArray @[@"守门员"]
#define kGreenKeyArray    @[@"SW", @"CB", @"LCB", @"RCB", @"CWP", @"SB", @"LB", @"RB", @"WB", @"LWB", @"RWB"]
#define kGreenValueArray  @[@"清道夫 拖后中卫", @"中后卫", @"左中卫", @"右中卫", @"自由人、常压上助攻的中后卫", @"边后卫", @"左边后卫", @"右边后卫", @"边后腰", @"边路进攻左后卫", @"边路进攻右后卫"]
#define kBlueKeyArray     @[@"MF", @"SMF", @"LMF", @"RMF", @"DMF", @"CMF "]
#define kBlueValueArray   @[@"边后腰 边路能力强，攻守兼具的中场", @"边前卫", @"左边前卫", @"右边前卫", @"防守型中场 即后腰", @"中场 中前卫 攻守均衡的中场"]
#define kOrangeKeyArray   @[@"OMF", @"AMF", @"WF", @"LWF", @"RWF"]
#define kOrangeValueArray @[@"进攻组织者 前腰", @"攻击型前卫 前腰", @"边锋", @"左边锋", @"右边锋"]
#define kRedKeyArray      @[@"ST", @"SS", @"ST"]
#define kRedValueArray    @[@"前锋", @"影子前锋", @"中锋"]

//颜色
#define kMainBackColor       RGB16(0xF0F6F2)
#define kTitleTextColor      RGB16(0x96ABB5)
#define kSubTextColor        RGB16(0xDFE8EC)
#define kSubjectBackColor    RGB16(0x57D67E)
#define kLiveBackColor       RGB16(0x72E796)
#define kScheduleBackColor   RGB16(0x0B1523)
#define kNavTitleColor       RGB16(0x34454C)
#define kBackLineColor       RGB16(0xDFDFDF)
#define kRedBackColor        RGB16(0xF9585E)
#define kUnenableColor       RGB16(0xDFE8EC)
#define kSystemBlueColor     RGB16(0x30B3F7)
#define kInputBackColor      RGB16(0xF1F6F8)
#define kWechatColor         RGB16(0x8DC81B)
#define kQQColor             RGB16(0x2196F3)

//Notification Identifier
#define kTabbarNeedShowNoti  @"TabbarNeedShow"
#define kTabbarNeedHideNoti  @"TabbarNeedHide"
#define kTabbarClickButton   @"TabbarClickButton"
#define kWelcomeToHome       @"WelcomeToHome"
#define kWelcomeLoginSuccess @"WelcomeLoginSuccess"
#define kShowScheuleTab      @"ShowScheuleTab"


//Native
#define kGuideViewShow       @"GuideViewShow"


//date formatter
#define kDateFormatter1      @"yyyyMMddHHmm"
#define kDateFormatter2      @"MM/dd - HH:mm"


#define HTTP_TIME_OUT 10
