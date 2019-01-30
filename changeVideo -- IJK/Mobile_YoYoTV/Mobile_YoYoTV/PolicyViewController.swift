//
//  PolicyViewController.swift
//  YoYoVideo
//
//  Created by li que on 2017/4/24.
//  Copyright © 2017年 li que. All rights reserved.
//

import UIKit

var screenWidth = UIScreen.main.bounds.size.width
var screenHeight = UIScreen.main.bounds.size.height


class PolicyViewController: UIViewController {
    public var titleLabelText : String = ""
    public var webViewUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupWebView()
        
        //绿色
        let TColor = UIColor.init(red: 247/255.0, green: 136/255.0, blue: 26/255.0, alpha: 1.0)
        //蓝色
        let BColor = UIColor.init(red: 247/255.0, green: 175/255.0, blue: 36/255.0, alpha: 1.0)
        //将颜色和颜色的位置定义在数组内
        let gradientColors: [CGColor] = [TColor.cgColor, BColor.cgColor]
        //创建并实例化CAGradientLayer
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        //设置frame和插入view的layer
        gradientLayer.frame = view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension PolicyViewController {
    
    func setupNav() {
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
        navView.backgroundColor = UIColor.white;
        
        //绿色
        let TColor = UIColor.init(red: 247/255.0, green: 136/255.0, blue: 26/255.0, alpha: 1.0)
        //蓝色
        let BColor = UIColor.init(red: 247/255.0, green: 175/255.0, blue: 36/255.0, alpha: 1.0)
        //将颜色和颜色的位置定义在数组内
        let gradientColors: [CGColor] = [TColor.cgColor, BColor.cgColor]
        //创建并实例化CAGradientLayer
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0.15, y: 0.5)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 0.85, y: 0.5)
        //设置frame和插入view的layer
        gradientLayer.frame = navView.bounds
        navView.layer.insertSublayer(gradientLayer, at: 0)
        
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 15, y: 20+(44-44)/2, width: 50, height: 44)
        backBtn.setImage(#imageLiteral(resourceName: "ArrowLeft.png"), for: .normal)
        let width = 22*0.8
        let height = 36*0.8
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: CGFloat((44-height)/2), left: 0, bottom: CGFloat((44-height)/2), right: CGFloat(50-width))
        backBtn.addTarget(self, action: #selector(backBtnClicked(sender:)), for: .touchUpInside)
        
        let titleLabel = UILabel(frame: CGRect(x: (screenWidth-180)/2, y: 20, width: 180, height: 44))
        titleLabel.textAlignment = .center
        titleLabel.text = titleLabelText
        titleLabel.font = UIFont(name: "Times New Roman", size: 18)
//        print("字体", UIFont.familyNames)
        
        navView.addSubview(titleLabel)
        navView.addSubview(backBtn)
        self.view.addSubview(navView)
    }
    
    func setupWebView() {
        let webView = UIWebView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        //发送网络请求
        let url:NSURL = NSURL(string: webViewUrl)!
        let request:NSURLRequest = NSURLRequest(url: url as URL)
        webView.loadRequest(request as URLRequest)
        // 设置UIWebView接收的数据是否可以通过手势来调整页面内容大小
        webView.scalesPageToFit = true;
        webView.delegate = self as UIWebViewDelegate
        self.view.addSubview(webView)
    }
    
    @objc func backBtnClicked(sender: UIButton!) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

// MARK: - UIWebViewDelegate
extension PolicyViewController: UIWebViewDelegate {
    // 该方法是在UIWebView在开发加载时调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("开始加载")
    }
    
    // 该方法是在UIWebView加载完之后才调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("加载完成")
    }
    
    // 该方法是在UIWebView请求失败的时候调用
    func webView(webView: UIWebView, didFailLoadWithError error: Error?) {
        print("加载失败")
    }
}






