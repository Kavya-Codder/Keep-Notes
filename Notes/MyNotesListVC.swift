//
//  MyNotesListVC.swift
//  Notes
//
//  Created by Sunil Developer on 08/01/23.
//

import UIKit

class MyNotesListVC: UIViewController {
    
    var dbHelperObj: DBHelper = DBHelper()

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var notesListTV: UITableView!
    var obj: NotesModel?
    
    var notesArray: [NotesModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        notesListTV.delegate = self
        notesListTV.dataSource = self
        notesListTV.register(UINib(nibName: MyNotesTVC.identifier, bundle: nil), forCellReuseIdentifier: MyNotesTVC.identifier)
        
       notesArray = dbHelperObj.featchItemList()
    }
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
        navigationController?.pushViewController(vc, animated: true)
}
    override func viewWillAppear(_ animated: Bool) {
        self.notesListTV.reloadData()
    }
}
// Extension

extension MyNotesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesListTV.dequeueReusableCell(withIdentifier: MyNotesTVC.identifier, for: indexPath) as! MyNotesTVC
        let obj = notesArray[indexPath.row]
        cell.lblCountNumber.text = "\(indexPath.row + 1)"
        cell.lblTitle.text = obj.title
        cell.lblDate.text = obj.date
        cell.lblStatus.text = "Status: \(obj.status)"
        cell.lblDescription.text = "Body: \(obj.description)"
        cell.lblPriority.text = "Priority: \(obj.priority)"
        if cell.lblPriority.text == "Urgent" {
            cell.viewContainer.backgroundColor = UIColor.red
            cell.lblTitle.tintColor = UIColor.white
            cell.lblDescription.tintColor = UIColor.white
        }
        
        // Delete item
        cell.deleteNotes = {
            let alertVC = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
            let yesBtn = UIAlertAction(title: "YES", style: .destructive) { (alert) in
                
                let obj = self.notesArray[indexPath.row]
                self.dbHelperObj.deleteItem(itemId: Int32(obj.id), index: indexPath.row, completion: {
                    (msg) in
                    self.notesArray.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.notesListTV.reloadData()
                    }
                })
            }
            let noBtn = UIAlertAction(title: "NO", style: .default) { (alert) in
                self.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(yesBtn)
            alertVC.addAction(noBtn)
            self.present(alertVC, animated: true, completion: nil)
        }
        // edit item
        cell.editNotes = {
            let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddNotesViewController") as! AddNotesViewController
            editVC.obj = self.notesArray[indexPath.row]
            
            self.navigationController?.pushViewController(editVC, animated: false)
            
        }
        
        return cell
    }
    
    
}
