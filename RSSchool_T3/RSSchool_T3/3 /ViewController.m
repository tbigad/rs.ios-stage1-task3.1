#import "ViewController.h"

@interface UIColor (Utility)
-(NSString*)representInHex;
@end

@implementation UIColor (Utility)
-(NSString*)representInHex
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"0x%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    return hexString;
}
@end
@interface ViewController() <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *labelResultColor;
@property (nonatomic, strong) UILabel *labelRed;
@property (nonatomic, strong) UILabel *labelGreen;
@property (nonatomic, strong) UILabel *labelBlue;
@property (nonatomic, strong) UIView *viewResultColor;
@property (nonatomic, strong) UITextField *textFieldRed;
@property (nonatomic, strong) UITextField *textFieldGreen;
@property (nonatomic, strong) UITextField *textFieldBlue;
@property (nonatomic, strong) UIButton *buttonProcess;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@end


@implementation ViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.accessibilityIdentifier = @"mainView";
    [self setupLabels];
    [self setupTextFields];
    [self setupColorView];
    [self setupButtons];
}

- (void)setupLabels {
    self.labelResultColor = [[UILabel alloc] init];
    self.labelResultColor.accessibilityIdentifier = @"labelResultColor";
    self.labelRed = [[UILabel alloc] init];
    self.labelRed.accessibilityIdentifier = @"labelRed";
    self.labelGreen = [[UILabel alloc] init];
    self.labelGreen.accessibilityIdentifier = @"labelGreen";
    self.labelBlue = [[UILabel alloc] init];
    self.labelBlue.accessibilityIdentifier = @"labelBlue";
    NSArray* labels = [[NSArray alloc] initWithObjects:self.labelResultColor, self.labelRed, self.labelGreen, self.labelBlue, nil];
    NSArray* titles = [[NSArray alloc] initWithObjects:@"Color",@"RED",@"GREEN",@"BLUE",nil];
    int previousHeight = 0;
    for (int i = 0; i < labels.count; i++) {
        UILabel* label = labels[i];
        label.text = titles[i];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 1;
        [label sizeToFit];
        CGRect rect = label.frame;
        rect.origin.x = 20;
        rect.origin.y = 100 + (i * 60) + previousHeight;
        rect.size.width = [ViewController screenWidth] * 0.2;
        rect.size.height = 40;
        previousHeight = rect.size.height;
        label.frame = rect;
        [self.view addSubview:label];
    }
}

- (void)setupTextFields {
    self.textFieldRed = [[UITextField alloc] init];
    self.textFieldRed.accessibilityIdentifier = @"textFieldRed";
    self.textFieldBlue = [[UITextField alloc] init];
    self.textFieldBlue.accessibilityIdentifier = @"textFieldBlue";
    self.textFieldGreen = [[UITextField alloc] init];
    self.textFieldGreen.accessibilityIdentifier = @"textFieldGreen";
    NSArray* labels = [[NSArray alloc] initWithObjects:self.labelRed, self.labelGreen, self.labelBlue, nil];
    NSArray* textFields = [[NSArray alloc] initWithObjects:self.textFieldRed, self.textFieldGreen, self.textFieldBlue,  nil];
    
    for (int i = 0; i < textFields.count; i++) {
        UITextField* textField = textFields[i];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"0..255";
        UILabel* label = labels[i];
        int x = label.frame.origin.x + label.frame.size.width + 20;
        int h = label.frame.size.height;
        int y = CGRectGetMidY(label.frame) - h/2;
        int w = [ViewController screenWidth] - x - 20;
        textField.frame = CGRectMake(x, y, w, h);
        [self.view addSubview: textField];
    }
}

-(void)setupColorView{
    int x = CGRectGetMaxX(self.labelResultColor.frame) + 30;
    int h = self.labelResultColor.frame.size.height;
    int y = CGRectGetMidY(self.labelResultColor.frame) - h/2;
    int w = [ViewController screenWidth] - x - 20;
    
    CGRect viewFrame = CGRectMake(x, y, w, h);
    self.viewResultColor = [[UIView alloc]initWithFrame:viewFrame];
    self.viewResultColor.backgroundColor = UIColor.grayColor;
    self.viewResultColor.accessibilityIdentifier = @"viewResultColor";
    [self.view addSubview: self.viewResultColor];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.labelResultColor.text = @"Color";
    return true;
}

- (void)setupButtons {
    CGRect buttonFrame = CGRectMake([ViewController screenWidth] / 2 - 50, CGRectGetMidY(self.labelBlue.frame) + 20, 100, 50);
    self.buttonProcess = [[UIButton alloc]initWithFrame:buttonFrame];
    [self.buttonProcess setTitle:@"Process" forState:UIControlStateNormal];
    [self.buttonProcess setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    self.buttonProcess.accessibilityIdentifier = @"buttonProcess";
    [self.view addSubview: self.buttonProcess];
    [self.buttonProcess addTarget:self action:@selector(didTappedButton) forControlEvents:UIControlEventTouchUpInside];
}


- (BOOL)checkErrorItems:(NSString *)string {
    NSString *allowedCharacters = @"1234567890";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString: allowedCharacters] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        return false;
    }
    if(([string intValue] > 255) || ([string intValue] < 0)) {
        return false;
    }
    if([string isEqualToString:@""]) {
        return false;
    }
    return true;
}

- (void)didTappedButton {
    NSString *redColor = self.textFieldRed.text;
    NSString *greenColor = self.textFieldGreen.text;
    NSString *blueColor = self.textFieldBlue.text;
    
    if ([self checkErrorItems:redColor] && [self checkErrorItems:greenColor] && [self checkErrorItems:blueColor]) {
        UIColor *resultColor = [UIColor colorWithRed:(redColor.floatValue/255) green:(greenColor.floatValue)/255 blue:(blueColor.floatValue)/255 alpha:1];
        
        self.viewResultColor.backgroundColor = resultColor;
        self.labelResultColor.text = [resultColor representInHex];
        
    } else {
        self.labelResultColor.text = @"Error";
    }
    
    [self.view endEditing:YES];
    self.textFieldBlue.text  = nil;
    self.textFieldGreen.text = nil;
    self.textFieldRed.text = nil;
}

+(CGFloat) screenWidth {
    return UIScreen.mainScreen.bounds.size.width;
}

@end
