//
//  CRNetTool.h
//  WCR-MOA
//
//  Created by wcr－dev on 2016/12/28.
//  Copyright © 2016年 Alijoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRNetTool : NSObject
- (CRNetTool *)sharedInstance;

+ (CRNetTool *)sharedInstance;

- (void)Post:(NSString *)url dict:(NSDictionary *)dict paramesArr:(NSArray *)arr actionId:(NSString *)actionId  success:(void (^)(id data))success fail:(void (^)(NSError * error))fail;

- (NSString *)setCookie:(NSString *)actionId;
@end
