//
//  MRButton.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class MRSearchButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        tintColor = .systemYellow
        translatesAutoresizingMaskIntoConstraints = false
    }
}
