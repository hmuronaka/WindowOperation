//
//  StringUtilsTests.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/13.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "StringUtilsTests.h"
#import "StringUtils.h"

@implementation StringUtilsTests

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

- (void)testReplaceString1
{
    NSMutableString* str = [NSMutableString stringWithString:@"abc"];
    STAssertEquals([str compare:@"abc"], NSOrderedSame, nil);
    
    str = [NSMutableString stringWithString:@"ab\\c"];
    [str replaceOccurrencesOfString:@"b" withString:@"x" options:NSLiteralSearch range:
     NSMakeRange(0, str.length)];
    STAssertEquals([str compare:@"ax\\c"], NSOrderedSame, str);
    
    str = [NSMutableString stringWithString:@"ab\\c"];
    [str replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSLiteralSearch range:
     NSMakeRange(0, str.length)];
    STAssertEquals([str compare:@"ab\\\\c"], NSOrderedSame, str);

    
    str = [NSMutableString stringWithString:@"ab\\c\\"];
    [str replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSLiteralSearch range:
     NSMakeRange(0, str.length)];
    STAssertEquals([str compare:@"ab\\\\c\\\\"], NSOrderedSame, str);

}

-(void)testRangeFromString
{
    NSRange range = NSRangeFromString(@"0,3");
    STAssertEquals(range.location, 0u, nil);
    STAssertEquals(range.length, 3u, nil);
}

-(void)testEscapeSequence
{
    NSString* str = [StringUtils replaceEscapeSeq:@"abc"];
    NSString* expect = @"abc";
    STAssertEquals([str compare:expect], NSOrderedSame, str);
    
    str = [StringUtils replaceEscapeSeq:@"abcd;efgh;"];
    expect = @"abcd\\;efgh\\;";
    STAssertEquals([str compare:expect], NSOrderedSame, str);
    
    str = [StringUtils replaceEscapeSeq:@"@abcd@efgh@"];
    expect = @"\\@abcd\\@efgh\\@";
    STAssertEquals([str compare:expect], NSOrderedSame, str);

    str = [StringUtils replaceEscapeSeq:@"\\abcd\\efgh\\"];
    expect = @"\\\\abcd\\\\efgh\\\\";
    STAssertEquals([str compare:expect], NSOrderedSame, str);

}

-(void)testSplit
{
    NSString* str = @"abc;def";
    NSArray* expect = [NSArray arrayWithObjects:@"abc",@"def",nil];
    NSArray* result = [StringUtils split:str delimiter:@";"];
    STAssertEquals(result.count, 2u, nil);
    for(int i = 0; i < result.count; i++) {
        NSString* expectStr = [expect objectAtIndex:i];
        NSString* resultStr = [result objectAtIndex:i];
        STAssertEquals([expectStr compare:resultStr], NSOrderedSame, resultStr);
    }

    str = @"abc;def;";
    expect = [NSArray arrayWithObjects:@"abc",@"def",nil];
    result = [StringUtils split:str delimiter:@";"];
    STAssertEquals(result.count, 2u, nil);
    for(int i = 0; i < result.count; i++) {
        NSString* expectStr = [expect objectAtIndex:i];
        NSString* resultStr = [result objectAtIndex:i];
        STAssertEquals([expectStr compare:resultStr], NSOrderedSame, resultStr);
    }

    str = @"abc";
    expect = [NSArray arrayWithObjects:@"abc",nil];
    result = [StringUtils split:str delimiter:@";"];
    STAssertEquals(result.count, 1u, nil);
    for(int i = 0; i < result.count; i++) {
        NSString* expectStr = [expect objectAtIndex:i];
        NSString* resultStr = [result objectAtIndex:i];
        STAssertEquals([expectStr compare:resultStr], NSOrderedSame, resultStr);
    }


}

-(void)testRegExp
{
    NSRegularExpression* regexp = [NSRegularExpression regularExpressionWithPattern:@";" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString* target = @"abc;def";
    NSArray* results = [regexp matchesInString:target
                                      options:0 
                                        range:NSMakeRange(0, target.length)];
    
    STAssertEquals(results.count, 1u, nil);
    NSTextCheckingResult* range = [results objectAtIndex:0];
    STAssertEquals(range.range.location, 3u, nil);
    STAssertEquals(range.range.length,1u, nil);

    NSError* error = nil;
    regexp = [NSRegularExpression regularExpressionWithPattern:@"[^\\\\];" options:0 error:&error];
    NSLog(@"error @%@", error);
    
    target = @"abc\\;def;ghi";
    results = [regexp matchesInString:target
                                      options:0
                                      range:NSMakeRange(0, target.length)];
    
    STAssertEquals(results.count, 1u, nil);
    range = [results objectAtIndex:0];
    STAssertEquals(range.numberOfRanges, 1u, nil);
    STAssertEquals(range.range.location, 7u, nil); // fになる.
    STAssertEquals(range.range.length,2u, nil); // [^\\\\];になる.
    
    int position = 0;
    NSString* aText = [target
                       substringWithRange:
                       NSMakeRange(position, range.range.location + 1 - position)];
    STAssertEquals([aText compare:@"abc\\;def"], NSOrderedSame, aText);
}

-(void)testRegExpMatch {
    NSError* error = nil;
    NSRegularExpression* regexp =
        [NSRegularExpression regularExpressionWithPattern:@"[^\\\\];"
        options:0 error:&error];
    NSString* target = @"abc\\;def;ghi";
    NSArray* results = [regexp matchesInString:target
                               options:0
                               range:NSMakeRange(0, target.length)];

    
    int i = 0;
    STAssertTrue( results.count != 0, nil);
    for(NSTextCheckingResult* result in results)
    {
        STAssertTrue(result.numberOfRanges != 0, @"%d", i);
        for(int j = 0; j < result.numberOfRanges; j++)
        {
            NSRange range = [result rangeAtIndex:j];
            NSLog(@"i=%d, j=%d, loc=%d, len=%d", i, j, range.location, range.length);
        }
        ++i;
    }
}

@end
