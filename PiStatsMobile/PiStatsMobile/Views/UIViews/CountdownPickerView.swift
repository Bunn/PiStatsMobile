//
//  CountdownPickerView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 20/09/2020.
//

import UIKit

class CountdownPickerView: UIPickerView {
    let hourLabel = UILabel()
    let minutesLabel = UILabel()
    let secondsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(hourLabel)
        addSubview(minutesLabel)
        addSubview(secondsLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hourLabel.text = "hours"
        hourLabel.font = UIFont.boldSystemFont(ofSize: 17)
        hourLabel.sizeToFit()
        
        minutesLabel.text = "min"
        minutesLabel.font = UIFont.boldSystemFont(ofSize: 17)
        minutesLabel.sizeToFit()
        
        secondsLabel.text = "sec"
        secondsLabel.font = UIFont.boldSystemFont(ofSize: 17)
        secondsLabel.sizeToFit()
        
        /*
         I don't think there's any way to add static labels on a UIPicker without doing something really sad like this.
         https://twitter.com/fcbunn/status/1307727709003558912?s=21
         */
        let yOrigin: CGFloat = (self.frame.height / 2.0) - (hourLabel.frame.height / 2.0)
        
        hourLabel.frame = CGRect(x: 67, y: yOrigin, width: hourLabel.frame.width, height: hourLabel.frame.height)
        minutesLabel.frame = CGRect(x: 165, y: yOrigin, width: minutesLabel.frame.width, height: minutesLabel.frame.height)
        secondsLabel.frame = CGRect(x: 277, y: yOrigin, width: secondsLabel.frame.width, height: secondsLabel.frame.height)
    }
}
