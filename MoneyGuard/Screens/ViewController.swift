//
//  ViewController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 27.07.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let exampleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        setubSubviews()
    }
    
    
}

extension ViewController {
    private func setubSubviews() {
        view.addSubview(exampleView)
        
        exampleView.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        exampleView.backgroundColor = .yellow
    }
}
