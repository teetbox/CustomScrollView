//
//  CustomScrollViewController.swift
//  CustomScrollView
//
//  Created by Matt Tian on 15/03/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

class CustomScrollViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.backgroundColor = UIColor(white: 0.9, alpha: 1)
        scroll.scrollIndicatorInsets = UIEdgeInsets(top: -22, left: 0, bottom: 0, right: 0)
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cyan
        return view
    }()
    
    let imageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupViews()
    }
    
        
    func setupViews() {
        scrollView.addSubview(contentView)
        scrollView.addConstraints(format: "H:|[v0]|", views: contentView)
        scrollView.addConstraints(format: "V:|[v0]-(-100)-|", views: contentView)

        scrollView.contentSize = contentView.frame.size
        view.addSubview(scrollView)
    }

}

