//
//  NetworkError.swift
//  ContactList
//
//  Created by Shak Feizi on 5/14/21.
//

import UIKit


enum NetworkError: LocalizedError {
    
    
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordsFound
    
    var errorDescription: String? {
        
        switch self {
        
        case .ckError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .couldNotUnwrap:
            return "There was an error unwrapping the yak."
        case .unexpectedRecordsFound:
            return "Unexpected records returned when trying to delete."
        }
    }
}
