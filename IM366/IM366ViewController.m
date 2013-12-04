//
//  IM366ViewController.m
//  IM366
//
//  Created by Kuanting Chen on 10/31/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "IM366ViewController.h"
#import "TableCell.h"

@interface IM366ViewController ()
{
    NSDictionary *IM369Dictionary;
    NSMutableArray *detail;
}

@end

@implementation IM366ViewController

@synthesize dataSearchBar = _dataSearchBar;
@synthesize searchDetails = _searchDetails;
@synthesize names = _names;

- (id)init
{
    NSLog( @"ya got i3333t2222");
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 10; i++)
        {
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad{
    NSLog( @"ya got it2222");
    [super viewDidLoad];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://ntdev1.dev.im360.us:8088/0.1/menuchallenge/?method=menuSearch&search=pizza"]];
    [request setHTTPMethod:@"GET"];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(jsonData)
    {
        NSDictionary *dictionaryFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSLog( @"ya got it");
        detail = [dictionaryFromJSON objectForKey:@"results"];
        self.names = [[NSMutableArray alloc] init];
        for (NSDictionary *item in detail) {
            NSString *itemName = [item objectForKey:@"menuItemName"];
            NSString *itemPrice = [item objectForKey:@"menuItemPrice"];
            [self.names addObject:itemName];
            [self.names addObject:itemPrice];
        }
    }
    [[self tableView] reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.searchDetails removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    self.searchDetails = [NSMutableArray arrayWithArray:[self.names filteredArrayUsingPredicate:predicate]];
    NSLog( @"filtering!! %d %d", [self.names count], [self.searchDetails count]);
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"search %d", [self.searchDetails count] );
        return [self.searchDetails count];
        
    } else {
        NSLog(@"detail %d", [detail count] );
        return [detail count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IM366"];
    
    if (cell == nil) {
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IM366"];
    }
    
    NSString *out;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        out = [self.searchDetails objectAtIndex:indexPath.row];
        [cell.textLabel setText:out];
        
        NSLog(@"item %@", out);
        
    } else {
        NSDictionary *item = [detail objectAtIndex:indexPath.row];
        NSString *itemName = [item objectForKey:@"menuItemName"];
        NSString *itemPrice = [item objectForKey:@"menuItemPrice"];
        out = [NSString stringWithFormat:@"%@: %@", itemName, itemPrice];
        [cell.textLabel setText:out];
        
    }
       [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


@end
