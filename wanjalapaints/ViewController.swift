//
//  ViewController.swift
//  wanjalapaints
//
//  Created by henry.wanjala.dev on 2019-08-21.
//  Copyright © 2019 henry.wanjala.dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var paintingsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintingsCollectionView.delegate = self
        paintingsCollectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell"
            , for: indexPath) as! SectionCollectionViewCell
        
        let section = sections[indexPath.row]
        cell.titleLabel.text = section["title"]
        cell.captionLabel.text = section["caption"]
        cell.coverImageView.image = UIImage(named: section["image"]!)
        return cell
    }
    
    
}




