//
//  Contact.swift
//  ContactList
//
//  Created by Shak Feizi on 5/14/21.
//

import UIKit
import CloudKit


class Contact {
    
    var name: String
    var phoneNumber: String
    var email: String
    let recordID: CKRecord.ID
    
    init(name: String, phoneNumber: String, email: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
} //End of class


// Shak notes: Extensions
// Contact
extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[CloudKeys.nameTypeKey] as? String,
              let phoneNumber = ckRecord[CloudKeys.phoneNumberTypeKey] as? String,
              let email = ckRecord[CloudKeys.emailTypeKey] as? String else { return nil }
        
        self.init(name: name, phoneNumber: phoneNumber, email: email, recordID: ckRecord.recordID)
    }
}
// CKRecord
extension CKRecord {
    
    convenience init(contact: Contact) {
        
        self.init(recordType: CloudKeys.recordTypeKey, recordID: contact.recordID)
        
        self.setValuesForKeys([
        
            CloudKeys.nameTypeKey : contact.name,
            CloudKeys.phoneNumberTypeKey : contact.phoneNumber,
            CloudKeys.emailTypeKey : contact.email
        ])
    }
}
// Equatable
extension Contact: Equatable {
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
