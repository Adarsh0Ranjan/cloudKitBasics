//
//  CloudKitCrudOperations.swift
//  CloudKitBasics
//
//  Created by Adarsh Ranjan on 23/01/25.
//

import SwiftUI

struct CloudKitCrudOperations: View {
    @StateObject var viewModel = CloudKitCrudOperationsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with Emojis
                Text("☁️ CloudKit CRUD ✏️")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                Text("Manage your cloud data seamlessly! 🚀")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Styled Text Field
                TextField("✍️ Enter text here...", text: $viewModel.inputText)
                    .keyboardType(.default)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                    )
                    .padding(.horizontal, 20)
                
                // Styled Button
                Button(action: {
                    print("Button tapped with input: \(viewModel.inputText)")
                    viewModel.addButtonPresssed(book: viewModel.inputText)
                    viewModel.inputText.removeAll()
                }) {
                    Text("🚀 Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}
