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
        
        let nib = UINib(nibName: EventListTableViewCell.name, bundle: nil)
        eventTableView.register(nib, forCellReuseIdentifier: EventListTableViewCell.name)
        
        do{
            try viewModel.fetchEvents().observeOn(MainScheduler.instance).bind(to: eventTableView.rx.items(cellIdentifier: EventListTableViewCell.name)) { index, viewModel, cell in
                let viewCell = cell as! EventListTableViewCell
                viewCell.setEventImage(viewModel.image!)
                viewCell.setTitle(viewModel.title)
                viewCell.setDate(viewModel.date!)
                viewCell.setDescription(viewModel.description)
                
                if viewModel.guest.guestCount > 0 {
                    for index in 1...3 {
                        let urlString = viewModel.guest.getPicAt(index)
                        viewCell.setGuestImage(urlString!, guest: index)
                    }
                }
                viewCell.setGuestCounter(viewModel.guest.guestCount)
                
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
    }
}
