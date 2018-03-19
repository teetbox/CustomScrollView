//
//  FeedACell.swift
//  CustomScrollView
//
//  Created by Matt Tian on 19/03/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    var parentViewController: CustomScrollViewController!
}

class FeedACell: FeedCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.9, alpha: 1)

        setupViews()
    }
    
    private func setupViews() {
        addSubview(collectionView)
        addConstraints(format: "H:|[v0]|", views: collectionView)
        addConstraints(format: "V:|[v0]|", views: collectionView)
    }
    
    let cellId = "Cell"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FeedASubCell.self, forCellWithReuseIdentifier: cellId)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .orange
        return collection
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedACell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedASubCell
        cell.label.text = "Label \(indexPath.item)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
}

class FeedASubCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private func setupViews() {
        addSubview(label)
        addConstraints(format: "H:|[v0]|", views: label)
        addConstraints(format: "V:|[v0]|", views: label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
