//
//  RequestTokenizer.m
//  WindowOperation
//
//  Created by Muronaka Hiroaki on 2013/03/10.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "CommandTokenizer.h"

@implementation CommandTokenizer
@synthesize request = _request;
@synthesize token = _token;
@synthesize tokenType = _tokenType;
@synthesize position = _position;


#pragma mark -- initialize --

-(id)initWithRequest:(NSString*)request {
    
    self = [super init];
    if( self != nil) {
        _request = request;
        _position = 0;
        _token = @"";
        _tokenType = CommandTokenizerTokenTypeEMPTY;
    }
    
    return self;
}

#pragma mark -- tokenize --

-(BOOL)nextToken {
    
    if( self.position >= self.request.length) {
        _token = @"";
        _tokenType = CommandTokenizerTokenTypeEOF;
        return NO;
    }
    
    NSMutableString* tokenBuilder = [[NSMutableString alloc] init];
    unichar nowCh = [self nowChar];
    if( nowCh == '@')
    {
        _tokenType = CommandTokenizerTokenTypeCOMMAND;
        [tokenBuilder appendFormat:@"%C", nowCh];
        [self nextChar];
    }
    else if( nowCh == '#' )
    {
        _tokenType = CommandTokenizerTokenTypeNUMBER;
        [self nextChar];
    }
    else
    {
        _tokenType = CommandTokenizerTokenTypeDATA;
    }
    
    BOOL isEnd = NO;
    
    
    
    while( self.position < self.request.length && !isEnd) {
        nowCh = [self nowChar];
        // 文字列中の;#@は\\でエスケープシーケンスが必要.
        if( nowCh == '\\' ) {
            unichar peekCh = [self peekChar];
            switch(peekCh) {
                case '\\':
                case ';':
                case '#':
                case '@':
                        // エスケープシーケンスの場合は、最初の\\を取り除いてtokenに追加する。
                        [tokenBuilder appendFormat:@"%C", peekCh];
                        [self nextChar];
                        break;
                default:
                    [tokenBuilder appendFormat:@"%C", nowCh];
                    break;
            }
        }
        else if( nowCh != ';' && nowCh != '\0')
        {
            [tokenBuilder appendFormat:@"%C", nowCh];
        }
        else
        {
            isEnd = YES;
        }
        [self nextChar];
    }
    if( !isEnd ) {
        _tokenType = CommandTokenizerTokenTypeINVALID_TOKEN;
    }
    _token = tokenBuilder;
    return YES;
}

#pragma mark -- get character --


-(unichar)nowChar {
    if( self.position < self.request.length ) {
        return [self.request characterAtIndex:self.position];
    }
    else
    {
        return '\0';
    }
}

-(unichar)peekChar {
    _position++;
    unichar ch = [self nowChar];
    _position--;
    return ch;
}

-(unichar)nextChar {
    _position++;
    return [self nowChar];
}

@end
