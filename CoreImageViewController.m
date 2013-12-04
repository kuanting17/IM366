//
//  CoreImageViewController.m
//  IM366
//
//  Created by Kuanting Chen on 11/11/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "CoreImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CoreImageViewController ()

@end

@implementation CoreImageViewController
{
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
    UIImageOrientation orientation;
}

@synthesize imgv = _imagv, amountSlider = _amountSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}

-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    
    beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    context = [CIContext contextWithOptions:nil];
    
    filter = [CIFilter filterWithName:@"CISepiaTone"
                        keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imgv.image = newImage;
    
    CGImageRelease(cgimg);
    
    [self logAllFilters];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)savePhoto:(id)sender {
    
    CIImage *saveToSave = [filter outputImage];
    
    CIContext *softwareContext = [CIContext
                                  contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)} ];
    
    CGImageRef cgImg = [softwareContext createCGImage:saveToSave
                                             fromRect:[saveToSave extent]];
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[saveToSave properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              
                              CGImageRelease(cgImg);
                          }];

}

- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController *pickerC =
    [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}


- (IBAction)changeValue:(UISlider *)sender {
    
    float slideValue = sender.value;
    
    CIImage *outputImage = [self oldPhoto:beginImage withAmount:slideValue];
    
    CGImageRef cgimg = [context createCGImage:outputImage
                                     fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
    self.imgv.image = newImage;
    
    CGImageRelease(cgimg);
    

}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *gotImage =
    [info objectForKey:UIImagePickerControllerOriginalImage];
    beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    orientation = gotImage.imageOrientation;
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [self changeValue:self.amountSlider];
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[beginImage extent]];  
    
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];  //5
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];  //6
    
    return vignette.outputImage; //7
}

@end
