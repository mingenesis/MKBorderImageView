//
//  MKBorderImageView.m
//  
//
//  Created by Mingenesis on 7/1/16.
//
//

#import "MKBorderImageView.h"

static UIImage *drawImage(UIColor *color, UIEdgeInsets indentations, MKBorderImageViewSides sides) {
    CGSize size = CGSizeMake(indentations.left + indentations.right + 3, indentations.top + indentations.bottom + 3);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path;
    CGFloat lineWidth = 1 / [UIScreen mainScreen].scale;
    
    [color setFill];
    
    if (sides & MKBorderImageViewSideTop) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(indentations.left, 0, 3, lineWidth)];
        [path fill];
    }
    if (sides & MKBorderImageViewSideLeft) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(0, indentations.top, lineWidth, 3)];
        [path fill];
    }
    if (sides & MKBorderImageViewSideBottom) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(indentations.left, size.height - lineWidth, 3, lineWidth)];
        [path fill];
    }
    if (sides & MKBorderImageViewSideRight) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(size.width - lineWidth, indentations.top, lineWidth, 3)];
        [path fill];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [newImage resizableImageWithCapInsets:UIEdgeInsetsMake(indentations.top + 1, indentations.left + 1, indentations.bottom + 1, indentations.right + 1)];
}

@implementation MKBorderImageView

+ (NSCache *)sharedImageCache {
    static NSCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });
    
    return imageCache;
}

+ (instancetype)borderImageViewWithIndentations:(UIEdgeInsets)indentations sides:(MKBorderImageViewSides)sides {
    MKBorderImageView *imageView = [[MKBorderImageView alloc] initWithImage:nil];
    [imageView updateBorderWithIndentations:indentations sides:sides];
    
    return imageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateBorderWithIndentations:[self parseIndentations] sides:[self parseSides]];
}

- (void)updateBorderWithIndentations:(UIEdgeInsets)indentations sides:(MKBorderImageViewSides)sides {
    
    
    NSCache *imageCache = [[self class] sharedImageCache];
    NSString *imageName = [self imageNameForIndentations:indentations sides:sides];
    UIImage *image = [imageCache objectForKey:imageName];
    
    if (!image) {
        image = drawImage(self.borderColor, indentations, sides);
        [imageCache setObject:image forKey:imageName];
    }
    
    self.image = image;
}

- (MKBorderImageViewSides)parseSides {
    MKBorderImageViewSides sides = 0;
    if (self.sideTop) {
        sides |= MKBorderImageViewSideTop;
    }
    if (self.sideLeft) {
        sides |= MKBorderImageViewSideLeft;
    }
    if (self.sideBottom) {
        sides |= MKBorderImageViewSideBottom;
    }
    if (self.sideRight) {
        sides |= MKBorderImageViewSideRight;
    }
    
    return sides;
}

- (UIEdgeInsets)parseIndentations {
    return UIEdgeInsetsMake(self.indentTop, self.indentLeft, self.indentBottom, self.indentRight);
}

- (NSString *)imageNameForIndentations:(UIEdgeInsets)indentations sides:(MKBorderImageViewSides)sides {
    return [NSString stringWithFormat:@"%@_%@_(%@)", @(sides), NSStringFromUIEdgeInsets(indentations), [CIColor colorWithCGColor:self.borderColor.CGColor].stringRepresentation];
}

- (void)prepareForInterfaceBuilder {
    [self updateBorderWithIndentations:[self parseIndentations] sides:[self parseSides]];
}

- (UIColor *)borderColor {
    if (!_borderColor) {
        _borderColor = [UIColor lightGrayColor];
    }
    
    return _borderColor;
}

@end
