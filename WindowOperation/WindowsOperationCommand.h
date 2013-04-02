//
//  WindowsOperationCommand.h
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/11.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WindowOperationCommandDelegate;


//送信コマンドオブジェクト
@interface WindowsOperationCommand : NSObject

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* data;

// 送信コマンドの応答を受信した際に呼び出される。
@property(nonatomic,weak) id<WindowOperationCommandDelegate> delegate;

-(id)initWithName:(NSString*)commandName data:(NSString*)data;


@end

@protocol WindowOperationCommandDelegate

-(BOOL)response:(NSString*)commandName data:(NSString*)data code:(NSInteger)code;

@end
