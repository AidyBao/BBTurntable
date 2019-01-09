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
            if i%2 == 0 {
                sLayer.fillColor = UIColor(red: 255.0/255.0, green: 157/255.0, blue: 45/255.0, alpha: 1).cgColor
            }else{
                sLayer.fillColor = UIColor(red: 255.0/255.0, green: 206/255.0, blue: 55/255.0, alpha: 1).cgColor
            }
            sLayer.strokeColor = UIColor.clear.cgColor
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
            titleLB.text = "0.\(i) 元"
            titleLB.font = UIFont.boldSystemFont(ofSize: 18.0)
            titleLB.minimumScaleFactor = 0.5
            titleLB.attributedText = titleLB.text?.zx_shadowFormat(shadowRadius: 2.0, shadowColor: UIColor(red: 0/255.0, green: 156/255.0, blue: 244/255.0, alpha: 1), shadowOffSet: CGSize(width: 1.5, height: 0), foregroundColor: .white, strokeColor:  UIColor(red: 0/255.0, green: 156/255.0, blue: 244/255.0, alpha: 1), strokeWidth: 2.0, font: UIFont.boldSystemFont(ofSize: 20.0))
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


extension String {
    /**
     *@Para: 描边&阴影
     *@shadowRadius: 阴影模糊度
     *@shadowColor: 阴影颜色
     *@shadowOffSet: 阴影偏移
     *@foregroundColor: 前景色
     *@strokeColor: 描边颜色
     *@strokeWidth: 描边宽度
     */
    func zx_shadowFormat(shadowRadius shadRadius: CGFloat = 2.0,
                         shadowColor shadColor: UIColor,
                         shadowOffSet shadOffSet: CGSize = CGSize.zero,
                         foregroundColor fogeColor: UIColor = UIColor.white,
                         strokeColor stroColor: UIColor,
                         strokeWidth stroWidth: CGFloat = 3.0,
                         font tFont: UIFont) -> NSAttributedString {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = shadRadius
        shadow.shadowColor = shadColor
        shadow.shadowOffset = shadOffSet
        
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : fogeColor,
                                                    NSAttributedString.Key.strokeColor : stroColor,
                                                    NSAttributedString.Key.strokeWidth : -stroWidth,
                                                    NSAttributedString.Key.font : tFont,
                                                    NSAttributedString.Key.shadow: shadow
        ]
        
        let attrStr = NSMutableAttributedString(string: self, attributes: attrs)
        return attrStr
    }
}
