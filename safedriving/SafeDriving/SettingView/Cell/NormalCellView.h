//
//  NormalCellView.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalCellView : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UILabel *lbDetail ;
    IBOutlet UIImageView *imageViewSelected ;
}

- (void) updateTitle:(NSString *) title andDetail:(NSString *) detail andChecked:(BOOL) checked ;

@end
