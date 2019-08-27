//
//  ViewController.swift
//  wanjalapaints
//
//  Created by henry.wanjala.dev on 2019-08-21.
//  Copyright © 2019 henry.wanjala.dev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var paintingsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    var isStatusBarHidden = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.delegate = self
        paintingsCollectionView.delegate = self
        paintingsCollectionView.dataSource = self
        addBlurStatusBar()
        //setStatusBarBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isStatusBarHidden = false
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)
        ]
        
    }
    
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToSection" {
            let toViewController = segue.destination as! SectionViewController
            let indexPath = sender as! IndexPath
            let section = sections[indexPath.row]
            toViewController.section = section
            toViewController.sections = sections
            toViewController.indexPath = indexPath
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }
    
    func addBlurStatusBar() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let blur = UIBlurEffect(style: .dark)
        let blurStatusBar = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
        blurStatusBar.effect = blur
        view.addSubview(blurStatusBar)
    }
}



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    

}


extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let navigationIsHidden = offsetY <= 0
        navigationController?.setNavigationBarHidden(navigationIsHidden, animated: true)
        
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

