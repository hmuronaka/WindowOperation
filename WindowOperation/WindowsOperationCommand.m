//
//  WindowsOperationCommand.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/11.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "WindowsOperationCommand.h"

@implementation WindowsOperationCommand
@synthesize name = _name;
@synthesize data = _data;

-(id)initWithName:(NSString*)commandName data:(NSString*)data
{
    self = [super init];
    if( self != nil ) {
        _name = commandName;
        _data = data;
    }
    return self;
    
}

@end
