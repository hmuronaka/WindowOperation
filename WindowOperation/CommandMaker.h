//
//  CommandMaker.h
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/12.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>


// コマンド文字列を作成するためのクラス
@interface CommandMaker : NSObject

// コマンド名称 @から始める事
@property(nonatomic, readonly) NSString* commandName;
// データ文字列
@property(nonatomic, readonly) NSString* data;
// コマンドの結果などを示すコード
@property(nonatomic, readonly) NSInteger code;

-(id)initWithName:(NSString*)commandName data:(NSString*)data withCode:(NSInteger)code;
-(NSString*)make;

@end
