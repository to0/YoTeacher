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

@interface ChatViewController : UIViewController

@property (nonatomic, strong) NSURL         *myAvatarURL;
@property (nonatomic, strong) NSURL         *chatterAvatarURL;
@property (nonatomic, strong) UIImage       *placeholderImage;

- (instancetype)initWithChatter:(NSString *)chatter;
- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (void)setTimer:(int)time;
- (void)removeTimer;

@end
