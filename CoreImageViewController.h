//
//  CoreImageViewController.h
//  IM366
//
//  Created by Kuanting Chen on 11/11/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreImageViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
- (IBAction)savePhoto:(id)sender;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)changeValue:(UISlider *)sender;


@end
