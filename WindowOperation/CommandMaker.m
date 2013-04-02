//
//  CommandMaker.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/12.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "CommandMaker.h"
#import "StringUtils.h"

@implementation CommandMaker
@synthesize commandName = _commandName;
@synthesize data = _data;
@synthesize code = _code;

-(id)initWithName:(NSString *)commandName data:(NSString *)data withCode:(NSInteger)code {
    self = [super init];
    if( self != nil ) {
        _commandName = commandName;
        _data = data;
        _code = code;
    }
    return self;
}

-(NSString*)make {
    
    NSMutableString* builder = [[NSMutableString alloc] init];
    [builder appendString:self.commandName];
    [builder appendString:@";"];
    [builder appendString:@"#"];
    [builder appendFormat:@"%d",self.code];
    [builder appendString:@";"];
    
    NSString* editedData = [StringUtils replaceEscapeSeq:self.data];
    [builder appendString:editedData];
    [builder appendString:@";"];
    
    return builder;
}

@end
