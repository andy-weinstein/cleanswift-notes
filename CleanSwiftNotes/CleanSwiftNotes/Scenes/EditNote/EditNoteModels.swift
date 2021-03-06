//
//  EditNoteModels.swift
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

enum EditNote
{
  // MARK: Use cases
  
  enum ShowNote
  {
    struct Request
    {
        var note : Note?
    }
    struct Response
    {
        var note : Note?
    }
    struct ViewModel
    {
        var note: Note?
    }
  }
    
    enum CreateNote
    {
        struct Request
        {
        }
        struct Response
        {
            var note : Note?
        }
        struct ViewModel
        {
            var note: Note?
        }
    }
}
