//
//  TQTeamModel.h
//  wegoal
//
//  Created by joker on 2017/2/8.
//  Copyright © 2017年 xdkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQTeamModel : NSObject

/*
"teamId": "2",
"teamLogo": "/upload/201702/28/201702282043552018.jpg",
"teamName": "测试队A2",
"poloShirtColor": "红色",
"win": "0",
"lose": "0",
"draw": "0",
"gameCount": "0",
"score": null,
"rank": "",
"yellow": "",
"red": ""
 */

@property (nonatomic, copy) NSString *teamId;          //球队id
@property (nonatomic, copy) NSString *teamLogo;        //球队logo
@property (nonatomic, copy) NSString *teamName;        //球队名称
@property (nonatomic, copy) NSString *poloShirtColor;  //球衣颜色
@property (nonatomic, copy) NSString *win;             //胜场
@property (nonatomic, copy) NSString *lose;            //负场
@property (nonatomic, copy) NSString *draw;            //平场
@property (nonatomic, copy) NSString *gameCount;       //比赛场次
@property (nonatomic, copy) NSString *score;           //比分
@property (nonatomic, copy) NSString *rank;            //等级
@property (nonatomic, copy) NSString *yellow;          //黄牌
@property (nonatomic, copy) NSString *red;             //红牌

@end
