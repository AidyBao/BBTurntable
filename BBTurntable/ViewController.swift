//
//  ViewController.swift
//  BBTurntable
//
//  Created by 120v on 2018/12/21.
//  Copyright © 2018 MQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var turnView: BBTurntableView = {
        let tView = BBTurntableView(frame: CGRect(x: 30, y: 200, width: UIScreen.main.bounds.size.width - 2*30, height: UIScreen.main.bounds.size.width - 2*30))
        tView.backgroundColor = .clear
        return tView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.turnView)        
    }

    
    

}

