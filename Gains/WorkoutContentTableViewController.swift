//
//  WorkoutContentViewController.swift
//
//
// Make School Template App
//
//

import UIKit


class WorkoutContentTableViewController: UITableViewController {
    
    
    @IBOutlet weak var weight: UITextField!{
        didSet{
            if let weightTodisplay = weightValue {
                weight.text = "\(weightTodisplay)"
            }
        }
    }
    
    var weightValue:String?
    var repsValue:String?
    
    @IBOutlet weak var reps: UITextField!{
        didSet{
            if let repsToDisplay = repsValue {
                
                reps.text = "\(repsToDisplay)"
            }
        }
    }
    
    @IBOutlet weak var exerciseName: UILabel!{
        didSet{
            exerciseName!.text  = nameOfExercise
        }
    }
    
    var nameOfExercise: String!
    
    var pageIndex: Int?
    
    private var sessionSets: [SessionSplitTableView] = []
    
    private  var setsFromLastSesion: [Set] = [] {
        didSet {
            updateUI()
        }
    }
    
    private  var sets: [Set] = [] {
        didSet{
            updateUI()
        }
    }
    
    
    
    //Story Board Constants
    private struct StoryBoard {
        static let setCell = "setCell"
    }
    
    
    // This represents a scetion on the tableview and contains
    //the session information needed to display each section
    private  struct SessionSplitTableView: Printable {
        var title: String
        var data:[Set]
        var description: String { return "\(title): \(data)" }
    }
    
    func addNote(note:String,row:Int){
        let setForNote = sets[row]
        setForNote.notes = note
        
        sets[row] = setForNote
        println("added note")
    }
    
    
    
    @IBAction func addSet(sender: UIButton) {
        var set = Set()
        set.weight = (weight.text as NSString).doubleValue
        set.reps = (reps.text as NSString).integerValue
        
        sets.append(set)
        
    }
    
    func removeSet(set:Int) {
        
        sets.removeAtIndex(set)
        
    }
    
    
    
    
}


 extension  WorkoutContentTableViewController {

// MARK: - TableView Delegate & Data

func updateUI() {
    //Resets the data structure that the table view uses
    sessionSets.removeAll(keepCapacity: false)
    if  sets.count != 0 { sessionSets.append(SessionSplitTableView(title: "Current Session", data: sets )) }
    sessionSets.append(SessionSplitTableView(title: "Previous Session", data: setsFromLastSesion ))
    if sessionSets.count == 1{
        if let weight = sessionSets.first?.data.first?.weight {
            weightValue = "\(weight)"
            repsValue = "\((sessionSets.first!.data.first?.reps!)!)"
            println("\(repsValue!)")
        }
    } else{
        
        if let weight = sessionSets.first?.data.last?.weight {
            weightValue = "\(weight)"
            repsValue = "\(sessionSets.first!.data.last!.reps!)"
            
        }
    }
    //reload tableview
    self.tableView.reloadData()
}

override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sessionSets.count
}

override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessionSets[section].data.count
}

override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sessionSets[section].title
}

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BFPaperTableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.setCell, forIndexPath: indexPath) as! BFPaperTableViewCell
    cell.textLabel!.text = "\(sessionSets[indexPath.section].data[indexPath.row].reps) reps"
    
    let weightString = "\(sessionSets[indexPath.section].data[indexPath.row].weight) kg"
    cell.detailTextLabel!.text = weightString
    if  indexPath.section == 0 && sessionSets[indexPath.section].data[indexPath.row].notes != nil {
        cell.detailTextLabel!.text = "Note    \(weightString)"
    }
    
    
    cell.rippleFromTapLocation = true
    cell.backgroundFadeColor = UIColor.paperColorBlue()
    cell.letBackgroundLinger = true
    return cell
}



override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if (indexPath.section == 0  && sessionSets.count == 2 ) || (indexPath.section == 0  && sets.count != 0 ) {
        var alert = UIAlertController(title: "Note or Delete",
            message: nil,
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Add Note",
            style: .Default) { [unowned self] (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as! UITextField
                self.addNote(textField.text,row: indexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        let deleteSetAction = UIAlertAction(title: "Delete This Set",
            style: .Destructive) { [unowned self] (action: UIAlertAction!) -> Void in
                self.removeSet(indexPath.row)
                
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(deleteSetAction)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert,
            animated: true,
            completion: nil)
        
        
        
    } else if  indexPath.section == 1  && sessionSets.count == 2  {
        
        if self.sessionSets[indexPath.section].data[indexPath.row].notes != nil{
            
            
            var alert = UIAlertController(title: nil,
                message: self.sessionSets[indexPath.section].data[indexPath.row].notes,
                preferredStyle: .Alert)
            
            
            let cancelAction = UIAlertAction(title: "Dismiss",
                style: .Default) { (action: UIAlertAction!) -> Void in
            }
            
            alert.addAction(cancelAction)
            
            self.presentViewController(alert,
                animated: true,
                completion: nil)
            tableView.setEditing(false, animated: true)
        }
        
        
    }
}
}
