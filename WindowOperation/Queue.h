//
//  Queue.h
//  Cut&Loop
//
//  Created by MURONAKA HIROAKI on 2013/03/24.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 配列を用いたサイズ固定長のキュー
// NSMutableArrayを固定長の循環バッファとして利用する.
// マルチスレッドには対応していない。
//
// 使い方
//void foo() {
//    // 30件のキューを作成.
//    Queue* queue = [[Queue alloc] initWithMaxSize:30];
//     // 最大30件まで追加可能
//    while( [queue enque:@"A"] ) {
//        ;
//    }
//    // 全ての要素をとる.
//    NSString* a = nil;
//    while( (a = [queue deque]) != nil ) {
//        ;
//    }
//}
//
@interface Queue : NSObject

@property(nonatomic, readonly) NSInteger maxSize;
@property(nonatomic, readonly) NSInteger nowSize;

-(id)initWithMaxSize:(NSInteger)maxSize;
-(id)deque;
// nilを追加することはできない.
-(BOOL)enque:(id)obj;
-(void)clear;

@end
