//
//  FeedB2Cell.swift
//  CustomScrollView
//
//  Created by Matt Tian on 19/03/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

class FeedB2Cell: FeedBCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.7, alpha: 1)
    }
    
    private func setupViews() {
        addSubview(collectionView)
        addConstraints(format: "H:|[v0]|", views: collectionView)
        addConstraints(format: "V:|[v0]|", views: collectionView)
    }

    override lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .green
        return collection
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
