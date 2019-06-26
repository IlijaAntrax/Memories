//
//  ViewModelDelegate.swift
//  Memories
//
//  Created by Ilija Antonjevic on 24/06/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelDelegate:class {
    func configure(_ cell: UICollectionViewCell)
    func saveData()
    func loadData()
}
