//
//  SwipeableCell.h
//  SwipeAutoLayout
//
//  Created by Chi nguyen Vo on 4/26/14.
//  Copyright (c) 2014 Chi nguyen Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeableCellDelegate <NSObject>
- (void)buttonOneActionForItemText:(NSString *)itemText;
- (void)buttonTwoActionForItemText:(NSString *)itemText;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
- (BOOL)isAllowSwipeLeft:(UITableViewCell *)cell;
@end

@interface SwipeableCell : UITableViewCell

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *myTextLabel;
@property (nonatomic, strong) NSString *itemText;

- (void)openCell;

@end
