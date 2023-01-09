//
//  DBHelper.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import Foundation
import UIKit
import SQLite3

class DBHelper {
    let dbPath: String = "myDb.sqlite"
    var database: OpaquePointer?

    init() {
        database = openDatabase()
        createtable()
    }

    func openDatabase() -> OpaquePointer? {
        do {
            let fileUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
            var db: OpaquePointer?
            if sqlite3_open(fileUrl.path, &db) == SQLITE_OK {
                return db
            } else {
                print("error while opening the database")
                return nil
            }
        } catch(let error) {
            print(error.localizedDescription)
        }

        return nil
    }
    // noteList
    // Create Table
    func createtable() {
        let createTableStr = "CREATE TABLE IF NOT EXISTS noteList(id INTEGER PRIMARY KEY, title TEXT, priority TEXT, date TEXT, status TEXT, description TEXT);"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableStr, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_OK {
                print("table successfully created.")
            } else {
                print("something went wrong.")
            }
        } else {
            print("create table statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    // Insert data
    
    func insertData(notesList: NotesModel) {
        let insertQuary = "INSERT INTO noteList(id,title,priority,date,status,description) VALUES(?,?,?,?,?,?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, insertQuary, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(notesList.id))
            sqlite3_bind_text(insertStatement, 2, (notesList.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (notesList.priority as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (notesList.date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (notesList.status as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (notesList.description as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_OK {
               // completion("data inserted successfully")
                print("data inserted successfully.")
            } else {
                print("could not insert row.")
            }
        } else {
            print("insert statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    // Featch data
    func featchItemList() -> [NotesModel] {
        let featchQuery = "SELECT * FROM noteList"
        var featchQuaryStatement: OpaquePointer?
        var notesDetail : [NotesModel] = []
        if sqlite3_prepare_v2(database, featchQuery, -1, &featchQuaryStatement, nil) == SQLITE_OK {
            while sqlite3_step(featchQuaryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(featchQuaryStatement, 0))
                let title = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 1)))
                let priority = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 2)))
                let date = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 3)))
                let status = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 4)))
                let description = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 5)))
                notesDetail.append(NotesModel(id: Int(id), title: title, priority: priority, date: date, status: status, description: description))
            }
        } else {
            print("select statement not prepared")
        }
        sqlite3_finalize(featchQuaryStatement)
        return notesDetail
    }
    
    func deleteItem(itemId: Int32, index: Int, completion: @escaping (String) -> Void)
    {
        let deleteQuary = "DELETE FROM noteList WHERE id = ?;"
        var deleteQuaryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, deleteQuary, -1, &deleteQuaryStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(deleteQuaryStatement, 1, itemId)
            
            if sqlite3_step(deleteQuaryStatement) == SQLITE_DONE
            {
                completion("Successfully deleted row.")
                print("Successfully deleted row.")
            }
            else
            {
                print("Could not delete row.")
            }
        }
        else
        {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteQuaryStatement)
        print("delete")
    }
    
    func updateItem(id: Int32, status: String)
    {

        let updateQuary = "UPDATE noteList SET status = '\(status)' WHERE id = \(id);"
        var updateQuaryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, updateQuary, -1, &updateQuaryStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(updateQuaryStatement, 1, id)
            
            if sqlite3_step(updateQuaryStatement) == SQLITE_DONE
            {
                //completion("Successfully update row")
                print("Successfully update row.")
            }
            else
            {
                print("Could not update row.")
            }
        }
        else
        {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateQuaryStatement)
        print("update")
    }
}
