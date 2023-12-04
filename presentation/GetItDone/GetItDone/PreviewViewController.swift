//
//  PreviewViewController.swift
//  GetItDone
//
//  Created by Saarath Rathee on 2023-12-01.
//

import UIKit
import CoreData

class PreviewViewController: UIViewController {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var deatilsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var getTitle:String!
    var getDetails:String!
    var getDate:String!
    var getUuid:String!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deatilsLabel.text = getDetails
        titleLabel.text = getTitle
        dateLabel.text = getDate
        // Do any additional setup after loading the view.
    }
    

    @IBAction func removeAction(_ sender: Any) {
        if(getUuid != nil){
            
            let fetchRequest: NSFetchRequest<TasksData> = TasksData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", getUuid)
            
            do{
                let results = try context.fetch(fetchRequest)
                if let taskToDelete = results.first{
                    context.delete(taskToDelete)
                    try context.save()
                    //redirect
                    navigationController?.popViewController(animated: true)
                    
                }
            }catch{
                print("Error during deleting the Object with UUID - \(getUuid)")
            }
        }else{
            let fetchRequest: NSFetchRequest<TasksData> = TasksData.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "taskDescription == %@", getDetails)
            
            do{
                let results = try context.fetch(fetchRequest)
                for result in results {
                    context.delete(result)
                }
                try context.save()
                    //redirect
                navigationController?.popViewController(animated: true)
                    
                }
            catch{
                print("Error during deleting the Object with UUID - \(getDate)")
            }
        }
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
