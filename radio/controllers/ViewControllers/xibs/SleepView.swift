//
//  SleepView.swift
//  radio
//
//  Created by MacBook 13 on 8/21/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit
import HGCircularSlider

class SleepView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet var roundsLabel: UILabel!
    @IBOutlet var maxValueLabel: UILabel!
    
    @IBOutlet var minValueLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var uiViewController:UIViewController? = nil
    
    /*
        Contains the actual minute val
     */
    private var currentMinute:Int? = 0
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commongInit()
        
        /*
            Set the default state with the previus configuration
         */
        let minutes:Int = SleepSettingsManager.shared.getMinutes()
        circularSlider.endPointValue = CGFloat(minutes) //Set the GUI
        currentValueLabel.text = String(format: "%.0f", minutes) + " " + " min." //Set the label
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commongInit()
    }
    
    func commongInit(){
        Bundle.main.loadNibNamed("SleepView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        circularSlider.endPointValue = 1
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 120
        
         circularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)
    }
    
    @IBAction func doneTouch(_ sender: UIButton) {
        
        /*
            Hide it
         */
        self.isHidden = true
        
        /*
            Get the current minutes
         */
        let currentMinutes:Int = currentMinute!
        
        /*
            Save the current sleep mode configuration
         */
        SleepSettingsManager.shared.saveMinutes(minutes: currentMinutes)
    }
    
    func updateTexts() {
        let value = circularSlider.endPointValue
        let ok = (circularSlider.maximumValue  / CGFloat(circularSlider.numberOfRounds))
        let ff = ceil(value / ok)
        
        maxValueLabel.text = String(format: "%.0f", circularSlider.maximumValue)
        minValueLabel.text = String(format: "%.0f", circularSlider.minimumValue)
        
        /*
            Save the current minute
         */
        currentMinute = Int(value)
        
        currentValueLabel.text = String(format: "%.0f", value) + " " + " min."
        roundsLabel.text = "Round N° " +  String(format: "%.0f", ff)
    }
    
    
    /*
        Get the current minute value
     */
    func getCurrentMinute() -> Int{
        return self.currentMinute!
    }
}
