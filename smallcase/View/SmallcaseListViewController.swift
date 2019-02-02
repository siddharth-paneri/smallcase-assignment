//
//  SmallcaseListViewController.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
import AlamofireImage

class SmallcaseListViewController: UIViewController {
    
    //MARK:-
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private var selectedSmallcase : String = ""
    var smallcases: [String] = []

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All smallcases"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let smallcaseController = SmallcaseController()
        smallcases = smallcaseController.getAllSmalcases()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_IDENTIFIER {
            let vc = segue.destination as! SmallcaseDetailViewController
            vc.scid = selectedSmallcase
        }
    }
 
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension SmallcaseListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallcases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallcaseCell", for: indexPath) as! SmallcaseCell
        cell.imageView.af_setImage(withURL: URL(string: BASE_URL_IMAGES+"/80/\(smallcases[indexPath.item]).png")!, placeholderImage: UIImage(named: "smallcase_Placeholder"))
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSmallcase = smallcases[indexPath.item]
        performSegue(withIdentifier: SEGUE_IDENTIFIER, sender: self)
    }
    
}



//MARK:-
class SmallcaseCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
