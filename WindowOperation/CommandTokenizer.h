//
//  CommandTokenizer.h
//  WindowOperation
//
//  Created by Muronaka Hiroaki on 2013/03/10.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>


// トークンの種別
typedef enum tagCommandTokenizerTokenType
{
    // nextTokenの結果、空文字、初期状態
    CommandTokenizerTokenTypeEMPTY,
    // nextTokenの結果、@で始まる文字列はコマンド名
    CommandTokenizerTokenTypeCOMMAND,
    // nextTokenの結果、#で始まる文字列は数値
    CommandTokenizerTokenTypeNUMBER,
    // @#以外の文字列はデータ
    CommandTokenizerTokenTypeDATA,
    // nextTokenが不正のとき
    CommandTokenizerTokenTypeINVALID_TOKEN,
    // nextTokenの結果、すべての文字列を取り出したときの値
    CommandTokenizerTokenTypeEOF
}CommandTokenizerTokenType;


// 受信したコマンド文字列を解析するトークンナイザ
@interface CommandTokenizer : NSObject

// 解析対象文字列
@property(nonatomic, readonly) NSString* request;
// nextTokenの結果の１トークン
@property(nonatomic, readonly) NSString* token;
// tokenの種別
@property(nonatomic, readonly) CommandTokenizerTokenType tokenType;
// requestの現在位置
@property(nonatomic, readonly) NSInteger position;

-(id)initWithRequest:(NSString*)request;
-(BOOL)nextToken;


@end