//
//  TimerViewController.swift
//  GetItDone
//
//  Created by Kashish Kashish on 2023-11-30.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startTimerButton: UIButton!
    
   // @IBOutlet weak var minTextField: UITextField!
    
    //@IBOutlet weak var secTextField: UITextField!
    
    let pickerView = UIPickerView()
    
    private var minutes:Int = 20
    private var seconds:Int = 0
    private var hour:Int = 0
    private var timerInSeconds:Int = 0
    private var secondsPassed:Int = 0
    var timer: Timer?
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.frame = CGRect(x: 65, y: 250, width: 250, height: 150)
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(pickerView)
        
        
        
        // Do any additional setup after loading the view.
    }
    //when we exist our specific view and come back to it
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer=nil
    }
    
    //this function will be called again and again to update the timer
    func TimerUpdate(){
        let labelTimer = timerInSeconds - secondsPassed
        let labelMin = labelTimer/60
        let labelSec = labelTimer % 60
        
        print("labelTimer: \(labelTimer)| Min: \(labelMin) : Sec : \(labelSec)")
       
        timerLabel.text = String(format: "%02d:%02d", labelMin,labelSec)
    }
    
    @objc func timerAction() {
        secondsPassed += 1
        TimerUpdate()
        
        if secondsPassed >= timerInSeconds{
            timer?.invalidate()
            timer = nil
            timerLabel.text = "00:00"
        }
    }

    @IBAction func startTimerAction(_ sender: Any) {
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
        startTimer()
    }
    
    func startTimer(){
        
        seconds = pickerView.selectedRow(inComponent: 1)
        minutes = pickerView.selectedRow(inComponent: 0)
        
        
       
        //if seconds == 0 && minutes == 0 {
            timerInSeconds = minutes * 60 + seconds
            secondsPassed = 0
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,selector: #selector(self.timerAction),userInfo: nil, repeats: true)
            }
            
        /*}else{
            
            let alert = UIAlertController(title: "Invalid Is Zero-Zero", message: "Select a time please", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",style: .default))
            self.present(alert, animated: true)
            
        }*/
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // for MM:SS
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component{
     
        case 0:
            return 60 //minuts
        case 1:
            return 60 //seconds
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
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
