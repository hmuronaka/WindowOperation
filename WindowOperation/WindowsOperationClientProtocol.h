//
//  WIndowsOperationClientProtocol.h
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/11.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WindowsOperationCommand.h"

// Windows制御用プロトコルの実装
@interface WindowsOperationClientProtocol : NSObject

// 送信先ポート
@property(readonly) int port;
@property(readonly) BOOL isRunning;
// 送信先ＩＰアドレス　兼　受信ポート
@property(nonatomic, readonly) NSString* ipAddress;

-(id)init;
-(BOOL)start;
-(BOOL)stop;
-(BOOL)request:(WindowsOperationCommand*)command;
-(void)setTargetEndPoint:(NSString*)ipAddress port:(NSInteger)port;


@end
