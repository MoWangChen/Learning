//
//  ViewController.swift
//  colorQrCode
//
//  Created by 谢鹏翔 on 2018/1/29.
//  Copyright © 2018年 365ime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let qrView = ColorfulQRCodeMetalView(frame: CGRect(x: 50, y:50, width: 100, height: 100));
        self.view.addSubview(qrView);
        qrView.backgroundColor = UIColor.lightGray
        
        if let image = UIImage.init(named: "qrcode") {
            qrView.setQRCodeImage(qrcodeImage: image)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

