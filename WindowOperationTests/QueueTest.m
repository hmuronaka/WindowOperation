//
//  QueueTest.m
//  Cut&Loop
//
//  Created by MURONAKA HIROAKI on 2013/03/24.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import "QueueTest.h"
#import "Queue.h"

@implementation QueueTest

-(void)testInit
{
    NSInteger maxSize = 5;
    Queue* queue = [[Queue alloc] initWithMaxSize:maxSize];
    STAssertEquals(maxSize, queue.maxSize, nil);
    STAssertEquals(0, queue.nowSize, nil);
    STAssertNil([queue deque], nil);
}

-(void)testOne
{
    NSInteger maxSize = 5;
    Queue* queue = [[Queue alloc] initWithMaxSize:maxSize];
    NSString* obj1 = @"1";
    for(int i = 0; i < 100; i++)
    {
        [queue enque:obj1];
        STAssertEquals(1,queue.nowSize, nil);
        STAssertEquals([obj1 compare:[queue deque]], NSOrderedSame, nil);
        STAssertEquals(0, queue.nowSize, nil);
    }
}
-(void)testTwo
{
    NSInteger maxSize = 5;
    Queue* queue = [[Queue alloc] initWithMaxSize:maxSize];
    NSString* obj1 = @"1";
    NSString* obj2 = @"2";
    [queue enque:obj1];
    [queue enque:obj2];
    [queue clear];
    STAssertEquals(0, queue.nowSize, nil);
    STAssertNil([queue deque], nil);
    [queue enque:obj1];
    [queue enque:obj2];
    
    for(int i = 0; i < 100; i++)
    {
        STAssertEquals(2,queue.nowSize, nil);
        STAssertEquals([obj1 compare:[queue deque]], NSOrderedSame, nil);
        STAssertEquals(1, queue.nowSize, nil);
        [queue enque:obj1];
        STAssertEquals(2,queue.nowSize,nil);
        STAssertEquals([obj2 compare:[queue deque]], NSOrderedSame, nil);
        STAssertEquals(1, queue.nowSize, nil);
        [queue enque:obj2];
    }
}

-(void)testThree
{
    NSInteger maxSize = 5;
    Queue* queue = [[Queue alloc] initWithMaxSize:maxSize];
    
    for(int j = 0; j < 100; j++)
    {
        for(int i = 0; i < queue.maxSize; i++)
        {
            NSString* obj = [NSString stringWithFormat:@"%d", (i+1)];
            [queue enque:obj];
            STAssertEquals(i+1, queue.nowSize, nil);
        }
        STAssertFalse([queue enque:@"6"], nil);
        NSString* tmp = [queue deque];
        STAssertEquals([tmp compare:@"1"], NSOrderedSame, tmp);
        STAssertEquals(4, queue.nowSize, nil);
        STAssertTrue([queue enque:@"6"], nil);
        STAssertEquals(5, queue.nowSize, nil);
        
        tmp = [queue deque];
        STAssertEquals([tmp compare:@"2"], NSOrderedSame, tmp);
        tmp = [queue deque];
        STAssertEquals([tmp compare:@"3"], NSOrderedSame, tmp);
        tmp = [queue deque];
        STAssertEquals([tmp compare:@"4"], NSOrderedSame, tmp);
        tmp = [queue deque];
        STAssertEquals([tmp compare:@"5"], NSOrderedSame, tmp);
        tmp = [queue deque];
        STAssertEquals([tmp compare:@"6"], NSOrderedSame, tmp);
        STAssertNil([queue deque], nil);
    }
    
    
}



@end
