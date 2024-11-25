//
//  SwiftUIView.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 25.11.2024.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("Пример контента для деления")
                .padding()
            
            ShareButton(content: "Посмотрите этот замечательный контент!")
        }
    }
}

struct ShareButton: View {
    var content: String
    
    var body: some View {
        Button(action: {
            shareContent(content)
        }) {
            Text("Поделиться")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    func shareContent(_ content: String) {
        let activityController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(activityController, animated: true, completion: nil)
        }
    }
}

#Preview {
    SwiftUIView()
}
