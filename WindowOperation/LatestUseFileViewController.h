//
//  LatestUseFileViewController.h
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/16.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowsOperationClientProtocol.h"


// 最近利用したファイル一覧を取得する.
// 選択されたファイルを開く.
@interface LatestUseFileViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, WindowOperationCommandDelegate>

@property(nonatomic, strong) UITableView* IBOutlet tableView;
@property(nonatomic, strong) WindowsOperationClientProtocol* protocol;

@end
