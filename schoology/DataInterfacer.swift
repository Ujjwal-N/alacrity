//
//  DataInterfacer.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 9/29/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
class DataInterfacer{
    static let key = "7c270332678c7a6b89071cd10710e9a005b90a3e0"
    static let secret = "cdb78f5da6683593c4a8ae0729484d46"
    var token = ""
    var tokenSecret = ""
    var sections : [Section] = [Section]()
    var assignments : [Int:[Assignment]] = [Int:[Assignment]]()
    var userId = ""
    
    init(token : String, tokenSecret : String, topVC : DataInterfacerVC) {
        self.token = token
        self.tokenSecret = tokenSecret
        if let exists = UserDefaults.standard.string(forKey: "userId"){
            userId = exists
            topVC.handleInit(currentInterfacer: self)
            return
        }
        
        let cc = (key: DataInterfacer.key, secret: DataInterfacer.secret)
        let uc = (key: token, secret: tokenSecret)
        
        var req = URLRequest(url: URL(string: "https://api.schoology.com/v1/messages/inbox")!)
        
        let paras = [String:String]()
        
        req.oAuthSign(method: "GET", urlFormParameters: paras, consumerCredentials: cc, userCredentials: uc)
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            else if let data = data {
                do {
                    
                    let json = try JSON(data: data)
                    let messages = json["message"]
                    var idTracker = [String:Int]()
                    for message in messages{
                        let currentKey : String = message.1["recipient_ids"].string!;
                        if idTracker.keys.contains(currentKey){
                            idTracker[currentKey] = idTracker[currentKey]! + 1;
                        }else{
                            idTracker[currentKey] = 1;
                        }
                        
                        //idTracker.append(message[json["message"]])
                    }
                    var finalId = "";
                    var max = 0;
                    for id in idTracker{
                        if(id.value > max){
                            max = id.value
                            finalId = id.key
                        }
                    }
                    UserDefaults.standard.set(finalId, forKey: "userId")
                    self.userId = finalId
                    topVC.handleInit(currentInterfacer: self)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func retriveSections(topVC : DataInterfacerVC){
        if(!sections.isEmpty){
            topVC.handleSections(currentInterfacer: self)
            return
        }
        deleteSections()
        let cc = (key: DataInterfacer.key, secret: DataInterfacer.secret)
        let uc = (key: token, secret: tokenSecret)
        let paras = [String:String]()
        var newReq = URLRequest(url: URL(string: "https://api.schoology.com/v1/users/\(userId)/sections")!)
        newReq.oAuthSign(method: "GET", urlFormParameters: paras, consumerCredentials: cc, userCredentials: uc)
        
        let newTask = URLSession(configuration: .ephemeral).dataTask(with: newReq) { (data, response, error) in
            if let error = error{
                print(error)
            }else if let data = data{
                do{
                    let json = try JSON(data: data)
                    for section in json["section"]{
                        var sectionTitle = section.1["section_title"].string!
                        let lowerBound = sectionTitle.index(sectionTitle.startIndex, offsetBy: 1)
                        sectionTitle = String(sectionTitle[...lowerBound])
                        //print(Int(sectionTitle)!)
                        if let period = Int(sectionTitle){
                            if (period < 15){
                                let currentSection = Section(context: CoreDataManager.context)
                                currentSection.difficulty = Int16(-1)
                                currentSection.averageHomeworkTime = Int16(-1)
                                currentSection.color = "#000000"
                                currentSection.period = Int16(period)
                                currentSection.preferredName = section.1["course_title"].string!
                                currentSection.schoologyID = section.1["id"].string!
                                self.sections.append(currentSection)
                                CoreDataManager.saveContext()
                            }
                        }
                        
                    }
                    if(!self.sections.isEmpty){
                        self.populateAssignmentsDict()
                    }
                    topVC.handleSections(currentInterfacer: self)
                }catch{
                    print(error.localizedDescription)
                }
                
            }
        }
        newTask.resume()
    }
    func fetchClasses() {
        let fetchRequest : NSFetchRequest<Section> = Section.fetchRequest()
        do{
            sections = try CoreDataManager.context.fetch(fetchRequest)
            if(!self.sections.isEmpty){
                self.populateAssignmentsDict()
            }
        }catch{
            print(error)
        }
    }
    func deleteSections(){
        let fetchRequest : NSFetchRequest<Section> = Section.fetchRequest()
        if let result = try? CoreDataManager.context.fetch(fetchRequest) {
            for object in result {
                CoreDataManager.context.delete(object)
            }
        }
    }
    func populateAssignmentsDict(){
        for section in sections{
            print(section.preferredName)
            assignments[Int(section.period)] = [Assignment]()
//            let testAssignment = Assignment(context: CoreDataManager.context)
//            testAssignment.name = "test assignment"
//            assignments[section]?.append(testAssignment)
//            print(assignments[section])
        }
    }
    func getRelevantAssignments(id : Int){
        fetchClasses()
        //deleteAssignmentIn(section: sections[id])
        
        let cc = (key: "7c270332678c7a6b89071cd10710e9a005b90a3e0", secret: "cdb78f5da6683593c4a8ae0729484d46")
        let uc = (key: UserDefaults.standard.string(forKey: "token")!, secret: UserDefaults.standard.string(forKey: "tokenSecret")!)
        if true{
            var req = URLRequest(url: URL(string: "https://api.schoology.com/v1/sections/\(sections[id].schoologyID)/assignments")!)
            print("https://api.schoology.com/v1/sections/\(sections[id].schoologyID)/assignments")
            print(id)
            let paras = [String:String]()
            
            req.oAuthSign(method: "GET", urlFormParameters: paras, consumerCredentials: cc, userCredentials: uc)
            
            let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
                
                if let error = error {
                    print(error)
                }
                else if let data = data {
                    do {
                        let json = try JSON(data: data)
                        if let assignments = json["assignment"].array{
                            for assignment in assignments{
                                let dateString = assignment["due"].string!
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let date = formatter.date(from: dateString){
                                    let todaysDate = Date()
                                    if(date > todaysDate){
                                        let currentAssignment = Assignment(context: CoreDataManager.context)
                                        currentAssignment.dueDate = date as NSDate
                                        currentAssignment.name = assignment["title"].string!
                                        currentAssignment.timeTook = -1
                                        currentAssignment.userCompleted = false
                                        currentAssignment.period = self.sections[id].period
                                        CoreDataManager.saveContext()
                                    }
                                }
                                
                            }
                        }
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
        
        
    }
    func fetchAssignments() {
        //TODO: Add check if assignments class has already been init
        fetchClasses()
        print(assignments)
        let fetchRequest : NSFetchRequest<Assignment> = Assignment.fetchRequest()
        do{
            let assignmentsFetched : [Assignment] = try CoreDataManager.context.fetch(fetchRequest)
            for assignment : Assignment in assignmentsFetched{
               //print(assignments)
                //print(assignment.topSection)
                self.assignments[Int(assignment.period)]!.append(assignment)
            }
            
        }catch{
            print(error)
        }

    }
    func deleteAllAssignments(){
        let fetchRequest : NSFetchRequest<Assignment> = Assignment.fetchRequest()
        if let result = try? CoreDataManager.context.fetch(fetchRequest) {
            for object in result {
                CoreDataManager.context.delete(object)
            }
        }
    }
    func deleteAssignmentIn(section : Section){
        let fetchRequest : NSFetchRequest<Assignment> = Assignment.fetchRequest()
        if let result : [Assignment] = try? CoreDataManager.context.fetch(fetchRequest) {
            for object : Assignment in result {
                if(object.period == section.period){
                    CoreDataManager.context.delete(object)
                }
            }
        }
    }
    static func saveStudyTimes(day : Int, startTime : Int, endTime : Int){
        let studyTime = StudyTime(context: CoreDataManager.context)
        studyTime.day = Int16(day)
        studyTime.startTime = Int16(startTime)
        studyTime.endTime = Int16(endTime)
        CoreDataManager.saveContext()
    }
    static func fetchStudyTimes() -> [StudyTime]{
        let fetchRequest : NSFetchRequest<StudyTime> = StudyTime.fetchRequest()
        if let result : [StudyTime] = try? CoreDataManager.context.fetch(fetchRequest){
            return result
        }
        let empty = StudyTime(context: CoreDataManager.context)
        return [empty]
    }
    static func deleteStudyTimes(){
        let fetchRequest : NSFetchRequest<StudyTime> = StudyTime.fetchRequest()
        if let result = try? CoreDataManager.context.fetch(fetchRequest) {
            for object in result {
                CoreDataManager.context.delete(object)
            }
        }
    }
}
protocol DataInterfacerVC {
    func handleInit(currentInterfacer : DataInterfacer)
    func handleSections(currentInterfacer : DataInterfacer)
}
