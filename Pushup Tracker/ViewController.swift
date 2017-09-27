//
//  ViewController.swift
//  Pushup Tracker
//
//  Created by Joshua Dance on 9/26/17.
//  Copyright © 2017 Joshua Dance. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    var counterValue = 0
    var workoutType = "Pushup"
    var currentDate: Date!

    var workouts: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = getDate()
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        counterValue = 10
        saveWorkout()
        mainTableView.reloadData()
    }
    
    @IBAction func upButtonTapped(_ sender: Any) {
        
    }
    
    func saveWorkout() {
        //get the appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //create a managed context scratch pad
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //
        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: managedContext)!
        
        let workout = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //create the workout in the scratch pad
        workout.setValue(counterValue, forKeyPath: "reps")
        workout.setValue(workoutType, forKeyPath: "type")
        workout.setValue(currentDate, forKey: "date")

        //4
        do {
            try managedContext.save()
            workouts.append(workout)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getDate() -> Date {
        let currentDateTime = Date()
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"
        
        //let workoutRecord = "\(counterValue) pushups at : \(dateFormatter.string(from: currentDateTime))"
        return currentDateTime
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = workouts[indexPath.row]
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let workoutType = workout.value(forKeyPath: "type") as? String
        let workoutReps = workout.value(forKeyPath: "reps") as? String
        let workoutDate = workout.value(forKeyPath: "date") as? String
        
        let cellString = "\(workoutType) : \(workoutReps) : \(workoutDate)"
        //cell.textLabel?.text = workout.value(forKeyPath: "type") as? String
        cell.textLabel?.text = cellString

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        //get the appDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //get a managedContext, like a scratch pad
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //create a fetch request to get the list of workouts, have to match the name on the entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workout")
        
        //use that fetch request and try to get all the workouts.
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }//end viewWillAppear
    
}

