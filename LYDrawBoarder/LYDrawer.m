//
//  LYDrawer.m
//  LYDrawBoarder
//
//  Created by lychow on 1/11/16.
//  Copyright © 2016 IOSDeveloper. All rights reserved.
//

#import "LYDrawer.h"


@interface LYDrawer()

@property(nonatomic,strong) NSMutableArray  *lines;

@property(nonatomic,strong) NSMutableArray  *canceledLines;


@property(nonatomic,strong) UIBezierPath  *path;

@property(nonatomic,strong) CAShapeLayer  *shapeLayer;
@end

@implementation LYDrawer

-(NSMutableArray *)lines
{
    if (!_lines) {
        _lines =[NSMutableArray array];
    }
    return _lines;
}

-(NSMutableArray *)canceledLines
{
    if (!_canceledLines) {
        _canceledLines =[NSMutableArray array];
    }
    return _canceledLines;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

-(CGPoint)touchPointWith:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    return point;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
      [super touchesBegan:touches withEvent:event];
    if (touches.count==1)
    {
       
     //1.创建UIBezierPath
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth =3.0;
    [path moveToPoint:[self touchPointWith:touches]];
    self.path =path;
    
     //2.防止创建图文上下文时,耗费大量内存
    CAShapeLayer *shapLayer =[CAShapeLayer  layer];
    shapLayer.path =path.CGPath;
    shapLayer.backgroundColor = [UIColor orangeColor].CGColor;
    shapLayer.fillColor = [UIColor clearColor].CGColor;
    shapLayer.strokeColor = [UIColor blackColor].CGColor;
    shapLayer.lineWidth=path.lineWidth;
    [self.layer addSublayer:shapLayer];
    self.shapeLayer =shapLayer;


        
    //3.把CAShapLayer加入lines数组中
    [[self mutableArrayValueForKeyPath:@"lines"] addObject:shapLayer];
        
    //4.canceledLines 清空
    [[self mutableArrayValueForKeyPath:@"canceledLines"] removeAllObjects];
    }
   
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (touches.count ==1)
    {
        [self.path addLineToPoint:[self touchPointWith:touches]];
        self.shapeLayer.path = self.path.CGPath;
    }
}


/*!
 *  清屏
 */
-(void)clear
{
     [self.lines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  //lines  canceledLines 清空
    [[self mutableArrayValueForKeyPath:@"lines"] removeAllObjects];
    [[self mutableArrayValueForKeyPath:@"canceledLines"] removeAllObjects];
  //所有的layer 移除 Suplayer
    
   
}

/*!
 *  撤销
 */
-(void)undo
{
// lines.lastLayer removeFromSuperView
    [self.lines.lastObject removeFromSuperlayer];


// canceledLines add  layer
    [[self mutableArrayValueForKeyPath:@"canceledLines"] addObject:self.lines.lastObject];
    // lines remover last layer
    [[self mutableArrayValueForKeyPath:@"lines"] removeLastObject];
}

/*!
 *  恢复
 */
-(void)redo
{
    //self.layer add   canceledLines.lastLayer
    [self.layer addSublayer:self.canceledLines.lastObject];
    //lines add object  lastLayer
    [[self mutableArrayValueForKeyPath:@"lines"] addObject:self.canceledLines.lastObject];
    
    //canceled
    [[self mutableArrayValueForKeyPath:@"canceledLines"] removeLastObject];
}

@end
