//
//  ContentModel.swift
//  LearningApp
//
//  Created by Lawrence Archer on 28/09/2021.
//

import Foundation
import SwiftUI

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    //Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        // Parse local included data
        getLocalData()
        // Download remote json file and parse data
        getRemoteData()
    }
    
    // MARK: Data Methods
    func getLocalData() {
        // get url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // read the fiel into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // try to decode the json into an array of objects
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // assign parsed modules to module property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        
        // Parse the stayle data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do {
            //Read file into a data object
            let styleData = try  Data(contentsOf: styleUrl!)
            self.styleData = styleData
        }
        catch {
            //Log error
            print("Couldn't parse style data")
        }
        
    }
    
    func getRemoteData() {
        //String path
        let urlString = "https://lawrencearcher.github.io/swiftui-learningAppData/data2.json"
        //Create a URL object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create URL
            return
        }
        //Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the ssession and kick off the task
        let session = URLSession.shared
                
        let dataTask = session.dataTask(with: request) { data, response, error in
            // Check if there is an error
            guard error == nil else {
                // There was an error
                print(error!)
                return
            }
            
            do {
                // Create json decoder
                let decoder = JSONDecoder()
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                DispatchQueue.main.async {
                    // Append parsed modules into modules property
                    self.modules += modules
                }
               
            } catch {
                // Couldn't parse JSON
            }
            
        }
        // Kick off the data task - could also add .resume() to the end of the dataTask definition if preferred!
        dataTask.resume()
    }
    
    // MARK: Module Navigation methods
    func beginModule(_ moduleid: Int) {
        // Find the index for this module ID
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                currentModuleIndex = index
                break
            }
        }
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex: Int) {
        // Check that the lesson index is within range of module lesosns
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule?.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        guard currentModule != nil else {
            return false
        }
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        
        // check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            //set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        } else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
        
    }
    
    func beginTest(_ moduleId: Int) {
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // If there are questions set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // set the current content as well
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        // Advance the question index
        currentQuestionIndex += 1
        // Check that it's within bounds
        if currentQuestionIndex < currentModule!.test.questions.count {
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        } else {
            // If not, reset properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
        
    }
    
    
    // Mark: - Code styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        //Add styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // Add HTML data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }

        return resultString
    }
    
}
