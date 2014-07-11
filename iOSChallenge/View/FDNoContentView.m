//
// Created by Alexandre Santana on 10/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import "FDNoContentView.h"
#import "KeepLayout.h"
#import "FDModelFacade.h"

static NSString *const kURL = @"http://ckl.io/challenge/";

@implementation FDNoContentView

- (id)init
{
    self = [super init];
    if (self) {
        [self loadView];
    }

    return self;
}

- (void)loadView
{
    self.messageLabel = [[UILabel alloc] init];
    [self.messageLabel setText:NSLocalizedString(@"DEFAULT_MESSAGE", nil)];
    [self.messageLabel setTextColor:[UIColor blackColor]];
    [self.messageLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.messageLabel];

    [self.messageLabel keepVerticallyCentered];
    [self.messageLabel keepHorizontallyCentered];

    self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.retryButton setTitle:NSLocalizedString(@"BUTTON_RETRY", nil) forState:UIControlStateNormal];
    [self.retryButton setBackgroundColor:[UIColor blueColor]];
    [self.retryButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.retryButton addTarget:self.delegate action:@selector(didButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.retryButton];

    self.retryButton.keepTopOffsetTo(self.messageLabel).equal = KeepRequired(20);
    self.retryButton.keepVerticalAlignTo(self.messageLabel).equal = KeepRequired(0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end