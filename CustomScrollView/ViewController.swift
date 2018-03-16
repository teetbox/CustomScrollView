//
//  ViewController.swift
//  CustomScrollView
//
//  Created by Matt Tian on 15/03/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var wwdcTopConstraint: NSLayoutConstraint?
    var wwdcHeightConstraint: NSLayoutConstraint?
    lazy var wwdc: UIImageView = {
        return UIImageView()
    }()
    
    private func setupViews() {
//        view.addSubview(wwdc)
//        view.addConstraints(format: "H:|[v0]-10-|", views: wwdc)
//        view.addConstraints(format: "V:[v0(\(view.frame.width / 2))]", views: wwdc)
//
        
        wwdc.image = UIImage(named: "wwdc2016")
        wwdc.contentMode = .scaleAspectFill
        wwdc.clipsToBounds = true
        scrollView.addSubview(wwdc)
        
        scrollView.addConstraints(format: "H:|[v0(\(view.frame.width))]", views: wwdc)
//        scrollView.addConstraints(format: "V:[v0(\(view.frame.width / 2))]", views: wwdc)
        
        wwdcTopConstraint = wwdc.topAnchor.constraint(equalTo: scrollView.topAnchor)
        wwdcTopConstraint?.isActive = true
        wwdcTopConstraint?.constant = -50
        
        wwdcHeightConstraint = wwdc.heightAnchor.constraint(equalToConstant: view.frame.width / 2)
        wwdcHeightConstraint?.isActive = true

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeGesture.direction = .down
        scrollView.addGestureRecognizer(swipeGesture)
    }
    
    var isAmplifyEnabled = false {
        didSet {
            if isAmplifyEnabled != oldValue {
                toggleImageSize()
            }
        }
    }
    
    func toggleImageSize() {
        if isAmplifyEnabled {
            print("Enable amplifier")
        } else {
            print("Disable amplifier")
        }
    }
    
    @objc func swipeHandler() {
        print(#function)
    }
    
    var previousOffSetY: CGFloat = 0
    
}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y

        if (offSetY < -20 && offSetY > previousOffSetY) {
            let gap = -20 - offSetY
            let distance = offSetY - previousOffSetY
            let unit = (wwdcHeightConstraint!.constant - view.frame.width / 2) / gap
            wwdcHeightConstraint?.constant -= distance * unit
        }
        if offSetY <= -50 {
            wwdcTopConstraint?.isActive = false
            wwdcTopConstraint = wwdc.topAnchor.constraint(equalTo: view.topAnchor)
            wwdcTopConstraint?.isActive = true

            let distance = sqrt(sqrt(sqrt(sqrt(-50 - offSetY))))
            if (offSetY < previousOffSetY) {
                wwdcHeightConstraint?.constant += distance
            }
        } else {
            wwdcTopConstraint?.isActive = false
            wwdcTopConstraint = wwdc.topAnchor.constraint(equalTo: scrollView.topAnchor)
            wwdcTopConstraint?.isActive = true
            wwdcTopConstraint?.constant = -50
        }
        
        previousOffSetY = offSetY
    }
    
}
