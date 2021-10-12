//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Lawrence Archer on 08/10/2021.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            // Only show video if there is a valid URL
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description
            CodeTextView()
            
            // Next Lesson button only if there is a next lesson
            if model.hasNextLesson() {
                Button (action: {
                    // Advance the lesson
                    model.nextLesson()
                }, label: {
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Next Lesson - \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                })
            }
            else {
                // show complete button
                Button (action: {
                    // Take the user back to the homeview
                    model.currentContentSelected = nil
                }, label: {
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                           
                        Text("Complete Lesson!")
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                })
            }
        }
        .padding(5)
        .navigationBarTitle(lesson?.title ?? "")
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
