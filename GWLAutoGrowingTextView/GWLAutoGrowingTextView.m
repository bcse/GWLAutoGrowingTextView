//
//  GWLAutoGrowingTextView.m
//  GWLAutoGrowingTextViewDemo
//
//  Created by bcse on 2015/6/6.
//  Copyright (c) 2015 Grey Lee. All rights reserved.
//

#import "GWLAutoGrowingTextView.h"

@interface GWLAutoGrowingTextView ()
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@end

@implementation GWLAutoGrowingTextView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gwl_inputTextDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.relation == NSLayoutRelationEqual) {
            self.heightConstraint = constraint;
            break;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gwl_inputTextDidChanged:(NSNotification *)notification
{
    if (self.heightConstraint) {
        float newHeight = [self sizeThatFits:self.frame.size].height;
        self.heightConstraint.constant = newHeight;
        [self layoutIfNeeded];

        [self scrollRangeToVisible:self.selectedRange];
    }
}

@end
