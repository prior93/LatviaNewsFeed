//
//  item.swift
//  NewsFeed
//
//  Created by parashar.r.adhikary on 12/02/2021.
//

import Foundation
import Gloss


struct Item: JSONDecodable{
    
    var description: String
    var title: String
    var url: String
    
    init?(json: JSON) {
        self.title = "title" <~~ json ?? ""
        self.description = "description" <~~ json ?? ""
        self.url = "url" <~~ json ?? ""
    }
    
}
