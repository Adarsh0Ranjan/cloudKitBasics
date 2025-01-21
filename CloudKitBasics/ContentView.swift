//
//  ContentView.swift
//  CloudKitBasics
//
//  Created by Adarsh Ranjan on 21/01/25.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @StateObject var viewModel = CloudKitViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: viewModel.isSignedInToiCloud ? "icloud.fill" : "icloud.slash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(viewModel.isSignedInToiCloud ? .green : .red)
            
            Text(viewModel.isSignedInToiCloud ? "Signed into iCloud" : "Not signed into iCloud")
                .font(.title2)
                .fontWeight(.bold)
            
            if !viewModel.error.isEmpty {
                Text(viewModel.error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
    }
}

class CloudKitViewModel: ObservableObject {
    
    @Published var isSignedInToiCloud = false
    @Published var error = ""
    init() {
        getCloudKitStatus()
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

#Preview {
    ContentView()
}
