//
//  EditNoteInteractor.swift
//  CleanSwiftNotes
//
//  Created by Andy Weinstein on 16 Tevet 5780.
//  Copyright (c) 5780 AW. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditNoteBusinessLogic
{
    func createNote(request: EditNote.CreateNote.Request)
    func showNoteToEdit(request: EditNote.ShowNote.Request)
      func saveUpdatedNote(request: EditNote.ShowNote.Request)
}

protocol EditNoteDataStore
{
  var note: Note? { get set }
}

class EditNoteInteractor: EditNoteBusinessLogic, EditNoteDataStore
{

    var presenter: EditNotePresentationLogic?
    var worker = EditNoteWorker()
    var note: Note?
    
    // MARK: - Save updated note
    func saveUpdatedNote(request: EditNote.ShowNote.Request) {
        self.note = request.note
    }
  
    // MARK: - Create note
    
    func createNote(request: EditNote.CreateNote.Request)
    {
        worker.createNote() { (note: Note?) in
            self.note = note
            let response = EditNote.CreateNote.Response(note: note)
            self.presenter?.presentCreatedNote(response: response)
        }
    }
    
    // MARK: - Edit note
    
    func showNoteToEdit(request: EditNote.ShowNote.Request)
    {
        if (request.note == nil){
            let createRequest = EditNote.CreateNote.Request()
            createNote(request: createRequest)
        }
        else if let noteToEdit = request.note {
            let response = EditNote.ShowNote.Response(note: noteToEdit)
            presenter?.presentNoteToEdit(response: response)
        }
    }
}
