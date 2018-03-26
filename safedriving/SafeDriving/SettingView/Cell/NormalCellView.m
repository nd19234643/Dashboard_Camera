//
//  NormalCellView.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "NormalCellView.h"

@implementation NormalCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateTitle:(NSString *) title andDetail:(NSString *) detail andChecked:(BOOL) checked {
    [lbTitle setText:title];
    [lbDetail setText:detail];
    

    if (checked) {
        [imageViewSelected setImage:[UIImage imageNamed:@"checked.png"]];
    }
    else{
        [imageViewSelected setImage:[UIImage imageNamed:@"none.png"]];
    }
    
}

@end
