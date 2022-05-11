//
//  ConfigViewController.swift
//  IOSFinalProject
//
//  Created by Guest User on 5/10/22.
//

import UIKit

class ConfigViewController: UIViewController {
    
    var gameVC : GameViewController?
    
    let sliderMin: Float = 0.0
    let sliderMax: Float = 1.0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        gameVC = self.tabBarController!.viewControllers![0] as? GameViewController
        
        speedSlider.minimumValue = sliderMin
        speedSlider.maximumValue = sliderMax
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sliderValue = sliderGivenDelay(delay: gameVC!.spawnInterval)
        speedSlider.value = sliderValue
        
        scoresLabel.text = scoreInfo
    }
    
    @IBAction func changeGameSpeed(_ sender: UISlider) {
                // Get the slider's value
                let sliderValue = sender.value
                // Get the corresponding delay
                let delay = delayGivenSlider(sliderValue: sliderValue)
                // Update the speed in the GameVC object
                gameVC?.spawnInterval = delay
            
    }
    
    
    @IBOutlet weak var scoresLabel: UILabel!
    
    private var scoreInfo: String {
        let labelText = String(format: "1:%2d \n 2:%2d \n 3:%2d",
                               GameManager.scores[0], GameManager.scores[1], GameManager.scores[2])
        return labelText
    }
    
    
    func sliderGivenDelay(delay: TimeInterval) -> Float {
            // Get values from the game scene
            let nrMin = Float(gameVC!.spawnMin)
            let nrMax = Float(gameVC!.spawnMax)
            // The slope
            let m = (nrMax - nrMin) / (sliderMin - sliderMax )
            // Cast ...
            let nrInt = Float(delay)
            // Function computation
            let sliderValue = (nrInt - nrMax) / m
            // Return the correspoinding slider value
            return sliderValue
    }
    
    func delayGivenSlider(sliderValue: Float) -> TimeInterval {
        // Get values from the game scene
        let nrMin = Float(gameVC!.spawnMin)
        let nrMax = Float(gameVC!.spawnMax)
        // The slope
        let m = (nrMax - nrMin) / (sliderMin - sliderMax )
        // Function computation - the inverse of delayToSlider
        let nrInt = m * sliderValue + nrMax
        // Return the correspoinding delay
        return TimeInterval(nrInt)
    }

    @IBOutlet weak var speedSlider: UISlider!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
