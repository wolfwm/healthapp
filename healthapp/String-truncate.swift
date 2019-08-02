//
//  String-truncate.swift
//  healthapp
//
//  Created by Wolfgang Walder on 02/08/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import Foundation

extension String {
    enum TruncationPosition {
        case head
        case middle
        case tail
    }
    
    func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "...") -> String {
        guard self.count > limit else { return self }
        
        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))
            
            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            var truncatedString = self.prefix(limit)
            
            while truncatedString.last == " " {
                truncatedString = truncatedString.dropLast()
            }
            return truncatedString + leader
        }
    }
}
