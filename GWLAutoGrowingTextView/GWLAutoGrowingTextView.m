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
@property (nonatomic, strong) UILabel *placeholderLabel;
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
    if (!self.placeholderLabel) {
        UILabel *placeholderLabel = self.placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        [self insertSubview:placeholderLabel atIndex:0];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[placeholderLabel]" options:0 metrics:nil views:@{@"placeholderLabel": placeholderLabel}]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-10]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[placeholderLabel]" options:0 metrics:nil views:@{@"placeholderLabel": placeholderLabel}]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-16]];
    }
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self && constraint.secondItem == nil &&
            constraint.firstAttribute == NSLayoutAttributeHeight && constraint.relation == NSLayoutRelationEqual) {
            self.heightConstraint = constraint;
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gwl_inputTextDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.attributedText = [[NSAttributedString alloc] initWithString:placeholder attributes:self.typingAttributes];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)prepareForInterfaceBuilder
{
    if (!_placeholder) {
        _placeholder = @"Placeholder";
    }
    if (!_placeholderColor) {
        _placeholderColor = [UIColor colorWithWhite:0.27 alpha:1.0];
    }
}

- (void)gwl_inputTextDidChanged:(NSNotification *)notification
{
    self.placeholderLabel.hidden = self.text.length > 0;

    if (self.heightConstraint) {
        float newHeight = [self sizeThatFits:self.frame.size].height;
        self.heightConstraint.constant = newHeight;
        [self layoutIfNeeded];

        [self scrollRangeToVisible:self.selectedRange];
    }
}

@end
