//
//  ViewController.swift
//  tuxiaobei
//
//  Created by Raecoo Cao on 03/31/16.
//  Copyright © 2016 OTT Team. All rights reserved.
//



import UIKit
import StoreKit

func isPurchased() -> Bool {
    let isBuy = UserDefaults.standard.bool(forKey: "com.uu.VIP") || UserDefaults.standard.bool(forKey: "com.uu.VIP499") || UserDefaults.standard.bool(forKey: "com.uu.VIP199") || UserDefaults.standard.bool(forKey: "com.uu.VIP299")
    return isBuy
}

func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize(width: width, height: 900)
    let dic = NSDictionary(object: font, forKey: convertFromNSAttributedStringKey(NSAttributedString.Key.font) as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary(dic as? [String : AnyObject]), context: nil).size
    return strSize.height
}

func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize(width: 900, height: height)
    let dic = NSDictionary(object: font, forKey: convertFromNSAttributedStringKey(NSAttributedString.Key.font) as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary(dic as? [String : AnyObject]), context: nil).size
    return strSize.width
}

func validateSubscriptionIfNeeded() {
    let validatedAt = UserDefaults.standard.double(forKey: "receipt_validated_at")
    let now = NSDate().timeIntervalSince1970
    if (now - validatedAt < 86400) {
        return
    }
    IAP.validateReceipt("f3a2caf8481e4db9a00f1ded035a034c") { (statusCode, products, receipt) in
        if (products == nil || products!.isEmpty) {
            UserDefaults.standard.set(false, forKey: "com.uu.VIP299")
            UserDefaults.standard.synchronize()
            return
        }
        if let expireDate = products!["com.uu.VIP199"] {
            if (expireDate.timeIntervalSince1970 < now) {
                print("Subscription expired ...")
                UserDefaults.standard.set(false, forKey: "com.uu.VIP199")
                UserDefaults.standard.synchronize()
            }
        }
        if let expireDate = products!["com.uu.VIP299"] {
            if (expireDate.timeIntervalSince1970 < now) {
                print("Subscription expired ...")
                UserDefaults.standard.set(false, forKey: "com.uu.VIP299")
                UserDefaults.standard.synchronize()
            }
        }
        if let expireDate = products!["com.uu.VIP499"] {
            if (expireDate.timeIntervalSince1970 < now) {
                print("Subscription expired ...")
                UserDefaults.standard.set(false, forKey: "com.uu.VIP499")
                UserDefaults.standard.synchronize()
            }
        }
        if let expireDate = products!["com.uu.VIP"] {
            if (expireDate.timeIntervalSince1970 < now) {
                print("Subscription expired ...")
                UserDefaults.standard.set(false, forKey: "com.uu.VIP")
                UserDefaults.standard.synchronize()
            }
        }
    }
}

class PurchaseViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    // Mark: Properties
    var btnSubscribe = UIButton(type: UIButton.ButtonType.custom) as UIButton;
    var btnBack = UIButton(type: UIButton.ButtonType.custom) as UIButton;
    var btnRestore = UIButton(type: UIButton.ButtonType.custom) as UIButton;
    var btnPolicy = UIButton(type: UIButton.ButtonType.system) as UIButton;
    var btnTerm = UIButton(type: UIButton.ButtonType.system) as UIButton;
    
    
    var spinnerOverlay = UIView()
    var actInd = UIActivityIndicatorView()
    
    var viewHasLoaded = false
    var restorePreferred = false
    var isHideTab = false
    
    override var preferredFocusedView: UIView? {
        get {
            if (isPurchased()) {
                return self.btnBack
            } else if (restorePreferred) {
                return self.btnRestore
            } else {
                return self.btnSubscribe
            }
        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 227/255.0, green: 131/255.0, blue: 31/255.0, alpha: 1)
        super.viewDidLoad()
        
        IAP.requestProducts(Set<ProductIdentifier>(arrayLiteral: "com.uu.VIP299"))
        
        validateSubscriptionIfNeeded()
        
        if(!IAP.canMakePayment()) {
            let alert = UIAlertController(title: "Alert",
                                          message: "Please enable In App Purchase in Settings.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: { () in
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            })
        }
        
        buildButtons()
        viewHasLoaded = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Warning ...")
    }
    
    // MARK: initialize view
    func buildButtons(){
        if (viewHasLoaded) {
            view.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        let screenSize:CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let btnTextSize:CGFloat = 16
        let btnTextFont:String  = "HelveticaNeue" // UltraLight
        let gap:CGFloat = 30;
        let btnWidth:CGFloat    = (screenWidth - 2*gap - 15*2)/3.0;
        let btnHeight:CGFloat   = 40
        
        let img = UIImage(imageLiteralResourceName: "purchase_header")
//        let headerUrl = NSURL(string: "http://api.ottcloud.tv/smarttv/zhongguolan/data/header-light.jpg")
//        let headerData = NSData(contentsOf: headerUrl! as URL)
//        let headerImage = UIImage(data: headerData! as Data)
        let headerImageView = UIImageView(image: img)
        let imgWidth = screenWidth * 1080.0 / 1920.0
        headerImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: imgWidth)
        self.view.addSubview(headerImageView)
        
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth-30, height: 0));
        label.text = "    此订阅自动续费，每月都会自动收费，除非您在当期结束前24小时取消。订阅期长1月，每月收费2.99美元。iTunes 账户续费是在当期结束前24小时内扣费2.99美元。可在iTunes设置中取消此订阅。\n    隐私政策:http://34.224.203.220/pravicy.html\n    服务协议:http://34.224.203.220/user.html";
//        label.text = "此订阅自动续费，每月都会自动收费，除非您在当期结束前24小时取消。订阅期长1月，每月收费1.00人民币。iTunes 账户续费是在当期结束前24小时内扣费1.00人民币。可在iTunes设置中取消此订阅。\n    隐私政策:http://34.224.203.220/pravicy.html\n    服务协议:http://34.224.203.220/user.html";
        label.textColor = UIColor.white;
        label.textAlignment = .left
        let font = UIFont(name: btnTextFont, size: 16)
        label.font = font
        let labelHeight = getLabHeigh(labelStr: label.text!, font: font!, width: screenWidth-30)
        label.frame = CGRect(x: 15, y: headerImageView.frame.size.height + 10, width: screenWidth-30, height: labelHeight)
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        let policyBtn = UIButton(type: .custom)
        policyBtn.frame = CGRect(x: 50, y: label.frame.maxY+10, width: (screenWidth-50*2-30)/2, height: 25)
        policyBtn.setTitle("隐私政策", for: .normal)
        policyBtn.setTitleColor(UIColor(rgb:0xFF8000), for: UIControl.State.normal)
        policyBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.6)
        policyBtn.layer.cornerRadius = 3;
        policyBtn.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
        policyBtn.addTarget(self, action: #selector(policyBtnClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(policyBtn)
        
        
        let termBtn = UIButton(type: .custom)
        termBtn.frame = CGRect(x: 50+(screenWidth-50*2-30)/2+30, y: policyBtn.frame.origin.y, width: (screenWidth-50*2-30)/2, height: 25)
        termBtn.setTitle("服务协议", for: .normal)
        termBtn.setTitleColor(UIColor(rgb:0xFF8000), for: UIControl.State.normal)
        termBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.6)
        termBtn.layer.cornerRadius = 3;
        termBtn.titleLabel!.font = UIFont(name: btnTextFont, size: btnTextSize)!
        termBtn.addTarget(self, action: #selector(termBtnClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(termBtn)
        
        if (isPurchased()){
            let currentBtnWidth = (screenWidth - 30*2 - 50)/2
            //btn之间间隔50px，距左右边距30px
            let havePurchased = UILabel(frame: CGRect(x: 30, y: policyBtn.frame.maxY + 30, width: currentBtnWidth, height: 30))
            havePurchased.font = UIFont(name: btnTextFont, size: 28)
            havePurchased.text = "恭喜您已订购成功!"
            havePurchased.textColor = UIColor(red: 250/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1)
            havePurchased.textAlignment = .center
            self.view.addSubview(havePurchased)
            
            btnBack.setTitle("返回", for: .normal)
            btnBack.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnBack.layer.cornerRadius = 8
            btnBack.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
            btnBack.frame = CGRect(x:havePurchased.frame.maxX+50, y:policyBtn.frame.maxY+30, width:currentBtnWidth, height:30)
            btnBack.addTarget(self, action: #selector(backClicked(sender:)), for: .primaryActionTriggered)
            self.view.addSubview(btnBack)
        } else {
            let priceLabel:UILabel = UILabel(frame: CGRect(x: 15, y: policyBtn.frame.maxY + 30, width: screenWidth-30, height: 30))
            priceLabel.font = UIFont(name: btnTextFont, size: 28)
            priceLabel.textColor = UIColor(red: 250/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1)
            priceLabel.text = "USD 2.99 / 月"
            priceLabel.textAlignment = .center
            self.view.addSubview(priceLabel)
            
            // restore button
            btnRestore.setTitle("恢复购买", for: .normal)
            btnRestore.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btnRestore.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnRestore.layer.cornerRadius = 3
            btnRestore.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0)
            btnRestore.layer.borderWidth = 1
            btnRestore.layer.borderColor = UIColor.white.cgColor
            btnRestore.frame = CGRect(x:15, y:screenHeight-btnHeight-2*gap, width:btnWidth, height:btnHeight)
            btnRestore.addTarget(self, action: #selector(restoreClicked(button:)), for: .primaryActionTriggered)
            self.view.addSubview(btnRestore)
            
            // subscribe button
            btnSubscribe.setTitle("立即订购", for: .normal)
            btnSubscribe.setTitleColor(UIColor(rgb:0xFF8000), for: UIControl.State.normal)
            btnSubscribe.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            btnSubscribe.layer.cornerRadius = 3
            btnSubscribe.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnSubscribe.frame = CGRect(x:btnRestore.frame.maxX+gap, y:btnRestore.frame.origin.y, width:btnWidth, height:btnHeight)
            btnSubscribe.addTarget(self, action: #selector(subscribeClicked(button:)), for: .primaryActionTriggered)
            self.view.addSubview(btnSubscribe)
            
            // back button
            btnBack.setTitle("返回", for: .normal)
            btnBack.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnBack.layer.borderWidth = 1
            btnBack.layer.borderColor = UIColor.white.cgColor
            btnBack.layer.cornerRadius = 3
            btnBack.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0)
            btnBack.frame = CGRect(x:btnSubscribe.frame.maxX+gap, y:btnRestore.frame.origin.y, width:btnWidth, height:btnHeight)
            btnBack.addTarget(self, action: #selector(backClicked(sender:)), for: .primaryActionTriggered)
            self.view.addSubview(btnBack)
        }
    }
    
    func showSpinner() {
        if (self.spinnerOverlay.subviews.isEmpty) {
            // Spinner overlay
            spinnerOverlay = UIView(frame: view.frame)
            spinnerOverlay.backgroundColor = UIColor.black
            spinnerOverlay.alpha = 0.85
            let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.frame = CGRect(x:0, y:0, width:40, height:40)
            actInd.center = spinnerOverlay.center
            actInd.hidesWhenStopped = true
            actInd.style = UIActivityIndicatorView.Style.whiteLarge
            spinnerOverlay.addSubview(actInd)
            actInd.startAnimating()
        }
        
        view.addSubview(spinnerOverlay)
    }
    
    func hideSpinner() {
        spinnerOverlay.removeFromSuperview()
    }
    
    @objc func subscribeClicked(button: UIButton!) {
        showSpinner()
        IAP.purchaseProduct("com.uu.VIP299", handler: handlePurchase)
    }
    
    @objc func restoreClicked(button: UIButton!) {
        showSpinner()
        IAP.restorePurchases(handleRestore)
    }
    
    @objc func backClicked(sender: UIButton!) {
        PushHelper.init().pop(self, with: self.navigationController, andSetTabBarHidden: isHideTab)
//        if let navController = self.navigationController {
//            navController.popViewController(animated: true)
//        }
    }
    
    @objc func policyBtnClicked(sender: UIButton!) {
        let vc = PolicyViewController()
        vc.webViewUrl = "http://34.224.203.220/pravicy.html";
        vc.titleLabelText = "隐私政策";
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func termBtnClicked(sender: UIButton!) {
        let vc = PolicyViewController()
        vc.titleLabelText = "服务协议";
        vc.webViewUrl = "http://34.224.203.220/user.html";
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Mark: In-App Purchase functions
    
    func handlePurchase(productIdentifier: ProductIdentifier?, error: NSError?) {
        if productIdentifier != nil {
            print("Purchase Success")
            provideContentForProductIdentifier(productIdentifier: productIdentifier!)
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        } else if error?.code == SKError.paymentCancelled.rawValue {
            print("Purchase Cancelled: \(error?.localizedDescription)")
            buildButtons()
        } else if error?.code == 3532 {
            restorePreferred = true
            buildButtons()
            updateFocusIfNeeded()
        } else {
            //print(error?.code)
            print("Purchase Error: \(error?.localizedDescription)")
        }
        
        hideSpinner()
        
    }
    
    func handleRestore(productIdentifiers: Set<ProductIdentifier>, error: NSError?) {
        if !productIdentifiers.isEmpty {
            print("Restore Success")
            for productIdentifier in productIdentifiers {
                provideContentForProductIdentifier(productIdentifier: productIdentifier)
            }
            let alertController = UIAlertController(title: "恢复购买", message: "购买状态已恢复", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "返回", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if error?.code == SKError.unknown.rawValue {
            // NOTE: if no product ever purchased, will return this error.
            let alertController = UIAlertController(title: "恢复购买", message: "未找到购买记录, 请确认已登录的 Apple ID 是否正确", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "返回", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if error?.code == SKError.paymentCancelled.rawValue {
            print("Restore Cancelled: \(error?.localizedDescription)")
        } else {
            print("Restore Error: \(error?.localizedDescription)")
            
        }
        hideSpinner()
    }
    
    private func provideContentForProductIdentifier(productIdentifier: String) {
        userDefaults.set(true, forKey: productIdentifier)
        userDefaults.synchronize()
        buildButtons()
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
