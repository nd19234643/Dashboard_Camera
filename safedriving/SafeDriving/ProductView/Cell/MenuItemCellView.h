//
//  MenuCellView.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCellView : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIImageView *imageViewMenuItem;
}

@property (strong) IBOutlet UILabel *lbTitle;
@property (strong) IBOutlet UIImageView *imageViewMenuItem;

@end
