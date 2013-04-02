//
//  RequestTokenizerTests.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/12.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "RequestTokenizerTests.h"
#import "RequestTokenizer.h"

@implementation RequestTokenizerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInitRequestTokenizer
{
    RequestTokenizer* obj = [[RequestTokenizer alloc] initWithRequest:@"@getWindowList;#200;;"];
    STAssertEquals( [obj.request compare:@"@getWindowList;#200;;"], NSOrderedSame, nil);
}


- (void)testNext1
{
    RequestTokenizer* obj = [[RequestTokenizer alloc] initWithRequest:@"@getWindowList;#200;;"];
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@"@getWindowList"], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeCOMMAND, nil);
    
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@"200"], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeNUMBER, nil);
    
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@""], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeDATA, nil);
    
    STAssertFalse([obj nextToken], nil);
    STAssertEquals([obj.token compare:@""], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeEOF, nil);
}

- (void)testNext2
{
    RequestTokenizer* obj = [[RequestTokenizer alloc] initWithRequest:@"@getWindowList;#200;windowName1;"];
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@"@getWindowList"], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeCOMMAND, nil);
    
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@"200"], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeNUMBER, nil);
    
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@"windowName1"], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeDATA, nil);
    
    STAssertFalse([obj nextToken], nil);
    STAssertEquals([obj.token compare:@""], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeEOF, nil);
}

-(void)testNext3
{
    RequestTokenizer* obj = [[RequestTokenizer alloc] initWithRequest:@""];
    STAssertFalse([obj nextToken], nil);
    STAssertEquals([obj.token compare:@""], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeEOF, nil);
}

-(void)testNext4
{
    RequestTokenizer* obj = [[RequestTokenizer alloc] initWithRequest:@"abc"];
    STAssertTrue([obj nextToken], nil);
    STAssertEquals([obj.token compare:@"abc"], NSOrderedSame, nil);
    STAssertEquals(obj.tokenType, RequestTokenizerTokenTypeINVALID_TOKEN, nil);
}



@end
