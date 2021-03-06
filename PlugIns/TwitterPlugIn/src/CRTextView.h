//  Copyright 2010 Todd Ditchendorf
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

#import <Cocoa/Cocoa.h>

@class CRTextView;

@protocol CRTextViewDelegate <NSObject>
- (void)textView:(CRTextView *)tv linkWasClicked:(NSURL *)URL;
@end

@interface CRTextView : NSTextView {
    id <CRTextViewDelegate>crDelegate;
}

- (NSURL *)linkForCharacterIndex:(NSUInteger)i;

@property (nonatomic, assign) id <CRTextViewDelegate>crDelegate;
@end
