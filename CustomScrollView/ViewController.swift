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
    
    private func setupViews() {
        wwdc.image = UIImage(named: "wwdc2016")
        wwdc.contentMode = .scaleAspectFill
        wwdc.clipsToBounds = true
        scrollView.addSubview(wwdc)
        
        scrollView.addConstraints(format: "H:|[v0(\(view.frame.width))]", views: wwdc)
        wwdcTopConstraint = wwdc.topAnchor.constraint(equalTo: scrollView.topAnchor)
        wwdcTopConstraint?.isActive = true
        wwdcTopConstraint?.constant = -50
        wwdcHeightConstraint = wwdc.heightAnchor.constraint(equalToConstant: view.frame.width / 2)
        wwdcHeightConstraint?.isActive = true
    }
    
    var previousOffSetY: CGFloat = 0
    
    var wwdcTopConstraint: NSLayoutConstraint?
    var wwdcHeightConstraint: NSLayoutConstraint?

    lazy var wwdc: UIImageView = {
        return UIImageView()
    }()
    
}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
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
        
        // When scroll view goes up, re-small the image
        if (offSetY < -20 && offSetY > previousOffSetY) {
            let gap = -20 - offSetY
            let distance = offSetY - previousOffSetY
            let unit = (wwdcHeightConstraint!.constant - view.frame.width / 2) / gap
            wwdcHeightConstraint?.constant -= distance * unit
        }
        
        previousOffSetY = offSetY
    }
    
}
