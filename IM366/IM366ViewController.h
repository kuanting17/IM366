//
//  IM366ViewController.h
//  IM366
//
//  Created by Kuanting Chen on 10/31/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IM366ViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *dataSearchBar;
@property (strong,nonatomic) NSMutableArray *searchDetails;
@property (strong,nonatomic) NSMutableArray *names;

@end
