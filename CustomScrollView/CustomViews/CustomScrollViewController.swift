//
//  CustomScrollViewController.swift
//  CustomScrollView
//
//  Created by Matt Tian on 15/03/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

class CustomScrollViewController: UIViewController {
    
    var shouldStatusBarDark = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return shouldStatusBarDark ? .default : .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupViews()
    }
        
    func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        scrollView.addSubview(contentView)
    
        contentView.addSubview(backImageView)
        contentView.addConstraints(format: "H:|[v0]|", views: backImageView)
        backImageTopConstraint = backImageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        backImageTopConstraint?.isActive = true
//        backImageTopConstraint?.constant = -50
        backImageTopConstraint?.constant = backImageDefaultTopConstant
        backImageHeightConstraint = backImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2)
        backImageHeightConstraint?.isActive = true
        
        contentView.addSubview(imageView)
        contentView.addConstraints(format: "H:[v0(70)]", views: imageView)
        contentView.addConstraints(format: "V:[v0(70)]", views: imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: backImageView.bottomAnchor).isActive = true
        
        contentView.addSubview(menuCollection)
        contentView.addConstraints(format: "H:|[v0]|", views: menuCollection)
        contentView.addConstraints(format: "V:[v0(100)]", views: menuCollection)
        menuCollection.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        contentView.addSubview(feedCollection)
        contentView.addConstraints(format: "H:|[v0]|", views: feedCollection)
        contentView.addConstraints(format: "V:[v0]|", views: feedCollection)
        feedCollection.topAnchor.constraint(equalTo: menuCollection.bottomAnchor).isActive = true
        feedCollection.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 249)
        
        let contentHeight = view.frame.width / 2 + 70 + 100 + feedCollection.frame.height
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: contentHeight)
        scrollView.contentSize = contentView.frame.size
        
        view.addSubview(navView)
        view.addConstraints(format: "H:|[v0]|", views: navView)
        let navHight = ScreenUtility.isPhoneX ? 88 : 64
        view.addConstraints(format: "V:|[v0(\(navHight))]", views: navView)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.7, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.backgroundColor = UIColor(white: 0.7, alpha: 1)
        scroll.scrollIndicatorInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        return scroll
    }()
    
    var contentHeightConstraint: NSLayoutConstraint?
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cyan
        return view
    }()
    
    var backImageTopConstraint: NSLayoutConstraint?
    var backImageHeightConstraint: NSLayoutConstraint?
    let backImageDefaultTopConstant: CGFloat = ScreenUtility.isPhoneX ? -74 : -50
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "wwdc2016.png")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "GoldenGate")
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    let menuCollection: MenuCollectionView = {
        let menu = MenuCollectionView()
        menu.backgroundColor = UIColor.magenta
        return menu
    }()
    
    let feedCollection: FeedCollectionView = {
        let feed = FeedCollectionView()
        return feed
    }()

    var previousOffSetY: CGFloat = 0
}

extension CustomScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
        // Show or hide navigation view
        if offSetY > 50 {
            UIView.animate(withDuration: 0.4, animations: {
                self.navView.alpha = 1
                self.shouldStatusBarDark = true
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.navView.alpha = 0
                self.shouldStatusBarDark = false
            })
        }

        // Update back image view top constraint
        print(offSetY)
        // if offSetY <= -50 {
        if offSetY <= backImageDefaultTopConstant {
            backImageTopConstraint?.isActive = false
            backImageTopConstraint = backImageView.topAnchor.constraint(equalTo: view.topAnchor)
            backImageTopConstraint?.isActive = true
            
            // Enlarge the backImageView
            /*
            let distance = sqrt(sqrt(sqrt(sqrt(-50 - offSetY))))
            if (offSetY < previousOffSetY) {
                backImageHeightConstraint?.constant += distance
            }
            */
        } else {
            backImageTopConstraint?.isActive = false
            backImageTopConstraint = backImageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            backImageTopConstraint?.isActive = true
//            backImageTopConstraint?.constant = -50
            backImageTopConstraint?.constant = backImageDefaultTopConstant
        }
        
        // When scroll view goes up, re-small the image
        /*
        if (offSetY < -20 && offSetY > previousOffSetY) {
            let gap = -20 - offSetY
            let distance = offSetY - previousOffSetY
            let unit = (backImageHeightConstraint!.constant - view.frame.width / 2) / gap
            backImageHeightConstraint?.constant -= distance * unit
        }

        previousOffSetY = offSetY
        */
    }
    
}

class MenuCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var parentVC: FeedCollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentVC?.scrollToMenu(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    private func setupViews() {
        let subViews = [menuCollection, menuBar]
        subViews.forEach(addSubview)
        
        addConstraints(format: "H:|[v0]|", views: menuCollection)
        addConstraints(format: "V:|[v0]|", views: menuCollection)
        addConstraints(format: "V:[v0(4)]|", views: menuBar)
        
        let width = UIScreen.main.bounds.width
        let oneThird = width / 6
        let oneFourth = width / 4
        menuBarCenterConstraint = menuBar.centerXAnchor.constraint(equalTo: leftAnchor)
        menuBarCenterConstraint?.isActive = true
        menuBarCenterConstraint?.constant = oneThird * 1
        menuBar.widthAnchor.constraint(equalToConstant: oneFourth).isActive = true
    }
    
    let cellId = "Cell"
    lazy var menuCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        return collection
    }()
    
    var menuBarCenterConstraint: NSLayoutConstraint?
    let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
}

class MenuCell: UICollectionViewCell {
    
}

class FeedCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
        addConstraints(format: "H:|[v0]|", views: contentView)
        addConstraints(format: "V:|[v0]|", views: contentView)
    }

    let cellA = "CellA"
    let cellB = "CellB"
    let cellB2 = "CellB2"
    
    lazy var contentView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FeedACell.self, forCellWithReuseIdentifier: cellA)
        collection.register(FeedBCell.self, forCellWithReuseIdentifier: cellB)
        collection.register(FeedB2Cell.self, forCellWithReuseIdentifier: cellB2)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.bounces = false
        return collection
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        switch indexPath.item {
        case 0:
            identifier = cellA
        case 1:
            identifier = cellB
        case 2:
            identifier = cellB2
        default:
            fatalError()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FeedCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let width = UIScreen.main.bounds.width
//        let position = scrollView.contentOffset.x
//        menuView.menuBarCenterConstraint?.constant = position / 3 + width / 6
    }
    
    func scrollToMenu(at index: Int) {
//        contentView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
    }
    
}
