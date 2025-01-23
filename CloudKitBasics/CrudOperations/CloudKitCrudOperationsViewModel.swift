//
//  CloudKitCrudOperationsViewModel.swift
//  CloudKitBasics
//
//  Created by Adarsh Ranjan on 23/01/25.
//


import CloudKit

class CloudKitCrudOperationsViewModel: ObservableObject {
    @Published var inputText: String = ""
    
    func addButtonPresssed(book: String) {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        let newBook = CKRecord(recordType: "Books")
        newBook["name"] = book
        saveItem(record: newBook)
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { savedRecord, error in
            if let error = error {
                print("Error saving record: \(error.localizedDescription)")
            } else if let savedRecord = savedRecord {
                print("Successfully saved record with ID: \(savedRecord.recordID)")
            }
        }
    }
}

