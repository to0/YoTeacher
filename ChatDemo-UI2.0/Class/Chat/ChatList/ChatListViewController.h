/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChatListViewController : BaseViewController<UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) UITableView           *tableView;
@property (strong, nonatomic) UIImage               *avatar;
@property (nonatomic, strong) NSString              *nickname;
@property (strong, nonatomic) NSString              *apiHost;
@property (strong, nonatomic) NSString              *urlHost;

- (void)refreshDataSource;
- (void)releaseDataSource;

- (void)networkChanged:(EMConnectionState)connectionState;

@end
