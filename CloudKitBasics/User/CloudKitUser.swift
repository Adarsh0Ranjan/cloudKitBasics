//
//  CloudKitUser.swift
//  CloudKitBasics
//
//  Created by Adarsh Ranjan on 22/01/25.
//

import SwiftUI

struct CloudKitUser: View {
    @StateObject var viewModel = CloudKitUserViewModel()
    
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
            
            if viewModel.isSignedInToiCloud, let userName = viewModel.userName {
                Text("Welcome, \(userName)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            Text("Permission Granted: \(viewModel.permissionStatus ? "Yes" : "No")")
                .font(.headline)
                .foregroundColor(viewModel.permissionStatus ? .green : .orange)
            
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
