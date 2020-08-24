//
//  Globals.swift
//  iTuenesSearch
//
//  Created by chiranjeevi macharla on 23/08/20.
//  Copyright © 2020 Adinarayana. All rights reserved.
//

import Foundation
import UIKit

let badgeSize: CGFloat = 20
let badgeTag = 9999

enum API {
   static let albumsAPI = "https://itunes.apple.com/search?term=%@"
}

enum CellIdentifier {
   static let albumsCellIdentifier = "AlbumsTableCell"
}

enum Placeholder {
   static let albumsSearch = "Search albums"
}

enum Segue {
   static let cartScreen = "goToCartPage"
}

//Convert ISO8601 date string to date

func convertStringToDate(dateString: String) -> ( Date, String ) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from:dateString)!
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let datenew = dateFormatter.string(from: date)
    
    return (date, datenew)
       
}

func createBadgeLabel(size: CGFloat) -> UILabel {
    let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    badgeCount.tag = badgeTag
    badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
    badgeCount.textAlignment = .center
    badgeCount.layer.masksToBounds = true
    badgeCount.textColor = .white
    badgeCount.font = badgeCount.font.withSize(12)
    badgeCount.backgroundColor = .systemRed
    return badgeCount
}

func removeBadge(target: UIView) {
    if let badge = target.viewWithTag(badgeTag) {
        badge.removeFromSuperview()
    }
}

// Remove duplicates from array
extension Array {

    func removeDuplicates<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}

