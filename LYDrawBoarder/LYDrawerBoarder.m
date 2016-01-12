//
//  LYDrawerBoarder.m
//  LYDrawBoarder
//
//  Created by lychow on 1/11/16.
//  Copyright © 2016 IOSDeveloper. All rights reserved.
//

#import "LYDrawerBoarder.h"

#import "LYDrawer.h"

CGFloat const toolBarHeight = 44;
#define screenWidth   [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

@interface LYDrawerBoarder()



@property(nonatomic,strong) NSArray  *btnImageArray;

@property(nonatomic,strong) NSArray  *enableBtnArray;

@property(nonatomic,strong) UIButton  *deleteBtn;

@property(nonatomic,strong) UIButton  *redoBtn;

@property(nonatomic,strong) UIButton  *undoBtn;


@property(nonatomic,strong) LYDrawer  *drawer;
@end

@implementation LYDrawerBoarder

-(NSArray *)btnImageArray
{
    if (!_btnImageArray) {
        self.btnImageArray =[NSArray arrayWithObjects:@"close_draft_enable",@"delete_draft_enable",@"redo_draft_enable",@"undo_draft_enable",nil];
    }
    return _btnImageArray;
}

-(NSArray *)enableBtnArray
{
    if (!_enableBtnArray) {
        self.enableBtnArray =[NSArray arrayWithObjects:@"close_draft",@"delete_draft",@"redo_draft",@"undo_draft",nil];
    }
    return _enableBtnArray;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        //顶部工具条
        UIView * toolV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
        toolV.backgroundColor = [UIColor blueColor];
        [self addSubview:toolV];

        //工具栏
        CGFloat btnW =screenWidth/self.enableBtnArray.count;
        
        for (int i=0; i<self.enableBtnArray.count; i++) {
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:[self.enableBtnArray objectAtIndex:i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[self.btnImageArray objectAtIndex:i]] forState:UIControlStateDisabled];
            btn.frame=CGRectMake(btnW *i, 20, btnW, toolBarHeight);
            btn.tag=100+i;
            [toolV addSubview:btn];
            btn.enabled=i<1;
            if (btn.tag==101)
            {
                self.deleteBtn = btn;
            }
            else if (btn.tag ==102)
            {
                self.undoBtn =btn;
            }
            else if (btn.tag ==103)
            {
                self.redoBtn = btn;
            }
            [btn addTarget:self action:@selector(ToolBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor =[UIColor blueColor];
        }
        
        
        
         //加载绘制画板
        LYDrawer *drawer =[[LYDrawer alloc] init];
        drawer.backgroundColor =[UIColor lightGrayColor];
        drawer.frame=CGRectMake(0, CGRectGetMaxY(toolV.frame), screenWidth, screenHeight- CGRectGetHeight(toolV.frame));
        [self insertSubview:drawer belowSubview:toolV];
        self.drawer = drawer;
        
        //监听drawer 中lines canceledLines 数组  显示按钮的状态
        [self.drawer addObserver:self forKeyPath:@"lines" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
        [self.drawer addObserver:self forKeyPath:@"canceledLines" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
        
        self.backgroundColor =[UIColor grayColor];
       //把view加载到Window上
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

-(void)show
{
    [UIView animateWithDuration:.3 animations:^{
        self.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    }];
}

-(void)dismiss
{
[UIView animateWithDuration:.3 animations:^{
    self.frame=CGRectMake(screenHeight, 0, screenWidth, screenHeight);
}];
    
    [self.drawer removeObserver:self forKeyPath:@"lines"];
    [self.drawer removeObserver:self forKeyPath:@"canceledLines"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
   
    if ([keyPath isEqualToString:@"lines"])
    {
        
        NSMutableArray *lines =[self.drawer mutableArrayValueForKeyPath:@"lines"];
        self.deleteBtn.enabled=lines.count;
        self.undoBtn.enabled=lines.count;
    }
    
    if ([keyPath isEqualToString:@"canceledLines"])
    {
        //count
        NSMutableArray *canceledLines =[self.drawer mutableArrayValueForKeyPath:@"canceledLines"];
        self.redoBtn.enabled=canceledLines.count;
    }
}

-(void)ToolBarBtnClick:(UIButton *)btn
{
  
    if (btn.tag == 100) {
        [self dismiss];
    }
    else if (btn.tag ==101)
    {
        [self.drawer clear];
    }
    else if (btn.tag ==102)
    {
        [self.drawer undo];
    }
    else if (btn.tag ==103)
    {
        [self.drawer redo];
    }
}


@end
