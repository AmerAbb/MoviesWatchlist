//
//  UITableView+Ext.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}

