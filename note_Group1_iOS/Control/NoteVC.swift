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
    
    weak var delegate: NoteTVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
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
