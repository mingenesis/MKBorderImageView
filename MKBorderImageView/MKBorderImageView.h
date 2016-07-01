//
//  MKBorderImageView.h
//  
//
//  Created by Mingenesis on 7/1/16.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, MKBorderImageViewSides) {
    MKBorderImageViewSideTop    = 1 << 0,
    MKBorderImageViewSideLeft   = 1 << 1,
    MKBorderImageViewSideBottom = 1 << 2,
    MKBorderImageViewSideRight  = 1 << 3,
};

IB_DESIGNABLE
@interface MKBorderImageView : UIImageView

@property (nullable, nonatomic, copy) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat indentTop;
@property (nonatomic) IBInspectable CGFloat indentLeft;
@property (nonatomic) IBInspectable CGFloat indentBottom;
@property (nonatomic) IBInspectable CGFloat indentRight;
@property (nonatomic) IBInspectable BOOL sideTop;
@property (nonatomic) IBInspectable BOOL sideLeft;
@property (nonatomic) IBInspectable BOOL sideBottom;
@property (nonatomic) IBInspectable BOOL sideRight;

+ (instancetype)borderImageViewWithIndentations:(UIEdgeInsets)indentations sides:(MKBorderImageViewSides)sides;
- (void)updateBorderWithIndentations:(UIEdgeInsets)indentations sides:(MKBorderImageViewSides)sides;

@end

NS_ASSUME_NONNULL_END