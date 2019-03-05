//
//  CommonHtmlJumpViewController.m
//  Huitai
//
//  Created by Laughing on 2017/6/17.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "CommonHtmlShowViewController.h"

@interface CommonHtmlShowViewController ()<UIWebViewDelegate>
{
    UIWebView *_infoWebView;
}

@end

@implementation CommonHtmlShowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self initSubViews];
}

-(void)initSubViews
{
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];

    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), KNaviHeight, kScreenWidth -Size(20 *2), Size(75))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.numberOfLines = 2;
    titleLb.text = Localized(_titleStr,nil);
    [self.view addSubview:titleLb];
    
    _infoWebView = [[UIWebView alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY, titleLb.width, kScreenHeight -titleLb.maxY)];
    _infoWebView.backgroundColor = BACKGROUND_DARK_COLOR;
    _infoWebView.scrollView.showsVerticalScrollIndicator = NO;
    _infoWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _infoWebView.delegate = self;
    _infoWebView.opaque=NO;
    _infoWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_infoWebView];
    
    if (_commonHtmlShowViewType == CommonHtmlShowViewType_remindTip) {
        
        titleLb.frame = CGRectMake(Size(20), KNaviHeight, kScreenWidth -Size(20 *2), Size(25));
        _infoWebView.frame = CGRectMake(titleLb.minX, titleLb.maxY +Size(15), titleLb.width, kScreenHeight -titleLb.maxY-Size(15));
        
        if ([_titleStr isEqualToString:Localized(@"什么是助记词？", nil)]) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            
            UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _infoWebView.width, Size(10))];
            lb1.font = SystemFontOfSize(10);
            lb1.textColor = TEXT_DARK_COLOR;
            lb1.text = @"The importance of Phrase";
            [_infoWebView addSubview:lb1];
            
            UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb1.maxY+Size(10), _infoWebView.width, Size(40))];
            lb2.font = SystemFontOfSize(10);
            lb2.textColor = TEXT_DARK_COLOR;
            lb2.numberOfLines = 3;
            lb2.text = @"The Phrase is another manifestation of the plaintext private key, first proposed by the BIP39 proposal, to help users remember complex private keys (64-bit hashes).";
            NSMutableAttributedString *lb2Str = [[NSMutableAttributedString alloc] initWithString:lb2.text];
            [lb2Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb2Str.length)];
            lb2.attributedText = lb2Str;
            [_infoWebView addSubview:lb2];
            
            UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb2.maxY+Size(10), _infoWebView.width, Size(90))];
            lb3.font = SystemFontOfSize(10);
            lb3.textColor = TEXT_DARK_COLOR;
            lb3.numberOfLines = 8;
            lb3.text = @"Phrase are generally composed of 12, 15, 18, 21 or 24 words. These words are taken from a fixed vocabulary. The order of generation is also based on a certain algorithm, So there is no need to worry about Generating an address by simply typing 12 words. Although both mnemonics and Keystore can be used as another form of private key, unlike Keystore, the Phrase is an unencrypted private key, without any security, anyone who has received your Phrase can take your assets without any hassle.";
            NSMutableAttributedString *lb3Str = [[NSMutableAttributedString alloc] initWithString:lb3.text];
            [lb3Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb3Str.length)];
            lb3.attributedText = lb3Str;
            [_infoWebView addSubview:lb3];
            
            UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb3.maxY+Size(10), _infoWebView.width, Size(190))];
            lb4.font = SystemFontOfSize(10);
            lb4.textColor = TEXT_DARK_COLOR;
            lb4.numberOfLines = 20;
            lb4.text = @"So after backup the Phrase, you should be sure to pay attention to three points:\n\n1. Use physical media backup as much as possible, such as using a pen to copy on paper, as far as possible not to take screenshots or take photos and put them on networked devices to prevent hackers from stealing\n\n2. Verify that the backup Phrase is correct multiple times. Once you have mistyped one or two words, it will bring great difficulties to the subsequent retrieval of the correct Phrase;\n\n3. Keep the backup Phrase in a safe place and take anti-theft and anti-lost measures.";
            NSMutableAttributedString *lb4Str = [[NSMutableAttributedString alloc] initWithString:lb4.text];
            [lb4Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb4Str.length)];
            lb4.attributedText = lb4Str;
            [_infoWebView addSubview:lb4];
            
            UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb4.maxY+Size(5), _infoWebView.width, Size(80))];
            lb5.font = SystemFontOfSize(10);
            lb5.textColor = TEXT_RED_COLOR;
            lb5.numberOfLines = 6;
            lb5.text = @"Tips:\nUsers can use the backup Phrase to re-import the SEC wallet, generate a new Keystore with the new password, and modify the wallet password in this way.";
            NSMutableAttributedString *lb5Str = [[NSMutableAttributedString alloc] initWithString:lb5.text];
            [lb5Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb5Str.length)];
            lb5.attributedText = lb5Str;
            [_infoWebView addSubview:lb5];
            
        }else if ([_titleStr isEqualToString:Localized(@"什么是Keystore？", nil)]) {

            _infoWebView.frame = CGRectMake(titleLb.minX, KNaviHeight +Size(25), titleLb.width, kScreenHeight -titleLb.maxY);
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _infoWebView.width, Size(70))];
            lb1.font = SystemFontOfSize(10);
            lb1.textColor = TEXT_DARK_COLOR;
            lb1.numberOfLines = 5;
            lb1.text = @"The Keystore file is a file format (JSON) in which the SEC wallet stores private keys. It uses user-defined password encryption to provide a degree of protection, and the degree of protection depends on the password strength of the user encrypting the wallet. If a password like 123456 is extremely insecure.";
            NSMutableAttributedString *lb1Str = [[NSMutableAttributedString alloc] initWithString:lb1.text];
            [lb1Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb1Str.length)];
            lb1.attributedText = lb1Str;
            [_infoWebView addSubview:lb1];
            
            UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb1.maxY+Size(10), _infoWebView.width, Size(90))];
            lb2.font = SystemFontOfSize(10);
            lb2.textColor = TEXT_DARK_COLOR;
            lb2.numberOfLines = 20;
            lb2.text = @"There are two notes when using Keystore:\n1. Encrypt keystore files with passwords that are not commonly used and as complex as possible;\n2. Be sure to remember the password of the encrypted Keystore. Once you forget the password, you will lose the right to use the Keystore, and the SEC wallet will not be able to retrieve the password for you, so be sure to keep the Keystore and password.";
            NSMutableAttributedString *lb2Str = [[NSMutableAttributedString alloc] initWithString:lb2.text];
            [lb2Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb2Str.length)];
            lb2.attributedText = lb2Str;
            [_infoWebView addSubview:lb2];
            
            UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb2.maxY+Size(10), _infoWebView.width, Size(10))];
            lb3.font = SystemFontOfSize(10);
            lb3.textColor = TEXT_DARK_COLOR;
            lb3.text = @"Here is the style of the keystore:";
            [_infoWebView addSubview:lb3];
            
            UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(0, KNaviHeight +Size(25)+lb1.height +lb2.height+lb3.height+Size(30), kScreenWidth, Size(200))];
            bkgView.backgroundColor = DARK_COLOR;
            [self.view addSubview:bkgView];
            UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), Size(5), _infoWebView.width, bkgView.height -Size(10))];
            lb4.font = SystemFontOfSize(7);
            lb4.textColor = TEXT_DARK_COLOR;
            lb4.numberOfLines = 100;
            lb4.text = @"{\n\"version\":\3\",\n\"id\":\"b7467fcb-3c8b-41bebccf-73d43a08c1b7\",\n\"address\":\"540f18196da5a533fa36577a81de55f0a2f4e751\",\n\"Crypto\":\"{\n\"ciphertext\":\"78ed11b8b6bf29b00f52b42b8542df0e4a6ac078e626af7edcf885c3b68154a4\",\n\"cipherparams\"{\n\"iv\":\"4516579601d96695fe30ace985a9066f\"},\n\"cipher\":\"aes-128ctr\",\n\"kdf\":\"scrypt\",\n\"kdfparams\"{\n\"dklen\"32,\n\"salt\":\"6276cfda7d40872352c801db5871e5a3368a8d0994cea39ed936760db78d1cdc\",\n\"n\":1024,\n\"r\":8,\n\"p\":1},\n\"mac\":\"d889a5dc609c3f312a41394cc47640676d2612501a6f8c837ed55598336db\"\n}\n}";
            paragraphStyle.lineSpacing = Size(2);
            NSMutableAttributedString *lb4Str = [[NSMutableAttributedString alloc] initWithString:lb4.text];
            [lb4Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb4Str.length)];
            lb4.attributedText = lb4Str;
            [bkgView addSubview:lb4];
            
            UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb3.maxY+Size(200 +5), _infoWebView.width, Size(80))];
            lb5.font = SystemFontOfSize(10);
            lb5.textColor = TEXT_RED_COLOR;
            lb5.numberOfLines = 6;
            lb5.text = @"Tips:\nKeystore password is unique and unchangeable. If you want to change the wallet password, you need to re-import it with a mnemonic or plaintext private key and encrypt it with a new one to generate a new Keystore.";
            NSMutableAttributedString *lb5Str = [[NSMutableAttributedString alloc] initWithString:lb5.text];
            [lb5Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb5Str.length)];
            lb5.attributedText = lb5Str;
            [_infoWebView addSubview:lb5];
            
        }else if ([_titleStr isEqualToString:Localized(@"什么是私钥？", nil)]) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            
            UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Size(5), _infoWebView.width, Size(80))];
            lb1.font = SystemFontOfSize(10);
            lb1.textColor = TEXT_DARK_COLOR;
            lb1.numberOfLines = 5;
            lb1.text = @"We often say that your control over the funds in your wallet depends on the ownership and control of the corresponding private key. In blockchain transactions, the private key is used to generate the signature necessary to pay the currency to prove ownership of the funds.";
            NSMutableAttributedString *lb1Str = [[NSMutableAttributedString alloc] initWithString:lb1.text];
            [lb1Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb1Str.length)];
            lb1.attributedText = lb1Str;
            [_infoWebView addSubview:lb1];
            
            UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb1.maxY+Size(10), _infoWebView.width, Size(80))];
            lb2.font = SystemFontOfSize(10);
            lb2.textColor = TEXT_DARK_COLOR;
            lb2.numberOfLines = 6;
            lb2.text = @"The private key must always be kept secret, because once it is leaked to a third one, the assets under the protection of the private key are also handed over. It is different from Keystore. Keystore is an encrypted private key file. As long as the password strength is strong enough, even if the hacker gets Keystore, The difficulty of cracking is also large enough. ";
            NSMutableAttributedString *lb2Str = [[NSMutableAttributedString alloc] initWithString:lb2.text];
            [lb2Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb2Str.length)];
            lb2.attributedText = lb2Str;
            [_infoWebView addSubview:lb2];
            
            UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb2.maxY+Size(10), _infoWebView.width, Size(50))];
            lb3.font = SystemFontOfSize(10);
            lb3.textColor = TEXT_DARK_COLOR;
            lb3.numberOfLines = 3;
            lb3.text = @"The private keys stored in the user's wallet are completely independent and can be generated and managed by the user's wallet software without blockchain or network connection. ";
            NSMutableAttributedString *lb3Str = [[NSMutableAttributedString alloc] initWithString:lb3.text];
            [lb3Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb3Str.length)];
            lb3.attributedText = lb3Str;
            [_infoWebView addSubview:lb3];
            
            UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb3.maxY+Size(10), _infoWebView.width, Size(80))];
            lb4.font = SystemFontOfSize(10);
            lb4.textColor = TEXT_DARK_COLOR;
            lb4.numberOfLines = 6;
            lb4.text = @"The user's wallet address is calculated by the public key via keccak256 and truncated by 40 bits + 0x. The private key is a 64-bit hexadecimal hash string, for example: 56f759ece75f0ab1b783893cbe390288978d4d4ff24dd233245b4285fcc31cf6";
            NSMutableAttributedString *lb4Str = [[NSMutableAttributedString alloc] initWithString:lb4.text];
            [lb4Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb4Str.length)];
            lb4.attributedText = lb4Str;
            [_infoWebView addSubview:lb4];
            
            UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(0, lb4.maxY+Size(15), _infoWebView.width, Size(80))];
            lb5.font = SystemFontOfSize(10);
            lb5.textColor = TEXT_RED_COLOR;
            lb5.numberOfLines = 6;
            lb5.text = @"Tips:\nUsers can use the clear text private key to import the SEC wallet, use the new password to generate a new Keystore (remember to delete the old Keystore), and use this method to modify the wallet password.";
            NSMutableAttributedString *lb5Str = [[NSMutableAttributedString alloc] initWithString:lb5.text];
            [lb5Str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lb5Str.length)];
            lb5.attributedText = lb5Str;
            [_infoWebView addSubview:lb5];
            
        }
        
    }else if (_commonHtmlShowViewType == CommonHtmlShowViewType_other) {
        _infoWebView.frame = CGRectMake(0, KNaviHeight, kScreenWidth, kScreenHeight -KNaviHeight);
        //分享按钮
        UIButton *shareBT = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -Size(45 +15), KStatusBarHeight+(KNaviHeight-KStatusBarHeight-Size(24))/2, Size(45), Size(24))];
        [shareBT greenBorderBtnStyle:Localized(@"分享", nil) andBkgImg:@"smallRightBtn"];
        [shareBT addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBT];
        [_infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adUrl]]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //禁止webview编辑
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#90A2AB'"];
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];
}

-(void)shareAction
{
    NSURL *url = [NSURL URLWithString:_adUrl];
    NSArray *activityItems = @[@"",url];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityController.modalInPopover = true;
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

@end
