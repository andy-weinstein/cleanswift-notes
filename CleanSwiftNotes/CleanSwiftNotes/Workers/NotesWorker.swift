//
//  NotesWorker.swift
//  CleanSwiftNotes
//
//  Created by Andy Weinstein on 15 Tevet 5780.
//  Copyright © 5780 AW. All rights reserved.
//

import Foundation


class NotesWorker
{
    var notesStore: NotesStoreProtocol
    
    init(notesStore: NotesStoreProtocol)
    {
        self.notesStore = notesStore
    }
    
    func generateNoteID() -> String
    {
        let id = "\(arc4random())"
        if (id == INVALID_NOTE_ID) {
            return generateNoteID()
        }
        else {
            return id
        }
    }
    
    
    func fetchNotes(completionHandler: @escaping ([Note]) -> Void)
    {
        notesStore.fetchNotes { (notes: () throws -> [Note]) -> Void in
            do {
                let notes = try notes()
                DispatchQueue.main.async {
                    completionHandler(notes)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    
    func createNote(completionHandler: @escaping (Note?) -> Void)
    {
        let id = generateNoteID()
        notesStore.createNote(id: id) { (note: () throws -> Note?) -> Void in
            do {
                let note = try note()
                DispatchQueue.main.async {
                    completionHandler(note)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    func eraseNote(id: String, completionHandler: @escaping (Note?) -> Void)
    {
        notesStore.eraseNote(id: id) { (note: () throws -> Note?) -> Void in
            do {
                let note = try note()
                DispatchQueue.main.async {
                    completionHandler(note)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func saveNote(noteToSave: Note, completionHandler: @escaping (Note?) -> Void)
    {
        notesStore.saveNote(noteToSave: noteToSave) { (note: () throws -> Note?) -> Void in
            do {
                let note = try note()
                DispatchQueue.main.async {
                    completionHandler(note)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func permaDeleteErasedNotes(completionHandler: @escaping (Bool) -> Void) {
        notesStore.permaDeleteErasedNotes() { (permaDel: () throws -> Bool) -> Void in
            do {
                let success = try permaDel()
                DispatchQueue.main.async {
                    completionHandler(success)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            }
        }
    }
}

// MARK: - Orders store API

protocol NotesStoreProtocol
{
    // MARK: CRUD operations - Inner closure
    
    func fetchNotes(completionHandler: @escaping (() throws -> [Note]) -> Void)
    func createNote(id: String, completionHandler: @escaping (() throws -> Note?) -> Void)
    func eraseNote(id: String, completionHandler: @escaping (() throws -> Note?) -> Void)
     func saveNote(noteToSave: Note, completionHandler: @escaping (() throws -> Note?) -> Void)
    func permaDeleteErasedNotes(completionHandler: @escaping (() throws -> Bool) -> Void)
    
}


enum NotesStoreResult<U>
{
    case Success(result: U)
    case Failure(error: NotesStoreError)
}

// MARK: - Notes store CRUD operation errors

enum NotesStoreError: Equatable, Error
{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

func ==(lhs: NotesStoreError, rhs: NotesStoreError) -> Bool
{
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}
