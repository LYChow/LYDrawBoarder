//
//  LYDrawer.h
//  LYDrawBoarder
//
//  Created by lychow on 1/11/16.
//  Copyright © 2016 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYDrawer : UIView


/*!
 *  清屏
 */
-(void)clear;

/*!
 *  撤销
 */
-(void)undo;

/*!
 *  恢复
 */
-(void)redo;

@end
