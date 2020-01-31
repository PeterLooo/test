//
//  CustomPickerView.swift
//  colatour
//
//  Created by M6853 on 2019/5/0-8.
//  Copyright © 2019年 Colatour. All rights reserved.
//
import UIKit

protocol CustomPickerViewProtocol: NSObjectProtocol {
    func onKeyChanged(key: String)
}

class CustomPickerView : UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var shareOptionList : [ShareOption] = []
    private var selectedShareOptionKey: String?
    
    weak var valueChangeDelegate : CustomPickerViewProtocol?
    
    /** 回傳選擇的key */
    var selectedKey: String? {
        return selectedShareOptionKey
    }
    
    /** 如果有key Value，使用它 */
    func setOptionList(optionList: [ShareOption]) {
        self.delegate = self
        self.dataSource = self

        self.shareOptionList = optionList
    }
    
    /** 如果有key Value，使用它，Bool回傳成功與否*/
    func setDefaultKey(key: String?) -> Bool {
        guard let key = key else { return false }
        let defaultOptionIndex = shareOptionList.firstIndex(where: { $0.optionKey == key })
        guard let optionIndex = defaultOptionIndex else { return false }
        
        self.selectRow(optionIndex , inComponent: 0, animated: false)
        self.pickerView(self, didSelectRow: optionIndex, inComponent: 0)
        return true
    }
    
    func clear(){
        self.shareOptionList = []
        self.selectedShareOptionKey = nil
    }
    
    func clearSelectedKey(){
        self.selectedShareOptionKey = nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.shareOptionList.isEmpty { return }
        self.selectedShareOptionKey = shareOptionList[row].optionKey
        self.valueChangeDelegate?.onKeyChanged(key: selectedShareOptionKey!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.shareOptionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.shareOptionList[row].optionValue
    }

    //Note: title置左
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.init(thickness: .regular, size: 23)
        pickerLabel.textColor = UIColor.black
        pickerLabel.textAlignment = NSTextAlignment.left

        pickerLabel.text = self.shareOptionList[row].optionValue ?? ""
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth - 40
    }
}
