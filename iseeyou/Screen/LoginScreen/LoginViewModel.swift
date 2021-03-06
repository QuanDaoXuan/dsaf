//
//  LoginViewModel.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    var datasource = BehaviorRelay<[Int]>(value: [0, 1, 2, 4, 5])
    var usermame = ""
    var password = ""
    var confirmPassword = ""
    var disposbag = DisposeBag()
    var loginReposytory = AuthRepository()

    func setupLogin(viewController: UIViewController) {
        viewController.LoadingStart()
        if self.usermame == "" || self.password == "" {
            DialogHelper.shared.showPopup(title: "Cảnh Báo", msg: "username và password không được để trống.")
        } else {
            self.loginReposytory.login(username: self.usermame, password: self.password).subscribe(onNext: {
                json in
                SaveDataDefaults().setgetIsLogin(IsLogin: true)
                let userID = json["user"]["idUsers"].stringValue
                SaveDataDefaults().setToken(token: userID)
                let vc = R.storyboard.main.tabbarcontrollerViewController()!
                viewController.navigationController?.pushViewController(vc, animated: true)
                viewController.LoadingStop()
                SaveDataDefaults().setUsername(user: self.usermame)
                SaveDataDefaults().setPassword(password: self.password)
            }, onError: {
                _ in
                DialogHelper.shared.showPopup(title: "", msg: "Có lỗi xảy ra khi đăng nhập, vui lòng kiểm tra lại.")
            }).disposed(by: self.disposbag)
        }
    }

    func setupRegister(viewController: UIViewController) {
//        let vc = R.storyboard.main.registerViewcontroller()!
//        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
