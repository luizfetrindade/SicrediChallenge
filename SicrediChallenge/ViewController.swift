//
//  ViewController.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import UIKit
import  RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposebag =  DisposeBag()
    private var viewModel: EventListViewModel!
    @IBOutlet weak var eventTitle: UILabel!
    
    static func instantiate(viewModel: EventListViewModel) -> ViewController {
        let storyboard  = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! ViewController
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            try viewModel.fetchEvents().subscribe(
                onNext: { result in
                    print(result)
                },
                onError: { error in
                    print(error.localizedDescription)
                },
                onCompleted: {
                    print("Completed event.")
                }).disposed(by: disposebag)
        }
        catch {
        }
        
        
        do{
            try viewModel.fetchEventDetails("1").subscribe(
                onNext: { result in
                    print(result)
                },
                onError: { error in
                    print(error.localizedDescription)
                },
                onCompleted: {
                    print("Completed event.")
                }).disposed(by: disposebag)
        }
        catch {
        }
    }
}
