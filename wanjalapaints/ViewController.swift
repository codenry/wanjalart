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
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HomeToSection", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToSection" {
            let toViewController = segue.destination as! SectionViewController
            let indexPath = sender as! IndexPath
            let section = sections[indexPath.row]
            toViewController.section = section
            toViewController.sections = sections
            toViewController.indexPath = indexPath
            
        }
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
           //coder here in the future
            
        }
        if let paintingsCollectionView = scrollView as? UICollectionView {
            for cell in paintingsCollectionView.visibleCells as! [SectionCollectionViewCell] {
                let indexPath = paintingsCollectionView.indexPath(for: cell)!
                let attributes = paintingsCollectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = paintingsCollectionView.convert(attributes.frame, to: view)
                let translationX = cellFrame.origin.x / 5
                cell.coverImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                cell.layer.transform = animateCell(cellFrame: cellFrame)
                
            }
            
        }
    }
    
    func animateCell(cellFrame: CGRect) -> CATransform3D {
        let angleFromX = Double((-cellFrame.origin.x) / 10)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.6
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
        
        return CATransform3DConcat(rotation, scale)
    }
}

