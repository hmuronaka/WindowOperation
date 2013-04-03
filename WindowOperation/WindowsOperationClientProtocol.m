//
//  WIndowsOperationClientProtocol.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/11.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "WindowsOperationClientProtocol.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "CommandTokenizer.h"
#import "CommandMaker.h"


@interface WindowsOperationClientProtocol()
{
    CFSocketContext context;
}

@property CFSocketRef udpClient;
@property CFRunLoopSourceRef source;
@property(nonatomic, strong) NSMutableArray* commandMap;
@property NSData* targetEndPoint;
@property(nonatomic) CFTimeInterval timeoutOfSend;

@end

@implementation WindowsOperationClientProtocol
@synthesize port = _port;
@synthesize ipAddress = _ipAddress;


#pragma mark --static callback--

static void MyClassSocketReceivedCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void* pData, void* pInfo)
{
    // 即座に Objective-C 形式のコールバックを呼ぶようにしています。
    WindowsOperationClientProtocol* owner = (__bridge WindowsOperationClientProtocol*)pInfo;
    [owner socketReceivedCallback:socket type:type address:address data:(__bridge NSData*)pData];
}

#pragma mark --initialize--

-(id)init
{
    self = [super init];
    if( self != nil ) {
        self.commandMap = [[NSMutableArray alloc] init];
        self.timeoutOfSend = 3;
    }
    return self;
}

#pragma mark --public methods--

-(BOOL)start
{
    if( self.udpClient != NULL ) {
        return NO;
    }
    
    // ソケットに設定するコンテキストを準備します。
    // version は必ず 0　を指定し、ここでは info に self を設定しています。
    context.version = 0;
    context.info = (__bridge void*)self;
    context.retain = NULL;
    context.release = NULL;
    context.copyDescription = NULL;
    
    // UDP ソケットを生成します。データを受信した時に呼び出すコールバック関数もここで指定します。
    self.udpClient = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketDataCallBack, (CFSocketCallBack)MyClassSocketReceivedCallback, &context);
    
    if (self.udpClient != NULL)
    {
        // UDP ソケットが生成できたら、続いてアドレスへのバインドを行います。
        CFDataRef address;
        struct sockaddr_in addr;
        
        // アドレスを設定する構造体 sockaddr_in を初期化しています。
        memset(&addr, 0, sizeof(struct sockaddr_in));
        
        // 待ち受けに使用するアドレスとポートを設定します。
        // 任意のアドレスで待ち受けたい場合は INADDR_ANY を sin_addr.s_addr に設定します。
        addr.sin_family = AF_INET;
        addr.sin_port = htons(self.port);
        addr.sin_addr.s_addr = htonl(INADDR_ANY);
        
        // 先ほどの sockaddr_in を使用して、ソケットに割り当てるアドレスデータを生成します。
        address = CFDataCreateWithBytesNoCopy(NULL, (UInt8*)&addr, sizeof(struct sockaddr_in), kCFAllocatorNull);
        
        // ソケットをバインドします。
        if (CFSocketSetAddress(self.udpClient, address) == kCFSocketSuccess)
        {
            // バインドに成功したら、CFRunLoop を使ってパケットが到着するのを待ちます。
            // ソケットから CFRunLoop に登録するための入力ソースを取得します。
            self.source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self.udpClient, 0);
            
            // ソケットの入力ソースをカレントランループに追加します。
            CFRunLoopAddSource(CFRunLoopGetCurrent(), self.source, kCFRunLoopCommonModes);
            
            return YES;
        }
        else
        {
            // バインドに失敗した場合は、ソケットの後始末を行います。
            CFSocketInvalidate(self.udpClient);
            CFRelease((self.udpClient));
            // ソケットの生成に失敗した場合の処理です。
            NSLog(@"socket bind error!!");
            return NO;
        }
    }
    else
    {
        // ソケットの生成に失敗した場合の処理です。
        NSLog(@"socket error!!");
    }
    return NO;
}

-(BOOL)stop {
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.source, kCFRunLoopCommonModes);
    CFSocketInvalidate(self.udpClient);
    CFRelease(self.udpClient);
    CFRelease(self.source);
    self.udpClient = nil;
    self.source = nil;
    
    NSLog(@"stopped protocol");
    return NO;
}

-(void)setTargetEndPoint:(NSString*)ipAddress port:(NSInteger)port
{
    _port = port;
    _ipAddress = ipAddress;
    
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(self.port);
    addr.sin_addr.s_addr = inet_addr([self.ipAddress UTF8String]);
    self.targetEndPoint = [NSData dataWithBytes:&addr length:sizeof(addr)];
}

-(BOOL)isRunning
{
    return self.udpClient != nil;
}


#pragma mark --request--
-(BOOL)request:(WindowsOperationCommand *)command {
    
    CommandMaker* maker = [[CommandMaker alloc] initWithName:command.name
                                                          data:command.data withCode:0];
    NSString* strData = [maker make];
    
    // byte列に変換する.
    NSData* byteDatas = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    if( self.udpClient != nil )
    {
        [self sendData:byteDatas];
        [self.commandMap addObject:command];
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma --sending--

-(void)sendData:(NSData*)data
{
    CFSocketError socketError = CFSocketSendData(self.udpClient,
                                                 (__bridge CFDataRef)self.targetEndPoint,
                                                 (__bridge CFDataRef)data,
                                                 self.timeoutOfSend);
    if( socketError != kCFSocketSuccess )
    {
        NSLog(@"send error!! %ld", socketError);
    }
}

#pragma --receiving--

// Objective-C 形式のコールバックメソッドでパケット受信の処理を行います。
- (void)socketReceivedCallback:(CFSocketRef)socket type:(CFSocketCallBackType)type address:(CFDataRef)address data:(NSData*)pData
{
    // byte列をNSStringに変換する。
    NSString* responseData = [[NSString alloc] initWithData:pData encoding:NSUTF8StringEncoding];
    
    // requestTokenizerでコマンド形式の文字列に変換する。
    CommandTokenizer* tokenizer = [[CommandTokenizer alloc] initWithRequest:responseData];
    
    NSString* commandName = nil;
    NSString* data = nil;
    NSInteger code = -1;
    [self tokenize:tokenizer outCommandName:&commandName outData:&data outCode:&code];
    
    // 各コマンドで処理を実施する。（デバイス側への反応もコマンド内で実装する。
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^() {
        WindowsOperationCommand* command = (WindowsOperationCommand*)[self searchCommand:commandName];
        if( command != nil ) {
            [command.delegate response:commandName data:data code:code];
            [self.commandMap removeObject:command];
        }
//        }];
}

#pragma -- command, tokenizer--

-(WindowsOperationCommand*)searchCommand:(NSString*)commandName {
    for ( WindowsOperationCommand* aCommand in self.commandMap) {
        if( [aCommand.name compare:commandName] == NSOrderedSame ) {
            return aCommand;
        }
    }
    return nil;
}

-(void)tokenize:(CommandTokenizer*)tokenizer outCommandName:(NSString**)commandName outData:(NSString**)data outCode:(NSInteger*)code
{
    while( [tokenizer nextToken] ) {
        switch(tokenizer.tokenType) {
            case CommandTokenizerTokenTypeCOMMAND:
                *commandName = tokenizer.token;
                break;
            case CommandTokenizerTokenTypeNUMBER:
                *code = [tokenizer.token intValue];
                break;
            case CommandTokenizerTokenTypeDATA:
                *data = tokenizer.token;
                break;
            default:
                NSLog(@"illiegal token!!");
        }
    }
}



@end