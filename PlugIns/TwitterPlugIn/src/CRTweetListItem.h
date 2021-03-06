//  Copyright 2009 Todd Ditchendorf
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <TDAppKit/TDListItem.h>

@class CRTweet;
@class CRTextView;

@interface CRTweetListItem : TDListItem {
    NSButton *avatarButton;
    NSButton *usernameButton;
    CRTextView *textView;
    CRTweet *tweet;
    
    id target;
    SEL action;
    NSInteger tag;
    BOOL selected;
    
    BOOL hasAvatar;
}

+ (NSString *)reuseIdentifier;
+ (NSDictionary *)textAttributes;
+ (CGFloat)defaultHeight;
+ (CGFloat)minimumHeight;
+ (CGFloat)minimumWidthForDrawingAgo;
+ (CGFloat)minimumWidthForDrawingText;
+ (CGFloat)horizontalTextMargins;

@property (nonatomic, retain) NSButton *avatarButton;
@property (nonatomic, retain) NSButton *usernameButton;
@property (nonatomic, retain) CRTextView *textView;
@property (nonatomic, retain) CRTweet *tweet;
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@end
