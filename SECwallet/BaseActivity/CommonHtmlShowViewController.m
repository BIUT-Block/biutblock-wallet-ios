//
//  CommonHtmlJumpViewController.m
//  Huitai
//
//  Created by Laughing on 2017/6/17.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "CommonHtmlShowViewController.h"
#import "UIWebView+JS.h"

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
    
    if (_commonHtmlShowViewType == CommonHtmlShowViewType_RgsProtocol) {
        
        [_infoWebView loadHTMLString:Localized(@"尊敬的用户：\n感谢您选择CEC服务。《CEC服务协议》（以下简称“本协议”）。在本协议中： （1）“我”和“我们”指代本公司，“我们的”应据此解释；及（2）“您”指代用户，“您的”应据此解释。您和本公司单独称为“一方”，合称为“双方”。\n本公司在此特别提醒您在使用我们的CEC移动应用（以下简称“CEC” 或“本软件”，CEC可在各移动应用平台上下载，请认真阅读本协议及后文提及的相关协议，尤其是本协议中“免责及责任限制”等以加粗形式体现的条款，确保您充分理解本协议中各条款，并自主考虑风险。\n一、 关于本协议的确认与接纳\n1.您理解本协议及有关协议适用于CEC及CEC上本公司所自主开发和拥有的去中心化应用（简称“DApp”）（排除第三方开发的DApp）。\n2.您下载CEC软件并创建身份、恢复身份（定义见下文）或导入钱包，即视为您已经充分阅读并接受本协议全部条款，本协议立即生效，对双方具有约束力。 如果您不同意本协议条款，您应立即停止使用CEC。如果您已经下载了CEC，请立即删除。\n3.在访问或使用CEC时, 您同意：\n（1）接受本协议最新版本的约束（不变更亦不修改）；\n（2）在您所适用的司法管辖区域内，您已达到使用CEC的法定年龄，并可承担因使用CEC而产生的有约束力法律或金钱义务；且\n（3）您不属于被排除人士（如本协议所定义）。\n4.本协议可由本公司随时更新，经修改的协议一经在CEC上公布，立即自动生效，不再另行通知。在本公司公布修改协议条款后，如果您不接受修改后的条款，请立即停止使用CEC，您继续使用CEC将被视为接受修改后的协议。\n二、 定义\n1.CEC： 指由本公司基于区块链开发的数字钱包，包括其他为方便用户使用区块链系统而开发的辅助工具。\n2.被排除人士：\n（1）除了自然人以外的、具备订立本协议的法律和意识能力的人士；或\n（2）因本协议、法律、监管要求或适用于该用户的司法管辖区的规定而被以任何形式或方式（全部或部分）禁止、限制、无授权或无资格使用服务（如本协议所定义）的用户。\n3.创建或导入钱包： 指在您接受本协议后，使用CEC创建或导入钱包的过程。\n4.钱包密码： 指您在创建CEC钱包过程中，由您决定的密码，该密码将被用于加密和保护您的私钥。CEC作为去中心化的应用，钱包密码不存储在您的这台移动设备或本公司的服务器，一旦您丢失或忘记钱包密码，您需要借助私钥或助记词重置钱包密码。\n5.信息提示： CEC软件操作界面涉及的信息提示内容，建议用户按照相关步骤进行操作。\n6.特定用户： 指按照新加坡和其他国家的法律法规及政策规定必须要配合本公司履行个人信息披露义务的用户。\n7.私钥： 由256位随机字符构成，是用户拥有并使用数字代币的核心。\n8.公钥： 由私钥借助密码学原理单向推导生成，并用以生成区块链数字钱包地址，数字钱包地址即为公开收款地址。\n9.助记词： 符合区块链BIP39 行业标准，由随机算法生成的12（或15/18/21/24）个有序单词组成。是私钥的易记录表现形式，方便用户备份保管。\n10.Keystore: 是私钥或助记词经过用户设置的钱包密码加密保存的文件形式，它只存储在您的这台移动设备中，不会同步至本公司服务器。\n11.数字代币： 指CEC目前支持的数字代币种类，包括但不限于ETH等。\n12.智能合约： 指一种旨在以信息化方式传播、验证或执行合同的、基于以太坊的智能化合约，包括但不限于后文提及的智能合约Kyber和/或智能合约0x。CEC集成的智能合约目前尚不提供跨链服务。\n13.ETH： 指以太币，是与以太坊区块链相关的加密数字代币，为避免疑问，其不包括“以太坊经典”。\n三、 CEC服务（统称“服务”）\n1.创建钱包。您可以使用CEC提供的“创建钱包”，可创建和管理多链钱包。\n2.导入钱包。对CEC支持的数字代币，您可以使用CEC生成新钱包或导入相关区块链系统的其它钱包工具生成的兼容钱包。\n3.转账、收款。您可以使用CEC的转账、收款功能进行数字代币的管理，即运用私钥进行电子签名，对相关区块链的账本进行修改。转账是指付款方利用收款方的ENS域名或区块链地址进行转账操作，该“转账”行为涉及在相关区块链系统的分布式账本中对该交易的有效记录（而非在CEC上实际交付或转让数字代币）。\n4.管理数字代币。您可以从CEC操作界面添加、保管或移除CEC所支持的数字代币（ETH除外）。\n6.交易记录。我们将通过区块链系统拷贝您全部或部分的交易记录。但用户应以区块链系统的最新交易记录为准。\n8.其他本公司认为有必要提供的服务。\n用户接受本公司提供的上述服务时了解并接受：\n1.秉承着区块链的去中心化特点，并为了保护您数字代币安全，本公司提供的是去中心化服务，大大区别于银行业金融机构。用户了解并接受，本公司 不承担 以下责任：\n（1）存储用户的钱包密码（即用户创建/导入钱包时设置的密码）、私钥、助记词或Keystore；\n（2）找回用户的钱包密码、私钥、助记词或Keystore；\n（3）冻结钱包；\n（4）挂失钱包；\n（5）恢复钱包；\n（6）交易回滚。\n2.您应当自行承担保管含有CEC的移动设备、备份CEC、备份钱包密码、助记词、私钥及Keystore的责任。如您遗失移动设备、删除且未备份CEC、删除且未备份钱包、钱包被盗或遗忘钱包密码、私钥、助记词或Keystore，本公司均无法还原钱包或找回钱包密码、私钥、助记词或Keystore；如用户进行交易时误操作（例如输错转账地址、输错兑换数额），本公司无法取消交易，且本公司亦不应对此承担任何责任。\n3.本公司和CEC所能够提供的数字代币管理服务并未包括所有已存在的数字代币，请勿通过CEC操作任何CEC不支持的数字代币。\n4.CEC上集成的DApp包括本公司自主拥有的DApp和第三方平台提供的DApp。对于第三方平台提供的DApp，CEC仅为用户进入DApp提供搜索和区块链浏览器功能，不对第三方DApp的功能或服务质量提供任何担保。用户在第三方DApp上接受服务或进行交易前应自行判断和评估该第三方DApp提供的服务或交易是否存在风险。\n四、 您的权利义务\n（一）创建或导入钱包\n1.创建或导入钱包： 您有权在您的移动设备上通过CEC创建和/或导入钱包，有权设定钱包的钱包密码等信息，并有权通过CEC应用程序，使用自己的钱包在区块链上进行转账和收款等交易。\n2.本公司可能为不同的终端设备开发不同的软件版本，您应当根据实际需要选择下载合适的版本进行安装。如果您从未经合法授权的第三方获取本软件或与本软件名称相同的安装程序，本公司将无法保证该软件能否正常使用，也无法保证其安全性，因此造成的损失由您自行承担。\n3.本软件新版本发布后，旧版软件可能无法使用。本公司不保证旧版软件的安全性、继续可用性及提供相应的客户服务。请用户随时核对并下载最新版本。\n（二）使用\n1.您应自行承担妥善保管移动设备、钱包密码、私钥、助记词和Keystore等信息的责任。 本公司不负责为用户保管以上信息。因您遗失移动设备、主动或被动泄露、遗忘钱包密码、私钥、助记词、Keystore或遭受他人攻击、诈骗等所引起的一切风险、责任、损失、费用应由您自行承担。\n2.CEC信息提示。 您了解并同意遵循本公司在CEC上发布的信息提示，按照信息提示的内容进行操作，否则，由此引起的一切风险、责任、损失、费用等应由您自行承担。\n3.您知悉并理解CEC没有义务对链接的第三方DApp服务、第三方智能合约服务或交易履行尽职调查义务，您应当谨慎评估并承担所有与使用CEC有关的风险。\n4.提供信息和文件。 如果本公司自行认为有必要获取用户的相关信息以遵循任何与使用或操作CEC相关的适用法律或法规的规定，用户应按照本公司的要求及时向本公司提供该等信息，且用户了解并接受，本公司可以限制、暂停或终止您使用CEC直到您提供满足公司要求的信息。用户承诺及时向本公司告知任何有关其依据本协议向本公司提供的文件和信息中的任何变化，且在没有通知任何变化的书面通知的情形下，本公司有权认为由用户提供的文件和信息的内容是真实、正确、没有误导信息且没有发生改变的。\n5.完成身份验证。 当本公司合理认为您的交易行为或交易情况出现异常的，或认为您的身份信息存在疑点的，或本公司认为应核对您身份证件或其他必要文件的情形时，请您积极配合本公司核对您的有效身份证件或其他必要文件，及时完成相关的身份验证。\n6.转账\n（1）您知悉对于CEC服务中您可使用的日计转账限额和笔数，可能因为您使用该转账服务时所处的国家/地区、监管要求、转账目的、CEC风险控制、身份验证等事由而不同。\n（2）您理解基于区块链操作的“不可撤销”属性，当您使用CEC转账功能时，您应当自行承担因您操作失误而导致的后果（包括但不限于因您输错转账地址、您自身选择转账节点服务器的问题）。\n（3）您知悉在使用CEC服务时，以下情况的出现可能导致转账功能不可用、转账“交易失败”或“打包超时”：", nil)];
        
    }else if (_commonHtmlShowViewType == CommonHtmlShowViewType_remindTip) {
        
        titleLb.frame = CGRectMake(Size(20), KNaviHeight, kScreenWidth -Size(20 *2), Size(25));
        _infoWebView.frame = CGRectMake(titleLb.minX, titleLb.maxY +Size(15), titleLb.width, kScreenHeight -titleLb.maxY-Size(15));
        
        if ([_titleStr isEqualToString:@"什么是GAS费用？"]) {
            [_infoWebView loadHTMLString:@"在一个公链上，任何人都可以读写数据。读取数据是免费的，但是向公有链中写数据时需要花费一定费用的，这种开销有助于阻止垃圾内容，并通过支付保护其安全性。网络上的任何节点（每个包含账本拷贝的链接设备都被称作节点）都可以参与称作挖矿的方式来保护网络。由于挖矿需要计算能力和电费，所以矿工们的服务需要得到一定的报酬，这也是矿工费的由来。\n矿工会优先打包gas合理，gas price高的交易。如果用户交易时所支付的矿工费非常低，那么这笔交易可能不会被矿工打包，从而造成交易失败。\nCEC的交易费用（也是以太坊的交易费用）=gas 数量*gas price（gas单价，以太币计价）"];
        }else if ([_titleStr isEqualToString:Localized(@"什么是助记词？", nil)]) {
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
            
        }else{
            NSString *ducumentLocation = [[NSBundle mainBundle]pathForResource:@"RgsProtocol" ofType:@"docx"];
            _infoWebView.multipleTouchEnabled = YES;
            _infoWebView.scalesPageToFit = YES;
            [_infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:ducumentLocation]]];
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
    if (_commonHtmlShowViewType == CommonHtmlShowViewType_RgsProtocol) {
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '75%'"];
    }else{
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];
    }
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
