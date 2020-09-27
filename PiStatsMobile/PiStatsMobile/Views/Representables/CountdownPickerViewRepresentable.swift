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
        return pickerView
    }

    func updateUIView(_ pickerView: UIPickerView, context: Context) {
        let roundedDuration = Int(duration)
        
        let seconds = roundedDuration % 60
        let minutes = (roundedDuration / 60) % 60
        let hours = (roundedDuration / 3600)

        pickerView.selectRow(hours, inComponent: 0, animated: false)
        pickerView.selectRow(minutes, inComponent: 1, animated: false)
        pickerView.selectRow(seconds, inComponent: 2, animated: false)
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
            let selectedHour = TimeInterval(pickerView.selectedRow(inComponent: 0) * 60 * 60)
            let selectedMinute = TimeInterval(pickerView.selectedRow(inComponent: 1) * 60)
            let selectedSecond = TimeInterval(pickerView.selectedRow(inComponent: 2))
            parent.duration = selectedHour + selectedMinute + selectedSecond
        }
    }
}
