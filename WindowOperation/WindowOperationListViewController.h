//
//  WindowOperationListViewController.h
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/12.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowsOperationClientProtocol.h"
#import "WindowsOperationCommand.h"


// Windowsに表示されているウィンドウ名一覧を取得し、
// 選択されたWindowをデスクトップの最前面にする。
@interface WindowOperationListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate, WindowOperationCommandDelegate>

@property(nonatomic, weak) WindowsOperationClientProtocol* protocol;

@property(nonatomic, strong) IBOutlet UITableView* tableView;

@end
