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
@property (nonatomic) UILabel *placeholderLabel;
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
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.placeholderLabel.font = self.font;
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.placeholderLabel];

        self.placeholderLabel.frame = CGRectMake(5, 8, self.frame.size.width - 5 * 2, self.frame.size.height - 8 * 2);
        self.placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = YES;
    }

    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.relation == NSLayoutRelationEqual) {
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
    self.placeholderLabel.text = placeholder;
    CGSize textSize = [self.placeholderLabel sizeThatFits:CGSizeMake(self.frame.size.width - self.placeholderLabel.frame.origin.x * 2, self.frame.size.width - self.placeholderLabel.frame.origin.y * 2)];
    self.placeholderLabel.frame = CGRectMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y, self.placeholderLabel.frame.size.width, textSize.height);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
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
