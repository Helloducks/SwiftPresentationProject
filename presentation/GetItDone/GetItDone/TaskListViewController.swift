//
//  TaskListViewController.swift
//  GetItDone
//
//  Created by Saarath Rathee on 2023-11-29.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    
    
    let pickerForType = UIPickerView()
    let datePicker = UIDatePicker()
    
    
    
    let taskTypes = ["Event","Deadline"]
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[TasksData]?
    
    var dummyData = ["dummy1","dummy2"]
    
    //View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Table was loaded")
        
        pickerForType.dataSource = self
        pickerForType.delegate = self
        
        datePicker.preferredDatePickerStyle = .compact
        
        // Do any additional setup after loading the view.
        fetchTasks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        fetchTasks()
    }
    
    func fetchTasks() {
        do{
            
            self.items = try context.fetch(TasksData.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print("Error with fetch")
        }
    }
        
        
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Cells count \(items?.count ?? 0)")
        return  (items?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let databaseDateFormat = DateFormatter()
        databaseDateFormat.dateFormat = "dd/MM/yyyy"
        let days = dayDiff(from: Date(), to: (items?[indexPath.row].date ?? Date()))
         //getting image name
        let imagePath = imagePath(daysLeft: days)
        
        let eachcell:MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell0") as! MyTableViewCell
        eachcell.titleLabel.text = items?[indexPath.row].title ?? "Null title"
        
        eachcell.dateLabel.text = String(days) + " days"
        
        
        if let imageView = eachcell.imageViewbox as? UIImageView{
            imageView.image =  UIImage(systemName: imagePath)
        }
        
        let result = (items?[indexPath.row].taskStatus == 1) ? true : false
        eachcell.statusSwitch.setOn(result,animated: true)
       
        return eachcell
    }
    
    //function when we select a cell of table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let databaseDateFormat = DateFormatter()
        databaseDateFormat.dateFormat = "dd/MM/yyyy hh:mm:ss"
        let detailVC:PreviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        detailVC.getDate = databaseDateFormat.string(from: (items?[indexPath.row].date ?? Date()))
        detailVC.getTitle = items?[indexPath.row].title
        detailVC.getDetails = items?[indexPath.row].taskDescription
        print(items?[indexPath.row].description)
        detailVC.getUuid = items?[indexPath.row].uuid
        // make it navigate to ProductDetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //PickerView dedicated functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskTypes[row]
    }
    
    @IBAction func addTaskData(_ sender: Any) {
        
        //creating alert
        
        let alert = UIAlertController(title: "Add Task", message: "Task Title",preferredStyle: .alert)
        alert.addTextField{
            textField in textField.placeholder = "Task Title"
        }
        alert.addTextField{
            textField in textField.placeholder = "Add Description"
        }
        
        alert.view.addSubview(pickerForType)
        
        // You may need to adjust the frame or constraints of the pickerView here
        // Example (you might need to tweak these values):
        pickerForType.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerForType.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            pickerForType.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 200),
            pickerForType.widthAnchor.constraint(equalTo: alert.view.widthAnchor, multiplier: 0.5),
            pickerForType.heightAnchor.constraint(equalToConstant: 70)
        ])

        // Adjust the alertController's size to accommodate the pickerView
        let heightConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        alert.view.addConstraint(heightConstraint)
        
        
        // Adjust the frame or constraints of the datePicker
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        alert.view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 170), // Adjust this constant for positioning
            datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor, multiplier: 0.35),
            datePicker.heightAnchor.constraint(equalToConstant: 30) // Adjust if needed
        ])
        
        //adjusting what the button will do
        let submitButton = UIAlertAction(title: "Add",style: .default){(action) in
            
            
            //getting text field from alert
            let textfield = alert.textFields![0]
            //selected value of picker
            let selectedRowIndex = self.pickerForType.selectedRow(inComponent: 0)
            let selectedData = self.taskTypes[selectedRowIndex]
            
            //creating TasksData object
            //adding a UUID so that we can delete a specific dataobject (Univeresally Unquie ID)
            let newTask = NSEntityDescription.insertNewObject(forEntityName: "TasksData", into: self.context) as! TasksData
            newTask.uuid = UUID().uuidString
            newTask.title = textfield.text
            newTask.date = self.datePicker.date
            newTask.taskDescription = alert.textFields![1].text
            newTask.taskStatus = 0
            
            
            newTask.taskType = selectedData
            
            
            
            //saving the data
            
            do{
                try self.context.save()
            }catch{
                
            }
            self.scheduleNotification(for: newTask)

           
            //re-fetch the data
            
            self.fetchTasks()
            // Schedule notification
           
        }
        
        //Add Button
        alert.addAction(submitButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))

        self.present(alert,animated: true,completion: nil)
    }
    
    //Diiferencr in days fucntions
    func dayDiff(from:Date,to:Date) -> Int {
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.day], from: from,to: to)
        let numberOfDays = dateComponents.day ?? -10101
        return numberOfDays
    }
    
    func imagePath(daysLeft:Int) -> String {
        var imageName:String = ""
        if daysLeft > 10{
            imageName = "star.fill"
        }else if daysLeft > 5 {
            imageName = "star.leadinghalf.filled"
        }else if daysLeft > 1 {
            imageName = "star"
        }else{
            imageName = "star.slash"
        }
        return imageName
    }
    
    
    func scheduleNotification(for task: TasksData) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget: \(task.title ?? "Your Task")!"
        content.sound = .default

        let taskDate = task.date ?? Date()
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: taskDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: task.uuid ?? UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
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
