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

#import "CRTextView.h"
#import "CRTwitterPlugIn.h"
#import "CRTwitterUtils.h"
#import <TDAppKit/TDAppKit.h>

@implementation CRTextView

- (void)dealloc {
    self.crDelegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark NSResponder

- (void)mouseDown:(NSEvent *)evt {
    NSUInteger i = [self characterIndexForInsertionAtPoint:[self convertPoint:[evt locationInWindow] fromView:nil]];

    id link = [self linkForCharacterIndex:i];

    // ok this is crap :(. but AFAICT it's the only way to get the exact behavior i want

    // if clicking a link, don't select the item
    if (link) {
        //[[self window] makeFirstResponder:self];
        [super mouseDown:evt];

    // for single click on the tweet text, handle the event (for possible text selection), but also select the item behind
    } else if (1 == [evt clickCount]) {
        TDListItem *li = (TDListItem *)[self superview];
        TDListView *lv = (TDListView *)[li superview];
        NSInteger i = [lv indexForItemAtPoint:[lv convertPoint:[evt locationInWindow] fromView:nil]];
        [lv setSelectedItemIndex:i];

        [[self window] makeFirstResponder:self];
        [super mouseDown:evt];
    
    // for double click, send the event to the TDListItem (and eventually the TDListView) for crDelegate handling
    } else {
        [[self superview] mouseDown:evt];
    }
}


// this is necessary to remove text selection in any previously selected CRTextViews in the list
- (BOOL)becomeFirstResponder {
    static CRTextView *sLastFirstResponder = nil;

    if (sLastFirstResponder) {
        NSRange zeroRange = { 0, 0 };
        [sLastFirstResponder setSelectedRange:zeroRange];
    }

    sLastFirstResponder = self;
    
    return [super becomeFirstResponder];
}


#pragma mark -
#pragma mark NSTextView

- (BOOL)shouldDrawInsertionPoint {
    return NO;
}


- (BOOL)displaysLinkToolTips {
    return YES;
}


- (void)clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSURL *URL = nil;
    if ([link isKindOfClass:[NSURL class]]) {
        URL = link;
    } else if ([link isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:link];
    } else {
        NSAssert(0, @"link should be a url or string");
    }
    
    if (URL) {
        if (crDelegate && [crDelegate respondsToSelector:@selector(textView:linkWasClicked:)]) {
            [crDelegate textView:self linkWasClicked:URL];
        }
    } else {
        NSLog(@"could not activate link: %@", link);
    }
}


- (NSDictionary *)linkTextAttributes {
    return CRLinkStatusAttributes();
}


- (NSDictionary *)typingAttributes {
    return CRDefaultStatusAttributes();
}


#pragma mark -
#pragma mark Public

- (NSURL *)linkForCharacterIndex:(NSUInteger)i {
    id link = nil;
    
    NSUInteger len = [[[self textStorage] string] length];
    if (i < len) {
        NSRange effectiveRange;
        NSDictionary *attributes = [[self textStorage] attributesAtIndex:i effectiveRange:&effectiveRange];
        
        link = [attributes valueForKey:NSLinkAttributeName];
    }
    
    NSURL *URL = nil;
    if ([link isKindOfClass:[NSURL class]]) {
        URL = link;
    } else if ([link isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:link];
    } else {
        // will return nil;
    }
    
    return URL;
}

@synthesize crDelegate;
@end
