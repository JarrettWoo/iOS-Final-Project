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
    
    let spawnMin: TimeInterval = 0.5
    let spawnMax: TimeInterval = 2.5
    
    var spawnInterval: TimeInterval = 1.5
    private var spawnTimer: Timer?
    
    private var gameDuration: TimeInterval = 3750.0
    private var gameTimer: Timer?
    
    private var dropRate: TimeInterval = 0.0001
    private var dropTimer: Timer?
    
    //Game Items
    private var randomAlpha = false
    private enum gameState {case inGame, paused, noGame}
    private var gameStatus = gameState.noGame
    
    private var gameInProgress = false
    private let itemSizeWidth:CGFloat = 50.0
    private let itemSizeHeight:CGFloat = 75.0
    private var items = [UIButton]()
    private var score: Int = 0 {
    didSet { scoreLabel?.text = scoreInfo } }
    
    private var scoreInfo: String {
        let labelText = String(format: "Score:%2d", score)
        return labelText
    }
    
    
    // MARK: - ==== View Controller Methods ====
    //================================================

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(gameStatus != .inGame){
            return
        }
        pauseGameRunning()
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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    //action that occurs when we do a two finger tap on Game Scene
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        print("registered touch")
        
        statusLabel.isHidden = true
        
        
        switch gameStatus {
        case .inGame:
            pauseGameRunning()
        case .paused:
            unpauseGameRunning()
        case .noGame:
            startGameRunning()
        }
        
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
        
        item.alpha = 1.0;
        
        items.append(item)
        
        self.view.addSubview(item)
        
        print("item has been created")
        
    
    }

    //================================================
    
    func removeRectangle(rectangle: UIButton) {
    // Rectangle fade animation

        rectangle.removeFromSuperview();
        rectangle.frame.origin.x = 1000000
    }
    
    func removeSavedRectangles() {
    // Remove all rectangles from superview
    for item in items {
    item.removeFromSuperview()
    }
    // Clear the rectangles array
    items.removeAll()
    }
    
    
    private func moveItems(){
        for item in items {
            item.frame.origin.y += 0.1
            
            if(item.frame.origin.y > tower.frame.origin.y && item.frame.origin.y < tower.frame.origin.y + 40 && tower.frame.origin.x > item.frame.origin.x - 25 && tower.frame.origin.x < item.frame.origin.x + 25){
                score += 1
                growTower();
                item.alpha = 0.0;
                removeRectangle(rectangle: item)
            }
            else if(item.frame.origin.y >= view.bounds.size.height && item.frame.origin.x < view.bounds.size.width){
                stopGameRunning()
                removeSavedRectangles()
                statusLabel.text = "Game Over"
                statusLabel.textColor = UIColor.red
                statusLabel.isHidden = false
            }
            
        }
    }
    
    private func growTower(){
        
        var newFrame = tower.frame
        if(tower.frame.size.height >= view.bounds.size.height/2){
            return
        }
        newFrame.size.height = newFrame.size.height + itemSizeHeight
        newFrame.origin.y = newFrame.origin.y - itemSizeHeight
        tower.frame = newFrame
    }
    
    
    

    //================================================
    // Action that causes tower to slide back and forth with user's finger
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        if(gameStatus != .inGame){
            return
        }
        
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

        if (gameStatus != .noGame){
            return
        }
        gameStatus = .inGame
        score = 0
        gameDuration = 3750.0
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
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval,
        repeats: true)
        { _ in self.createItem()}
        
        // Timer to produce the rectangles
        dropTimer = Timer.scheduledTimer(withTimeInterval: dropRate,
        repeats: true)
        { _ in self.moveItems() }
        
    }
    
    
    private func pauseGameRunning(){
        
        if(gameStatus != .inGame){
            return
        }
        
        if let timer = gameTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.gameTimer = nil
        
        if let timer = spawnTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.spawnTimer = nil
        
        if let timerDrop = dropTimer { timerDrop.invalidate() }
        self.dropTimer = nil
        gameStatus = .paused
    }
    
    private func unpauseGameRunning(){
        
        if(gameStatus != .paused){
            return
        }
        
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
        repeats: false)
        {
            _ in self.stopGameRunning()
        }
            
        // Timer to produce the rectangles
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval,
        repeats: true)
        { _ in self.createItem()}
        
        // Timer to produce the rectangles
        dropTimer = Timer.scheduledTimer(withTimeInterval: dropRate,
        repeats: true)
        { _ in self.moveItems() }
        
        gameStatus = .inGame
        

    }
    
    
    private func stopGameRunning(){
        
        if let timer = gameTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.gameTimer = nil
        
        if let timer = spawnTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.spawnTimer = nil
        
        if let timerDrop = dropTimer { timerDrop.invalidate() }
        self.dropTimer = nil
        gameStatus = .noGame
        
        
        
        if(GameManager.scores.count > 0){
            
            if(score > GameManager.scores.last! || GameManager.scores.count < 3){
                GameManager.scores.append(score)
                GameManager.scores.sort(by: >)
                if(GameManager.scores.count > 3){
                    GameManager.scores.removeLast()
                }
                print(GameManager.scores)
                
            }
        }
        else{
            GameManager.scores.append(score)
            print(GameManager.scores)
            
        }
    
    }
    
}
