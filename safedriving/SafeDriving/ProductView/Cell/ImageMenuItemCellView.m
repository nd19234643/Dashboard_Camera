//
//  ImageMenuItemCellView.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/24.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "ImageMenuItemCellView.h"

@implementation ImageMenuItemCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateTitle:(NSString *) title andImage:(NSString *) imageName{
    
    [lbTitle setText:title];
    [imageItem setImage:[UIImage imageNamed:imageName]];
    
}

@end
