//
//  ResponseMakerTests.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/13.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "ResponseMakerTests.h"
#import "ResponseMaker.h"

@implementation ResponseMakerTests

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

- (void)testInit
{
    ResponseMaker* maker = [[ResponseMaker alloc] initWithName:@"@getWindowList" data:@"" withCode:0];
    STAssertEquals([maker.commandName compare:@"@getWindowList"], NSOrderedSame, nil);
    STAssertEquals([maker.data compare:@""], NSOrderedSame, nil);
    STAssertEquals(maker.code, 0, nil);
}

- (void)testInit2
{
    ResponseMaker* maker = [[ResponseMaker alloc] initWithName:@"@getWindowList" data:@"" withCode:200];
    STAssertEquals([maker.commandName compare:@"@getWindowList"], NSOrderedSame, nil);
    STAssertEquals([maker.data compare:@""], NSOrderedSame, nil);
    STAssertEquals(maker.code, 200, nil);
}


- (void)testMake1
{
    ResponseMaker* maker = [[ResponseMaker alloc] initWithName:@"@getWindowList" data:@"" withCode:200];
    NSString* response = [maker make];
    STAssertNotNil(response, nil);
    STAssertEquals([response compare:@"@getWindowList;#200;;"], NSOrderedSame, response);
    
}

- (void)testMake2
{
    ResponseMaker* maker = [[ResponseMaker alloc] initWithName:@"@getWindowList" data:@"テスト" withCode:-1];
    NSString* response = [maker make];
    STAssertNotNil(response, nil);
    STAssertEquals([response compare:@"@getWindowList;#-1;テスト;"], NSOrderedSame, response);
}

- (void)testMake3
{
    ResponseMaker* maker = [[ResponseMaker alloc] initWithName:@"@getWindowList" data:@"@abc;defg;" withCode:-1];
    NSString* response = [maker make];
    STAssertNotNil(response, nil);
    STAssertEquals([response compare:@"@getWindowList;#-1;\\@abc\\;defg\\;;"], NSOrderedSame, response);
}

- (void)testMake4
{
    ResponseMaker* maker = [[ResponseMaker alloc] initWithName:@"@getWindowList"
                                                          data:@"@abc;\ndefg;" withCode:-1];
    NSString* response = [maker make];
    STAssertNotNil(response, nil);
    STAssertEquals([response compare:@"@getWindowList;#-1;\\@abc\\;\ndefg\\;;"], NSOrderedSame, response);
}


@end
