//
//  DB_LoginRequest.m
//  YiYuanGou
//
//  Created by Yanice on 16/8/5.
//  Copyright © 2016年 LEE. All rights reserved.
//

#import "DB_LoginRequest.h"
#import "DLNetWorking.h"
#import "DB_LoginTools.h"
#import "DB_UserDataCenter.h"

@implementation DB_LoginRequest

+ (void)loginRequest:(DBUserResp *)requestInfo andResult:(loginResult)result {

    NSString *open_id=nil;
    if ([requestInfo.source isEqualToString:@"wechat"]) {
        open_id = [NSString stringWithFormat:@"%@,%@",requestInfo.unionid,requestInfo.open_id];
    }else {
        open_id = requestInfo.open_id;
    }
    NSDictionary *dict = @{@"token":requestInfo.token,
                           @"open_id":open_id,
                           @"source":requestInfo.source
                           };
    [[DLNetWorking shareInstance] POST:URLWithLogin parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject[@"code"] intValue]) {
            NSDictionary *dict = responseObject[@"data"];
            [DB_UserDataCenter saveUserInfo:dict];
            result(@"登录成功",YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(@"相应服务器失败",NO);
    }];
}

@end
