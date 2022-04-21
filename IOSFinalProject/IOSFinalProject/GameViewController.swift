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
    
    
    //action that occurs when we do a two finger tap on Game Scene
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        print("registered touch")
        
        statusLabel.isHidden = true
        
        startGameRunning()
        
    }


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
    
    private func moveItems(){
        for item in items {
            item.frame.origin.y += 0.1
        }
    }
    
}

// MARK: - ==== Timer Functions ====
//================================================
extension GameViewController{
    
    private func startGameRunning(){
        
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
