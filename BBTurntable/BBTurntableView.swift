//
//  BBTurntableView.swift
//  BBTurntable
//
//  Created by 120v on 2018/12/21.
//  Copyright © 2018 MQ. All rights reserved.
//

import UIKit



class BBTurntableView: UIView {
    
    //奖品格子个数
    var sectorNum  = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViewUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addSubViewUI() {
        
        self.addBgView()
        
        self.addSector()
        
        self.addLables()
        
        self.addStartButton()
    }
    
    func addBgView() {
        self.addSubview(self.bgView)
    }
    
    func addSector() {
        for i in 0..<sectorNum {
            let sectorRadius = self.frame.size.width * 0.5
            let path = UIBezierPath()
            path.move(to:CGPoint(x: sectorRadius, y: sectorRadius))
            path.addArc(withCenter: CGPoint(x: sectorRadius, y: sectorRadius), radius: sectorRadius, startAngle: CGFloat(i) * (CGFloat.pi * 2)/CGFloat(sectorNum), endAngle: CGFloat(i+1) * (CGFloat.pi * 2)/CGFloat(sectorNum), clockwise: true)
            path.lineWidth = 1.0
            path.close()
            
            let sLayer = CAShapeLayer()
            sLayer.path = path.cgPath
            sLayer.fillColor = UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0).cgColor
            sLayer.strokeColor = UIColor.blue.cgColor
            self.bgView.layer.addSublayer(sLayer)
        }
    }
    
    func addLables() {
        for i in 0..<sectorNum {
            let titleLB = UILabel()
            titleLB.frame = CGRect(x: 0, y: 0, width:CGFloat.pi * (self.frame.size.height/CGFloat(sectorNum)), height: self.frame.size.height * 0.5)
            titleLB.layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
            titleLB.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.width * 0.5)
            titleLB.textAlignment = NSTextAlignment.center
            titleLB.transform = CGAffineTransform(rotationAngle: ((CGFloat.pi * 2) / CGFloat(sectorNum)) * CGFloat(Double(i)+0.5))
            titleLB.backgroundColor = UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0)
            titleLB.backgroundColor = UIColor.clear
            titleLB.text = "副教授积\(i)"
            titleLB.font = UIFont.systemFont(ofSize: 13.0)
            titleLB.minimumScaleFactor = 0.5
            self.bgView.addSubview(titleLB)
        }
    }
    
    func addStartButton() {
        let btnW: CGFloat = 100
        let startBtn = UIButton(frame: CGRect(x: (self.frame.size.width - btnW)*0.5, y: (self.frame.size.height - btnW)*0.5, width: btnW, height: btnW))
        startBtn.setTitle("开始", for: .normal)
        startBtn.backgroundColor = .orange
        startBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
        startBtn.layer.cornerRadius = btnW*0.5
        startBtn.layer.masksToBounds = true
        self.addSubview(startBtn)
    }
    
    @objc func start() {
        self.reset()
        self.bgView.layer.add(self.rotateAnimation, forKey: nil)
    }
    
    func reset() {
        self.bgView.layer.transform = CATransform3DIdentity
    }
    
    lazy var bgView: UIView = {
        let bView = UIView(frame: self.bounds)
        return bView
    }()
    
    lazy var rotateAnimation: CABasicAnimation = {
        let baseAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        baseAnim.duration = 4
        baseAnim.isCumulative = true
        baseAnim.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        baseAnim.fillMode = CAMediaTimingFillMode.forwards
        baseAnim.isRemovedOnCompletion = false
        baseAnim.delegate = self
        let sectorRadius = CGFloat.pi * 2 / CGFloat(sectorNum)
        let rotateValue = sectorRadius * 3 + sectorRadius * 0.5
        baseAnim.toValue = CGFloat.pi * 2 * 6 + rotateValue
        return baseAnim
    }()
}


extension BBTurntableView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}
