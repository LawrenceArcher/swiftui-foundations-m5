//
//  ContentModel.swift
//  LearningApp
//
//  Created by Lawrence Archer on 28/09/2021.
//

import Foundation

class ContentModel: ObservableObject {
    @Published var modules = [Module]()
    
    //Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    
    
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
}
