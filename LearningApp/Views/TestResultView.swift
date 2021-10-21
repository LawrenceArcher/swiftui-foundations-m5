//
//  TestResultView.swift
//  LearningApp
//
//  Created by Lawrence Archer on 17/10/2021.
//

import SwiftUI

struct TestResultView: View {
    @EnvironmentObject var model:ContentModel
    var numCorrect:Int
    var resultHeading: String {
        guard model.currentModule != nil else {
            return ""
        }
        let pct = Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        if pct > 0.5 {
            return "Aweseome"
        } else if pct > 0.2 {
            return "Doing great"
        } else {
            return "Keep learning."
        }
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Text(resultHeading)
                .font(.title)
            Spacer()
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            Spacer()
            Button {
                // Send the user back to the home view
                model.currentTestSelected = nil
            } label: {
                ZStack {
                    RectangleCard(color: .green) // why do you need the argument label here?
                        .frame(height: 48)
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            Spacer()
            
        }
    }
}
