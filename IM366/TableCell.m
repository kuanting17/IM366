//
//  TableCell.m
//  IM366
//
//  Created by Kuanting Chen on 10/31/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

@synthesize label = _label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

