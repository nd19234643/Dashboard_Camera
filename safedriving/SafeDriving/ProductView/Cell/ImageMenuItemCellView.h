//
//  ImageMenuItemCellView.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/24.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageMenuItemCellView : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIImageView *imageItem ;
}

- (void) updateTitle:(NSString *) title andImage:(NSString *) imageName ;

@end
