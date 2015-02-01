//
//  JSMessageInputView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessageInputView.h"
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"
#import "UIColor+JSMessagesView.h"

#define SEND_BUTTON_WIDTH 78.0f

static id<JSMessageInputViewDelegate> __delegate;

@interface JSMessageInputView ()

- (void)setup;
- (void)setupTextView;

@end



@implementation JSMessageInputView

@synthesize sendButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate, JSMessageInputViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        __delegate = delegate;
        [self setup];
        self.textView.delegate = delegate;
    }
    return self;
}

+ (JSInputBarStyle)inputBarStyle
{
    if ([__delegate respondsToSelector:@selector(inputBarStyle)])
        return [__delegate inputBarStyle];
    
    return JSInputBarStyleDefault;
}

- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}
#pragma mark - Setup
- (void)setup
{
    self.image = [UIImage inputBar];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    [self setupTextView];
}

- (void)setupTextView
{
    CGFloat width = self.frame.size.width - SEND_BUTTON_WIDTH;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    // JeremyStone
    JSInputBarStyle style = [JSMessageInputView inputBarStyle];
    
    UITextView *inputTextView;
    
    if (style == JSInputBarStyleDefault)
    {
        inputTextView = [[JSMessageTextView  alloc] initWithFrame:CGRectMake(6.0f, 3.0f, width, height)];
        inputTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        inputTextView.backgroundColor = [UIColor redColor];
    }
    else
    {
        inputTextView = [[JSMessageTextView  alloc] initWithFrame:CGRectMake(8.0f, 6.0f, width, height)];
        inputTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        inputTextView.backgroundColor = [UIColor clearColor];

        inputTextView.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
        inputTextView.layer.borderWidth = 0.65f;
        inputTextView.layer.cornerRadius = 6.0f;
    }
    
    inputTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    inputTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
    inputTextView.keyboardType = UIKeyboardTypeDefault;
    inputTextView.returnKeyType = UIReturnKeyDefault;
    inputTextView.scrollEnabled = YES;
    inputTextView.scrollsToTop = NO;
    inputTextView.userInteractionEnabled = YES;
    inputTextView.textColor = [UIColor blackColor];
    inputTextView.font = [JSBubbleView font];
    inputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);

    
    self.textView = inputTextView;
    [self addSubview:self.textView];
    
    if (style == JSInputBarStyleDefault)
    {
        UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                    0.0f,
                                                                                    self.textView.frame.size.width + 2.0f,
                                                                                    self.frame.size.height)];
        inputFieldBack.image = [UIImage inputField];
        inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        inputFieldBack.backgroundColor = [UIColor clearColor];
        [self addSubview:inputFieldBack];
    }
}

#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if(sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    [self addSubview:self.sendButton];
}

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    int numLines = MAX([self.textView numberOfLinesOfText],
                       [self.textView.text numberOfLines]);

    NSLog(@"number line == %d",numLines);
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.textView.scrollEnabled = (numLines >= 4);
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 4.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}

@end