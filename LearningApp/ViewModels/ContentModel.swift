//
//  ContentModel.swift
//  LearningApp
//
//  Created by Lawrence Archer on 28/09/2021.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    //Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
    // MARK: Data Methods
    func getLocalData() {
        // get url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            //reda the fiel into a data object
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
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        
        // check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            //set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        } else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
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
