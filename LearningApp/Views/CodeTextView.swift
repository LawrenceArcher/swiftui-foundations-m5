//
//  CodeTextView.swift
//  LearningApp
//
//  Created by Lawrence Archer on 11/10/2021.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        
        return textView
    }
    func updateUIView(_ textView: UITextView, context: Context) {
        // Set attributed text for the lesson
        textView.attributedText = model.lessonDescription
        // Scroll back to the top
    }
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}