//
//  MasterViewController.m
//  SwipeAutoLayout
//
//  Created by Chi nguyen Vo on 4/26/14.
//  Copyright (c) 2014 Chi nguyen Vo. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "SwipeableCell.h"

@interface MasterViewController ()<SwipeableCellDelegate> {
    NSMutableArray *_objects;
}

@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //1
    _objects = [NSMutableArray array];
    
    //2
    NSInteger numberOfItems = 30;
    for (NSInteger i = 1; i <= numberOfItems; i++) {
        NSString *item = [NSString stringWithFormat:@"Longer Title Item #%d", i];
        [_objects addObject:item];
    }
    
    self.cellsCurrentlyEditing = [NSMutableSet new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.delegate = self;
    NSString *object = _objects[indexPath.row];
    cell.itemText = [object description];
    
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
//    cell.backgroundColor = [UIColor purpleColor];
//    cell.contentView.backgroundColor = [UIColor blueColor];
//    
//    for (UIView *view in cell.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            view.backgroundColor = [UIColor greenColor];
//        }
//    }
    
//#ifdef DEBUG
//    NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
//#endif
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - SwipeableCellDelegate

- (void)buttonOneActionForItemText:(NSString *)itemText {
    NSLog(@"In the delegate, Clicked button one for %@", itemText);
}

- (void)buttonTwoActionForItemText:(NSString *)itemText {
    NSLog(@"In the delegate, Clicked button two for %@", itemText);
}

- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}

- (BOOL)isAllowSwipeLeft:(UITableViewCell *)cell{
    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    if ([self.cellsCurrentlyEditing count] < 1) {
        return YES;
    }else if ([self.cellsCurrentlyEditing containsObject:currentEditingIndexPath]){
        return YES;
    }
    return NO;
}

@end
