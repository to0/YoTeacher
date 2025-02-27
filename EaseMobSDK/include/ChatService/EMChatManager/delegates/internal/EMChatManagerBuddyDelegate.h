/*!
 @header EMChatManagerBuddyDelegate.h
 @abstract 添加好友,删除好友,接收到好友请求时的回调协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */
#import <Foundation/Foundation.h>
#import "EMChatManagerDelegateBase.h"
#import "IChatManager.h"

@class EMBuddy;
/*!
 @protocol
 @brief 添加好友,删除好友,接收到好友请求时的回调协议
 @discussion
 */
@protocol EMChatManagerBuddyDelegate <EMChatManagerDelegateBase>

@optional
/*!
 @method
 @brief 接收到好友请求时的通知
 @discussion
 @param username 发起好友请求的用户username
 @param message  收到好友请求时的say hello消息
 */
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message;

/*!
 @method
 @brief 好友请求被接受时的回调
 @discussion
 @param username 之前发出的好友请求被用户username接受了
 */
- (void)didAcceptedByBuddy:(NSString *)username;

/*!
 @method
 @brief 好友请求被拒绝时的回调
 @discussion
 @param username 之前发出的好友请求被用户username拒绝了
 */
- (void)didRejectedByBuddy:(NSString *)username;

/*!
 @method
 @brief 接受好友请求成功的回调
 @discussion
 @param username 登录用户接受了"username发过来的好友请求"成功的回调
 */
- (void)didAcceptBuddySucceed:(NSString *)username;

/*!
 @method
 @brief 登录的用户被好友从列表中删除了
 @discussion
 @param username 删除的好友username
 */
- (void)didRemovedByBuddy:(NSString *)username;

/*!
 @method
 @brief 通讯录信息发生变化时的通知
 @discussion
 @param buddyList 好友信息列表
 @param changedBuddies 修改了的用户列表
 @param isAdd (YES为新添加好友, NO为删除好友)
 */
- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd;

/*!
 @method
 @brief 好友分组信息发生变化时的通知
 @discussion
 @param buddyGroupList 好友分组信息
 @since 
 */
- (void)didUpdateBuddyGroupList:(NSArray *)buddyGroupList;

/*!
 @method
 @brief 好友上线和下线时的通知
 @discussion
 @param isOnline 好友信息列表
 @param username 修改了状态的用户
 */
- (void)didChangedOnlineStatus:(BOOL)isOnline
                      forBuddy:(NSString *)username;

@end
