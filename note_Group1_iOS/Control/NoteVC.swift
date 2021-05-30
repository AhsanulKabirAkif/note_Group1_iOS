//
//  NoteVC.swift
//  note_Group1_iOS
//
//  Created by Ahsanul Kabir on 29/5/21.
//  Copyright © 2021 Ahsanul Kabir. All rights reserved.
//

import UIKit

class NoteVC: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    
    // selected notes of NoteTVC
    var selectedNotes: Note? {
        didSet {
            editMode = true
        }
    }
    
    // declaring instance of NoteTVC
    weak var delegate: NoteTVC?
    
    // edit mode by default is false
    var editMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        noteTextView.text = selectedNotes?.title
    }
    override func viewWillDisappear(_ animated: Bool) {
        if editMode {
            delegate?.deleteNote(note: selectedNotes!)
        }
        guard noteTextView.text != ""else {return}
        delegate?.updateNote(with: noteTextView.text)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
