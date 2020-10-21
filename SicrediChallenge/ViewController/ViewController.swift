//
//  ViewController.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import UIKit
import  RxSwift
import RxCocoa

class ViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let disposebag =  DisposeBag()
    var viewModel: EventListViewModel!
    
    @IBOutlet weak var eventTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try viewModel.fetchEvents().observeOn(MainScheduler.instance).bind(to: eventTableView.rx.items(cellIdentifier: "cell")) { index, viewModel, cell in
                cell.textLabel?.text = viewModel.title
            }.disposed(by: disposebag)
            
            eventTableView.rx
                .modelSelected(EventViewModel.self)
                .subscribe(onNext: { [self] value in
                    coordinator?.goToEventDetails(for: value)
                }).disposed(by: disposebag)
        }
        catch let error {
            print("Error: ", error)
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
