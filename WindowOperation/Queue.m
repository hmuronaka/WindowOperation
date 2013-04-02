//
//  Queue.m
//  Cut&Loop
//
//  Created by MURONAKA HIROAKI on 2013/03/24.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import "Queue.h"

@interface Queue()

// [firstIndex, lastIndex)
// 次の読み出し位置.
@property(nonatomic) NSInteger readIndex;
// 次の書き込み位置.
@property(nonatomic) NSInteger writeIndex;
@property(nonatomic, strong) NSMutableArray* buffer;

@end

@implementation Queue
@synthesize nowSize = _nowSize;
@synthesize maxSize = _maxSize;

-(id)initWithMaxSize:(NSInteger)maxSize
{
    self = [super init];
    if( self != nil ) {
        _nowSize = 0;
        _maxSize = maxSize;
        self.readIndex = 0;
        self.writeIndex = 0;
        self.buffer = [[NSMutableArray alloc] initWithCapacity:self.maxSize];
//        [self fillArray:self.buffer withObj:nil count:self.maxSize];
    }
    return self;
}

//-(void)fillArray:(NSMutableArray*)array withObj:(id)obj count:(NSInteger)count
//{
//    [array removeAllObjects];
//    for(int i = 0; i < count; i++) {
//        [array addObject:obj];
//    }
//}

-(BOOL)enque:(id)obj
{
    if( self.nowSize >= self.maxSize ) {
        return NO;
    }
    [self.buffer setObject:obj atIndexedSubscript:self.writeIndex];
    _nowSize++;
    self.writeIndex = [self nextIndex:self.writeIndex];
    return YES;
}

-(id)deque
{
    if( self.nowSize == 0 ) {
        return nil;
    }
    id result = [self.buffer objectAtIndex:self.readIndex];
    _nowSize--;
    self.readIndex = [self nextIndex:self.readIndex];
    return result;
}

-(void)clear {
//    [self fillArray:self.buffer withObj:nil count:self.maxSize];
    [self.buffer removeAllObjects];
    _nowSize = 0;
    self.readIndex = 0;
    self.writeIndex = 0;
}


-(NSInteger)nextIndex:(NSInteger)index {
    return (index + 1) % self.maxSize;
}
@end

