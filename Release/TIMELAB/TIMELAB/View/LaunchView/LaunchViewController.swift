//
//  LaunchViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/03/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class LaunchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
//    var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    
    // MARK: - UI Parts
    var titleLabelUIImageView: ChooseRegisterOrLogInUIImageView!
    var iconUIImageView: ChooseRegisterOrLogInUIImageView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        titleLabelUIImageView = ChooseRegisterOrLogInUIImageView(name: "TimeLabTitleLabel")
        iconUIImageView = ChooseRegisterOrLogInUIImageView(name: "TimeLabIcon")
        
        let iconAndTitleLabelVertical = UIStackView(arrangedSubviews: [titleLabelUIImageView, iconUIImageView])
        iconAndTitleLabelVertical.axis = .vertical
        iconAndTitleLabelVertical.spacing = -30
        
        // MARK: - addSubview/layer
        titleLabelUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(217)
            make.height.equalTo(52)
        }
        iconUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(195)
            make.height.equalTo(195)
        }
        
        view.addSubview(iconAndTitleLabelVertical)
        iconAndTitleLabelVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
        }
    }
    
    private func setupBinding() { }
}



