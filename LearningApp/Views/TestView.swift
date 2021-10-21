//
//  TestView.swift
//  LearningApp
//
//  Created by Lawrence Archer on 16/10/2021.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        if model.currentQuestion != nil {
            VStack (alignment: .leading){
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            Button {
                                // Track the selected index
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    
                                    if submitted == false {
                                        // Everything is normal - no choice has been made yet
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray: .white)
                                            .frame(height: 48)
                                    } else {
                                        // Answer has been submitted - can change the background color of the option selected
                                        if (index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex) || (index == model.currentQuestion!.correctIndex) {
                                            
                                            // Show a green background - user has selected the right answer
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            // Show a red background - user has selected the wrong answer
                                            RectangleCard(color: Color.red)
                                                .frame(height: 48)
                                        } else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                            }
                            .disabled(submitted)
                        }
                        
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                
                // Button
                Button {
                    //Check if answer has been submitted
                    if submitted == true {
                        // Answer has already been submitted, move to next question
                        model.nextQuestion()
                        
                        // reset properties
                        submitted = false
                        selectedAnswerIndex = nil
                    } else {
                        // Submit the answer
                        //Change submitted state to true
                        submitted = true
                        // Check the answer and increment counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)

                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // If current question is nil, we show the result view
            TestResultView(numCorrect: numCorrect)
            // Test hasn't loaded yet - need this because .onAppear in homeView doens't run correctly in iOS 14.5 +
            ProgressView()
        }
    }
    
    var buttonText: String {
        // Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // this is the last question
                return "Finish"
            }
            // there is a next question
            return "Next"
        } else {
            // answer has not yet been submitted
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
