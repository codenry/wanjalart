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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell"
            , for: indexPath)
        return cell
    }
    
    
}




