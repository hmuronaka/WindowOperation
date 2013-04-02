//
//  LatestUseFileViewController.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/16.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "LatestUseFileViewController.h"
#import "StringUtils.h"

@interface LatestUseFileViewController ()

// 前回受信したファイル一覧の内容。
@property(nonatomic, strong) NSArray* fileArray;

@property(nonatomic, strong) NSTimer* cycleTimer;

@end

@implementation LatestUseFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fileArray = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestGetMostRecentlyFiles];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    if( self.cycleTimer == nil ) {
        self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timeoutCycle) userInfo:nil repeats:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if( self.cycleTimer != nil )
    {
        [self.cycleTimer invalidate];
        self.cycleTimer = nil;
    }
}

-(void)timeoutCycle
{
    [self requestGetMostRecentlyFiles];
}

-(void)requestGetMostRecentlyFiles
{
    WindowsOperationCommand* requestCommand = [self createRequestCommand];
    
    if( self.protocol == nil ) {
        NSLog(@"protocol is nil!!");
    }
    else {
        [self.protocol request:requestCommand];
    }
}


#pragma mark -- process command

-(WindowsOperationCommand*)createRequestCommand
{
    NSString* countOfToGetFile = @"20";
    WindowsOperationCommand* command = [[WindowsOperationCommand alloc] initWithName:@"@GetMostRecentlyFiles" data:countOfToGetFile];
    command.delegate = self;
    return command;
}

-(BOOL)response:(NSString *)commandName data:(NSString *)data code:(NSInteger)code {
    if( [commandName compare:@"@GetMostRecentlyFiles"] == NSOrderedSame )
    {
        NSArray* newFileArray = [self parseData:data];
        if( ![self.fileArray isEqualToArray:newFileArray] )
        {
            self.fileArray = newFileArray;
            [self.tableView reloadData];
        }
    }
    else if( [commandName compare:@"@OpenFile"] == NSOrderedSame )
    {
        [self requestGetMostRecentlyFiles];
    }
    NSLog(@"received %@", commandName);
    return YES;
}

-(NSArray*)parseData:(NSString*)data {
    return [StringUtils split:data delimiter:@";"];
}

#pragma mark -- process table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Files";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const mycellId = @"LatestUseFileViewControllerCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:mycellId];
    if( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mycellId];
        [cell.textLabel setFont:[UIFont systemFontOfSize:9.0f]];
    }
    NSString* fileName = [self.fileArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:fileName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* fileName = [self.fileArray objectAtIndex:indexPath.row];
    WindowsOperationCommand* requestCommand = [[WindowsOperationCommand alloc] initWithName:@"@OpenFile" data:fileName];
    requestCommand.delegate = self;
    
    if( self.protocol != nil )
    {
        [self.protocol request:requestCommand];
    }
}



@end
