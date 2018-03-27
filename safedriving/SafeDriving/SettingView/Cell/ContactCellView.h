//
//  ContactCellView.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCellView : UITableViewCell
{
    IBOutlet UILabel *lbEmail;
    IBOutlet UILabel *lbMessage ;
}

- (void) updateEmail:(NSString *) email andMessage:(NSString *) message  ;

@end
