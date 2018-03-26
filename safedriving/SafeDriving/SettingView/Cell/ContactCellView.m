//
//  ContactCellView.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "ContactCellView.h"

@implementation ContactCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateEmail:(NSString *) email andMessage:(NSString *) message {
    [lbEmail setText:email];
    [lbMessage setText:message];
}

@end
