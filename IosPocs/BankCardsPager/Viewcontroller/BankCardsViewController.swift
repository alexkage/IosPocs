//
//  BankCardsViewController.swift
//  IosPocs
//
//  Created by Jose Flavio Quispe Irrazabal on 21/2/17.
//  Copyright © 2019 AlexKage. All rights reserved.
//

import UIKit

class BankCardsViewController: UIViewController {
    
    private let cellIdent = "BankCardCell"
    @IBOutlet weak var bankCardsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    private func setUpCollectionView(){
        self.bankCardsCollectionView.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 300)
        self.bankCardsCollectionView.delegate = self
        self.bankCardsCollectionView.dataSource = self
        self.bankCardsCollectionView.isScrollEnabled = true
        self.bankCardsCollectionView.isPagingEnabled = true
        self.bankCardsCollectionView.backgroundColor = .gray
        self.bankCardsCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
    }
    
}

extension BankCardsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension BankCardsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.bankCardsCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdent, for: indexPath) as! BankCardCell
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
}
