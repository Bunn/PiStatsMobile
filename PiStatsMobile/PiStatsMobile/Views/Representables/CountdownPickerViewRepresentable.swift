//
//  CountdownPickerViewRepresentable.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 20/09/2020.
//

import SwiftUI

struct CountdownPickerViewRepresentable: UIViewRepresentable {
    @Binding var duration: TimeInterval

    func makeUIView(context: Context) -> UIPickerView {
        let pickerView = CountdownPickerView()
        pickerView.dataSource = context.coordinator
        pickerView.delegate = context.coordinator

        //datePicker.addTarget(context.coordinator, action: #selector(Coordinator.updateDuration), for: .valueChanged)
        return pickerView
    }

    func updateUIView(_ pickerView: UIPickerView, context: Context) {
//        datePicker.countDownDuration = duration
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: CountdownPickerViewRepresentable

        init(_ parent: CountdownPickerViewRepresentable) {
            self.parent = parent
        }

        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return 25
            case 1,2:
                return 60

            default:
                return 0
            }
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            switch component {
            case 0, 1:
                return pickerView.frame.size.width / 3.5
            default:
                return pickerView.frame.size.width / 2.5
            }
            
            
    
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return "\(row)"
            case 1:
                return "\(row)"
            case 2:
                return "\(row)"
            default:
                return ""
            }
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.duration += 1

//            switch component {
//            case 0:
//                hour = row
//            case 1:
//                minutes = row
//            case 2:
//                seconds = row
//            default:
//                break;
//            }
        }
    }
}
