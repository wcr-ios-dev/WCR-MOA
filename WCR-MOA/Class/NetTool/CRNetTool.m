//
//  CRNetTool.m
//  WCR-MOA
//
//  Created by wcr－dev on 2016/12/28.
//  Copyright © 2016年 Alijoin. All rights reserved.
//

#import "CRNetTool.h"
#import "AFNetworking.h"
#import "MOAParamModel.h"


#define kDefaultCookie      @"123456789"
@interface CRNetTool()

@property (strong,nonatomic) MOAParamModel * paramModel;

@end

@implementation CRNetTool
//单例模式
static CRNetTool * nettool = nil;




- (CRNetTool *)sharedInstance{
    return [CRNetTool sharedInstance];
}
+ (CRNetTool *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once( &once,^{ nettool = [[CRNetTool alloc] init];} );
    return nettool;
}
//post请求
- (void)Post:(NSString *)url dict:(NSDictionary *)dict paramesArr:(NSArray *)arr actionId:(NSString *)actionId  success:(void (^)(id data))success fail:(void (^)(NSError * error))fail{
    
    self.paramModel.paramNames = arr;
    self.paramModel.values = dict;
    NSString *param = [self parseDict2Param:self.paramModel];
    NSString *SeverUrl = [NSString stringWithFormat:@"%@%@",MoaSeverHost,url];
    
    [self request:SeverUrl paramsL:param actionId:actionId success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];

}
- (void)request:(NSString *)url paramsL:(id)params actionId:(NSString *)actionId success:(void (^)(id data))success fail:(void (^)(NSError * error))fail{
    NSString * cookie = [self setCookie:actionId];
    //创建manager对象
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //时间
    manager.requestSerializer.timeoutInterval = 120;
    //返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求头
    [manager.requestSerializer setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    //设置cookie
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    //POST请求
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        NSString *sessionId = response.allHeaderFields[SessionId];
        
        NSString *chunnelCode = response.allHeaderFields[ChunnelCode];
        
        [self saveChunnelCode:chunnelCode sessionId:sessionId];
        
        success(str);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
        
    }];
}
#pragma mark 字典转参数
- (NSString *)parseDict2Param:(MOAParamModel *)param
{
    //    NSLog(@"%@", param.values);
    NSMutableString *sendData = [[NSMutableString alloc]initWithCapacity:50];
    [sendData appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [sendData appendString:@"<submit>"];
    if (param) {
        [sendData appendString:@"<fields>"];
        NSString *tmpKey = nil;
        for (NSString *key in param.paramNames) {
            [sendData appendString:@"<field>"];
            [sendData appendString:@"<name>"];
            [sendData appendString:@"<![CDATA["];
            if ([key isEqualToString:@"ID"]) {
                tmpKey = @"id";
            }else {
                tmpKey = key;
            }
            [sendData appendString:tmpKey];
            //            MOALog(@"key:%@",key);
            [sendData appendString:@"]]>"];
            [sendData appendString:@"</name>"];
            [sendData appendString:@"<value>"];
            [sendData appendString:@"<![CDATA["];
            NSString *value = param.values[key];
            [sendData appendString:[NSString stringWithFormat:@"%@", value]];
            [sendData appendString:@"]]>"];
            [sendData appendString:@"</value>"];
            [sendData appendString:@"</field>"];
        }
        
        [sendData appendString:@"</fields>"];
    }
    
    [sendData appendString:@"</submit>"];
    return sendData;
}

- (NSString *)setCookie:(NSString *)actionId
{
    NSString *cookie = [[NSString alloc]init];
    cookie = [cookie stringByAppendingString:@"device=iphone;system=j2me;curVersion=3.0;"];
    if (actionId) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *chunnelCode = [ud objectForKey:ChunnelCode];
        NSString *sessionId = [ud objectForKey:SessionId];
        cookie = [cookie stringByAppendingString:@"chunnelCode="];
        if (chunnelCode) {
            cookie = [cookie stringByAppendingString:chunnelCode];
        }
        if (![actionId isEqualToString:@"通讯录"]) {
            cookie = [cookie stringByAppendingString:@";actionId="];
            cookie = [cookie stringByAppendingString:actionId];
        }
        cookie = [cookie stringByAppendingString:@";JSESSIONID="];
        if (sessionId) {
            cookie = [cookie stringByAppendingString:sessionId];
        }
        else
        {
            cookie = [cookie stringByAppendingString:kDefaultCookie];
        }
        cookie = [cookie stringByAppendingString:@";sessionId="];
        
        if (sessionId) {
            cookie = [cookie stringByAppendingString:sessionId];
        }
        else
        {
            cookie = [cookie stringByAppendingString:kDefaultCookie];
        }
    }
    else
    {
        cookie = [cookie stringByAppendingString:@"hadLogo=true;logoVersion=1.0"];
    }

    return cookie;
}

-(void)saveChunnelCode:(NSString *)chunnelCode sessionId:(NSString *)sessionId
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:SessionId]) {
        [ud setObject:sessionId forKey:SessionId];
    }
    if (![ud objectForKey:ChunnelCode]) {
        [ud setObject:chunnelCode forKey:ChunnelCode];
    }
    [ud synchronize];
}
#pragma mark - 懒加载 -
- (MOAParamModel *)paramModel{
    if (!_paramModel) {
        _paramModel = [[MOAParamModel alloc] init];
    }
    return _paramModel;
}

@end
