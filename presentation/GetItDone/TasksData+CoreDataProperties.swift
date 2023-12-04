//
//  TasksData+CoreDataProperties.swift
//  GetItDone
//
//  Created by Saarath Rathee on 2023-12-01.
//
//

import Foundation
import CoreData


extension TasksData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksData> {
        return NSFetchRequest<TasksData>(entityName: "TasksData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskStatus: Int64
    @NSManaged public var taskType: String?
    @NSManaged public var title: String?
    @NSManaged public var uuid: String?

}

extension TasksData : Identifiable {

}
