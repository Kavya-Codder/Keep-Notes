//
//  NotesModel.swift
//  Notes
//
//  Created by Sunil Developer on 08/01/23.
//

import Foundation
class NotesModel {
    var id: Int = 0
    var title: String = ""
    var priority: String = ""
    var date: String = ""
    var status: String = ""
    var description: String = ""
    
    init(id: Int, title: String, priority: String, date: String, status: String, description: String) {
        self.id = id
        self.title = title
        self.priority = priority
        self.date = date
        self.status = status
        self.description = description
    }
}
