//
//  ViewController.m
//  WindowOperation
//
//  Created by Muronaka Hiroaki on 2013/02/25.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "ViewController.h"
#import "WindowOperationListViewController.h"
#import "LatestUseFileViewController.h"
#import "WindowsOperationClientProtocol.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSString* path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSLog(@"%@", path);
    NSDictionary* settings = [NSDictionary dictionaryWithContentsOfFile:path];
    [self.ipTextField setText:[settings objectForKey:@"ipAddress"]];
    [self.portTextField setText:[settings objectForKey:@"port"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pressedConnect:(id)sender
{
    if( !self.protocol.isRunning )
    {
        [self start];
    }
    else
    {
        [self stop];
    }
}

-(void)start
{
    [self.protocol setTargetEndPoint:self.ipTextField.text
                                port:[self.portTextField.text intValue]];
    [self.protocol start];
    
    // plistへの書き込み、なぜかうまくいかないので調査中。
    NSString* path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [settings setObject:self.ipTextField.text forKey:@"ipAddress"];
    [settings setObject:self.portTextField.text forKey:@"port"];
    NSDictionary* dict = settings;
//    NSDictionary* plist = [NSDictionary dictionaryWithObject:settings forKey:@"Root"];
    NSString* error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if( plistData != nil )
    {
        [plistData writeToFile:path  atomically:YES];
    }
    else
    {
        NSLog(@"error=%@", error);
    }
//    if( ![dict writeToFile:path atomically:YES] )
//    {
//        NSLog(@"failed to write settings.plist");
//    }
    
    if( self.delegate != nil )
    {
        [self.delegate startedConnection:self];
    }
}

-(void)stop
{
    [self.protocol stop];
    
    if( self.delegate != nil )
    {
        [self.delegate stoppedConnection:self];
    }
}

@end
