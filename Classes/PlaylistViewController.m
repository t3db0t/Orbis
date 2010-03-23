//
//  PlaylistViewController.m
//  Orbis
//
//  Created by Ted Hayes on 3/15/10.
//  Copyright 2010 Limina.Studio. All rights reserved.
//

#import "PlaylistViewController.h"


@implementation PlaylistViewController

- (void)viewDidLoad {
	[self retain];
    [super viewDidLoad];
	NSLog(@"PlaylistViewController::viewDidLoad view: %@", self.view);
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//Initialize the array.
	playlist = [[NSMutableArray alloc] init];
	
	//Add items
	[playlist addObject:@"Iceland"];
	[playlist addObject:@"Greenland"];
	[playlist addObject:@"Switzerland"];
	[playlist addObject:@"Norway"];
	[playlist addObject:@"New Zealand"];
	[playlist addObject:@"Greece"];
	[playlist addObject:@"Rome"];
	[playlist addObject:@"Ireland"];
	[playlist addObject:@"Iceland"];
	[playlist addObject:@"Greenland"];
	[playlist addObject:@"Switzerland"];
	[playlist addObject:@"Norway"];
	[playlist addObject:@"New Zealand"];
	[playlist addObject:@"Greece"];
	[playlist addObject:@"Rome"];
	[playlist addObject:@"Ireland"];
	[playlist addObject:@"Iceland"];
	[playlist addObject:@"Greenland"];
	[playlist addObject:@"Switzerland"];
	[playlist addObject:@"Norway"];
	[playlist addObject:@"New Zealand"];
	[playlist addObject:@"Greece"];
	[playlist addObject:@"Rome"];
	[playlist addObject:@"Ireland"];
	
	NSLog(@"mainViewController: %@", mainViewController);
	
	NSLog(@"PlaylistViewController viewDidLoad finished");
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	//NSLog(@"viewDidAppear: animated:%@", animated?@"YES":@"NO");
	NSIndexPath *initPath = [NSIndexPath indexPathForRow:(NSUInteger)3 inSection:(NSUInteger)0];
	// select current item
	[self.tableView selectRowAtIndexPath:initPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	NSLog(@"selected row: %d",[[self.tableView indexPathForSelectedRow] row]);
	UITableViewCell	*currentCell = [self.tableView cellForRowAtIndexPath:initPath];
	[currentCell setHighlighted:YES animated:YES];
	NSLog(@"current cell: %@", currentCell);
	
	//NSLog(@"visible cells: %@", [self.tableView visibleCells]);
	//[self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(NSUInteger)4 inSection:(NSUInteger)0]];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [playlist count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSString *cellValue = [playlist objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	cell.detailTextLabel.text = @"Artist Name";
	cell.showsReorderControl = YES;
	
    return cell;
}
/*
 - (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;	
 }
 */

// Perform the re-order
-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	NSString *title = [playlist objectAtIndex:[oldPath row]];
	[playlist removeObjectAtIndex:[oldPath row]];
	[playlist insertObject:title atIndex:[newPath row]];
}

// Handle deletion
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	printf("About to delete item %d\n", [indexPath row]);
	[playlist removeObjectAtIndex:[indexPath row]];
	[self.tableView reloadData];
}	 

- (void) deselect
{
	NSLog(@"deselect");
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSLog(@"Touched on item %d\n", [indexPath row]);
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)dealloc {
	NSLog(@"dealloc PlaylistViewController");
	[playlist release];
    [super dealloc];
}

@end

