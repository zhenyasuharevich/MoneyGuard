//
//  LastTransactions.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/08/2021.
//

import UIKit

class LastTransactions: UIView {
  
  private let transactionsButtonTitle = UILabel()
  private let disclosureIndicator = UILabel()
  private let transactionsButton = UIButton()
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.dataSource = self
    cv.delegate = self
    cv.showsVerticalScrollIndicator = false
    cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubViews()
    setupForTransactionsButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func buttonAction(_ sender:UIButton!) {
    print("Button tapped")
  }
  
  private func setupForTransactionsButton() {
    transactionsButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
  }
  
}

extension LastTransactions : UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 6 }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
    cell.backgroundColor = .white
    cell.layer.cornerRadius = 20
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
}

extension LastTransactions {
  private func setupSubViews() {
    self.addSubview(transactionsButton)
    transactionsButton.addSubview(transactionsButtonTitle)
    transactionsButton.addSubview(disclosureIndicator)
    self.addSubview(collectionView)
    
    transactionsButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    transactionsButtonTitle.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(0)
      
    }
    transactionsButtonTitle.text = "Last transactions"
    
    disclosureIndicator.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview().offset(0)
    }
    
    disclosureIndicator.text = ">"
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(transactionsButtonTitle.snp.bottom).offset(20)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(UIScreen.main.bounds.height > 736 ? 170 : 140)
    }
    
    collectionView.backgroundColor = .none
    
  }
  
}
