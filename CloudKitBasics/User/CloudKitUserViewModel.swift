//
//  CloudKitUserViewModel.swift
//  CloudKitBasics
//
//  Created by Adarsh Ranjan on 22/01/25.
//

import Foundation
import CloudKit

class CloudKitUserViewModel: ObservableObject {
    @Published var isSignedInToiCloud = false
    @Published var error = ""
    @Published var userName: String? = ""
    @Published var permissionStatus = false
    init() {
        getCloudKitStatus()
    }
    
    func discoverCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { identity, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error discovering user identity: \(error.localizedDescription)")
                    return
                }
                
                if let identity = identity {
                    let firstName = identity.nameComponents?.givenName ?? "Unknown"
                    let lastName = identity.nameComponents?.familyName ?? "Unknown"
                    print("User name: \(firstName) \(lastName)")
                    self.userName = "\(firstName) \(lastName)"
                } else {
                    print("No user identity found.")
                }
            }
        }
    }
    
    func fetchiCloudUserId() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching iCloud user ID: \(error.localizedDescription)")
                    return
                }
                
                if let recordID = recordID {
                    print("Fetched iCloud user ID: \(recordID.recordName)")
                    // You can now use this record ID to fetch user identity details if needed
                    self.discoverCloudUser(id: recordID)
                } else {
                    print("No iCloud user ID found.")
                }
            }
        }
    }
    
    func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting permission: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .granted:
                    print("User discoverability permission granted.")
                    self.permissionStatus = true
                    self.fetchiCloudUserId()  // Proceed to fetch user ID after permission is granted
                case .denied:
                    print("User discoverability permission denied.")
                case .couldNotComplete:
                    print("Could not complete the permission request. Try again later.")
                case .initialState:
                    print("User has not been prompted yet for permission.")
                @unknown default:
                    print("Unknown permission status.")
                }
            }
        }
    }

    func getCloudKitStatus() {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                let accountStatus: CloudKitAccountStatus
                switch status {
                case .couldNotDetermine:
                    accountStatus = .couldNotDetermine
                case .available:
                    accountStatus = .available
                case .restricted:
                    accountStatus = .restricted
                case .noAccount:
                    accountStatus = .noAccount
                case .temporarilyUnavailable:
                    accountStatus = .temporarilyUnavailable
                @unknown default:
                    accountStatus = .couldNotDetermine
                }
                
                if accountStatus == .available {
                    self.isSignedInToiCloud = true
                    self.requestPermission()
                } else {
                    self.error = accountStatus.errorMessage
                }
            }
        }
    }

    enum CloudKitAccountStatus {
        case couldNotDetermine
        case available
        case restricted
        case noAccount
        case temporarilyUnavailable

        var errorMessage: String {
            switch self {
            case .couldNotDetermine:
                return "Unable to determine iCloud account status. Please try again later."
            case .available:
                return "iCloud account is available and ready to use."
            case .restricted:
                return "Access to iCloud is restricted. Please check your settings."
            case .noAccount:
                return "No iCloud account found. Please sign in to iCloud."
            case .temporarilyUnavailable:
                return "iCloud services are temporarily unavailable. Try again later."
            }
        }
    }
}
