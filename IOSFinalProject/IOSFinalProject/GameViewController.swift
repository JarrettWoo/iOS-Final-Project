//
//  ViewController.swift
//  IOSFinalProject
//
//  Created by Guest User on 4/20/22.
//

import UIKit

class GameViewController: UIViewController {
    
    
    // MARK: - ==== Config Properties ====
    //================================================
    
    
    //Timers
    private var spawnRate: TimeInterval = 1.5
    private var spawnTimer: Timer?
    
    private var gameDuration: TimeInterval = 15.0
    private var gameTimer: Timer?
    
    private var dropRate: TimeInterval = 0.0001
    private var dropTimer: Timer?
    
    //Game Items
    private var randomAlpha = false
    private let itemSizeWidth:CGFloat = 50.0
    private let itemSizeHeight:CGFloat = 75.0
    private var items = [UIButton]()
    
    
    // MARK: - ==== View Controller Methods ====
    //================================================

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating a tap gesture recognizer programatically and giving it an action to do
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        
        tapGestureRecognizer.numberOfTouchesRequired = 2

        // Add Tap Gesture Recognizer
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    //Reference to our label that says welcome or paused etc.
    @IBOutlet weak var statusLabel: UILabel!
    // Reference to tower that user will slide back and forth
    @IBOutlet weak var tower: UIImageView!
    
    //action that occurs when we do a two finger tap on Game Scene
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        print("registered touch")
        
        statusLabel.isHidden = true
        
        startGameRunning()
        
    }

    // MARK: - ==== Internal Properties ====
    //================================================
    
    
}


// MARK: - ==== Item Functions ====
//================================================
extension GameViewController {
    private func createItem() {
        let size = CGSize(width: itemSizeWidth, height: itemSizeHeight)
        let randomLocation = Utility.getRandomLocation(size: size, screenSize: view.bounds.size)
        let randomFrame = CGRect(origin: randomLocation, size: size)
        
        let item = UIButton(frame: randomFrame)
        
        let backgroundCol = Utility.getRandomColor(randomAlpha: randomAlpha)
        
        item.backgroundColor = backgroundCol
        
        items.append(item)
        
        self.view.addSubview(item)
        
        print("item has been created")
        
    
    }

    //================================================
    private func moveItems(){
        for item in items {
            item.frame.origin.y += 0.1
            
            if(item.frame.origin.y > tower.frame.origin.y && item.frame.origin.y < tower.frame.origin.y + 40 && tower.frame.origin.x > item.frame.origin.x - 25 && tower.frame.origin.x < item.frame.origin.x + 25){
                growTower();
            }
            
        }
    }
    
    private func growTower(){
        
        var newFrame = tower.frame
        newFrame.size.height = newFrame.size.height + itemSizeHeight
        newFrame.origin.y = newFrame.origin.y - itemSizeHeight
        tower.frame = newFrame
        
    }
    
    
    

    //================================================
    // Action that causes tower to slide back and forth with user's finger
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y)
        
        gesture.setTranslation(.zero, in: view)
    }

    
}

// MARK: - ==== Timer Functions ====
//================================================
extension GameViewController{
    
    private func startGameRunning(){
        
        var newFrame = tower.frame
        newFrame.size.height = 123
        newFrame.origin.y = 673
        tower.frame = newFrame
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
        repeats: false)
        {
            _ in self.stopGameRunning()
        }
            
        // Timer to produce the rectangles
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnRate,
        repeats: true)
        { _ in self.createItem()}
        
        // Timer to produce the rectangles
        dropTimer = Timer.scheduledTimer(withTimeInterval: dropRate,
        repeats: true)
        { _ in self.moveItems() }
        
    }
    
    private func stopGameRunning(){
        if let timer = spawnTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.spawnTimer = nil
        
        if let timerDrop = dropTimer { timerDrop.invalidate() }
        self.dropTimer = nil
    
    }
    
}
