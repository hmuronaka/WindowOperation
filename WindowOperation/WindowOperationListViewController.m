//
//  WindowOperationListViewController.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/12.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "WindowOperationListViewController.h"
#import "StringUtils.h"

@interface WindowOperationListViewController ()

@property(nonatomic, strong) NSTimer* cycleTimer;
@property(nonatomic, strong) NSMutableArray* windowList;

@end

@implementation WindowOperationListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.windowList = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self request];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request
{
    if( self.protocol != nil )
    {
        WindowsOperationCommand* requestCommand = [self createGetWindowListCommand];
        [self.protocol request:requestCommand];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if( self.cycleTimer == nil) {
        self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                           target:self
                                                         selector:@selector(timeoutCycle:)
                                                         userInfo:nil
                                                          repeats:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if( self.cycleTimer != nil ) {
        [self.cycleTimer invalidate];
        self.cycleTimer = nil;
    }
}

-(void)timeoutCycle:(NSTimer*)sourceTimer
{
    [self request];
}

#pragma mark -- command --

-(WindowsOperationCommand*)createGetWindowListCommand
{
    WindowsOperationCommand* command = [[WindowsOperationCommand alloc] initWithName:@"@GetWindowList" data:@""];
    command.delegate = self;
    return command;
}

-(BOOL)response:(NSString *)commandName data:(NSString *)data code:(NSInteger)code
{
    if( [commandName compare:@"@GetWindowList"] == NSOrderedSame ) {
        NSLog(@"reponsed get window list");
        [self responseGetWindowList:data];
    } else if( [commandName compare:@"@TopWindow"] == NSOrderedSame ) {
        NSLog(@"reponsed top window");
        [self responseGetWindowList:data];
    } else {
        NSLog(@"Invalid Response Command!! %@", commandName);
    }
    
    return YES;
}

-(BOOL)responseGetWindowList:(NSString*)data {
    // window name list に変換する.
    NSArray* newWindowList = [NSMutableArray arrayWithArray:[self parseWindowListData:data]];
    if( ![newWindowList isEqualToArray:self.windowList] )
    {
        self.windowList = [NSMutableArray arrayWithArray:newWindowList];
        [self.tableView reloadData];
    }
    return YES;
}

-(NSArray*)parseWindowListData:(NSString*)data {

    return [StringUtils split:data delimiter:@";"];

}


#pragma mark -- uitableview delegate --

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Window List";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"listcount=%d", self.windowList.count);
    return self.windowList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"MyCell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:9.0f]];
    }
    NSString* windowName = [self.windowList objectAtIndex:indexPath.row];
    [cell.textLabel setText:windowName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* nameOfDoTopCommand = @"@TopWindow";
    NSString* windowName = [self.windowList objectAtIndex:indexPath.row];
    WindowsOperationCommand* doTopCommand = [[WindowsOperationCommand alloc] initWithName:nameOfDoTopCommand
                                                                                      data:windowName];
    doTopCommand.delegate = self;
    NSLog(@"TopWindow=%@", windowName);
    if( self.protocol != nil )
    {
        [self.protocol request:doTopCommand];
    }
}

@end
