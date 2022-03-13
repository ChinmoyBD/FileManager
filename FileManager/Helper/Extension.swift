//
//  URL+Extension.swift
//  FileManager
//
//  Created by Chinmoy Biswas on 6/3/22.
//

import Foundation
import UIKit

extension URL {

    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

