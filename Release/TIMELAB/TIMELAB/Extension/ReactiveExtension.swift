//
//  ReactiveExtension.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/10.
//

import UIKit
import RxSwift

// 登録時に使用するUILabelに型を追加
extension Reactive where Base: UILabel {
    var  validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.testColor
            label.text = result.description
        }
    }
}
