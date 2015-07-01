

//  Make School Template App
//  ViewController.swift
//  UIPageViewController


import UIKit


class WorkoutPageViewControllerDelegate: UIViewController {
    
    private var pageTitles = ["Crunches","Air Squats","Deadlifts","Mountain Climbers"]
    
    private  var pageViewController : UIPageViewController!
    
    //Story Board constants
    struct StoryBoard {
        static let WebSegueIdentifier = "WebSegueIdentifier"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset()
        //Load title for the first page
        updateNavBarTitle()
    }

    @IBAction func launchActionSheet(sender: UIBarButtonItem) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        
        let saveAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Clicked")
            
        })
        
        let demoAction = UIAlertAction(title: "See Exercise Demo", style: .Default) {
            alert -> Void in self.performSegueWithIdentifier(StoryBoard.WebSegueIdentifier, sender: sender)}
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(demoAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    
    @IBAction func endSession(sender: UIBarButtonItem) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Delete Session", style: .Destructive){ alert in self.deleteSession()}
        
        
        
        let saveAction = UIAlertAction(title: "Save Session", style: .Default){ alert in self.popBackToRoot() }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        // 4
        optionMenu.addAction(saveAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    func deleteSession(){
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this session?", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in self.popBackToRoot()}
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Delete Session", style: .Destructive) { action -> Void in self.popBackToRoot()
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
 
    func popBackToRoot(){
        self.navigationController?.popToRootViewControllerAnimated(true)
        //OR
        //self.navigationController?.popViewControllerAnimated(true)
    }
    

    // MARK: - Page View Controller Methods
    
    func reset() {
        
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.delegate = self
          pageViewController.dataSource = self
        
        //Start at first left most ViewController
        let pageContentViewController = self.viewControllerAtIndex(0)
        
        pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        
        pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
    
    
    func updateNavBarTitle(){
        let page = self.pageViewController.viewControllers.last as? WorkoutContentTableViewController
        println("\(page!.pageIndex!)")
        self.navigationItem.title = "\((page!.pageIndex! + 1)) of \(pageTitles.count)"
    }
    
    
    //Creates a view controller to be displayed on the next page.
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        
        let workoutContentTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WorkoutContentTableViewController") as! WorkoutContentTableViewController
        
        
        workoutContentTableViewController.nameOfExercise = pageTitles[index] as String
        workoutContentTableViewController.pageIndex = index
        
        return workoutContentTableViewController
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            if identifier == StoryBoard.WebSegueIdentifier {
                
                if let wvc =  segue.destinationViewController.contentViewController as? WebViewController{
                    let page = self.pageViewController.viewControllers.last as? WorkoutContentTableViewController
                    let aString = pageTitles[page!.pageIndex!]
                    
                    let replaced = String(map(aString.generate()) {
                        $0 == " " ? "+" : $0
                        })
                    wvc.url = NSURL(string: "https://www.google.com/search?&q=\(replaced)")
                    
                }
            }
        }
    }
    
}


extension WorkoutPageViewControllerDelegate: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    ///Used to update NavBar title
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        println("Switched Exercise: \(completed)")
        
        if (completed){
            updateNavBarTitle()
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WorkoutContentTableViewController).pageIndex!
        index++
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WorkoutContentTableViewController).pageIndex!
        
        if(index <= 0){
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

