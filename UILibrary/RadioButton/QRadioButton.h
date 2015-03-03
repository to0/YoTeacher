//
//  EIRadioButton.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRadioButtonDelegate;

@interface QRadioButton : UIButton {
    NSString *_groupId;
    BOOL _checked;
    id<QRadioButtonDelegate> __unsafe_unretained _delegate;
}

@property(nonatomic, assign) id<QRadioButtonDelegate> delegate;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, assign) NSInteger selectedValue;
@property(nonatomic, assign) BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;
- (void)addToGroup;

@end

@protocol QRadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId;

@end
