//
// Created by Alexandre Santana on 10/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Delegate to handle the press of a button
*/
@protocol FDNoContentViewDelegate <NSObject>

- (void)didButtonPressed:(UIButton *)sender;

@end

/**
* View to show the errors when there's no content
*/
@interface FDNoContentView : UIView

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *retryButton;
@property (assign) id<FDNoContentViewDelegate> delegate;
@end