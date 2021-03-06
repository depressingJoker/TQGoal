//
//  UserData.h
//  WeGoal
//
//  Created by joker on 15/6/9.
//  Copyright (c) 2015年 WeGoal. All rights reserved.
//  存储用户登录信息类

#import <Foundation/Foundation.h>
#import "TQMemberModel.h"

#define UserDataManager [UserData shareManager]

@interface UserData : NSObject

+ (UserData*)shareManager;

//用户Token和name
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userName;

// 数据读取与保存
- (void)setUserData:(NSDictionary *)userData;
- (TQMemberModel *)getUserData;
- (NSDictionary *)getUserDataDict;

// 清空用户数据
- (void)clearUserData;

@end
