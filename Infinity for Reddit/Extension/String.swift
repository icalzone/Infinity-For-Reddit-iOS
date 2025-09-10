//
//  String.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-24.
//

extension String {
    func matches(_ pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
    
    func substring(from index: Int) -> String {
        guard index < count else {
            return ""
        }
        
        let start = self.index(startIndex, offsetBy: index)
        return String(self[start...])
    }
}
