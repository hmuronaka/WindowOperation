//
//  ViewController.h
//  WindowOperation
//
//  Created by Muronaka Hiroaki on 2013/02/25.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowsOperationClientProtocol.h"

@protocol ViewControllerDelegate;

@interface ViewController : UIViewController

@property IBOutlet UITextField* ipTextField;
@property IBOutlet UITextField* portTextField;
@property id<ViewControllerDelegate> delegate;
@property WindowsOperationClientProtocol* protocol;

@end


@protocol ViewControllerDelegate <NSObject>

@required
-(void)startedConnection:(ViewController*)controller;

@required
-(void)stoppedConnection:(ViewController*)controller;

@end