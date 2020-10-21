//
//  EventDetailsViewController.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class EventDetailsViewController: UIViewController, Storyboarded, FloatLabelDelegate {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var colapseButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var nameFloatLabel: FloatLabel!
    @IBOutlet weak var emailFloatLabel: FloatLabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var checkinHeigth: NSLayoutConstraint!
    @IBOutlet weak var date: UILabel!
    
    private var isKeyboardShowing = false
    
    weak var coordinator: MainCoordinator?
    private var decriptionHeightHelper: NSLayoutConstraint!
    private var gradientLayer: CAGradientLayer!
    let disposebag =  DisposeBag()
    var alerts = AlertHelper()
    
    var eventViewModel: EventViewModel!
    private var eventDetailsViewMode = EventDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTitle.text = eventViewModel?.title
        
    
    
        let milisecond = eventViewModel.date!
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let datefinal  = dateFormatter.string(from: dateVar)
        date.text = datefinal
        
        let placeholderImage = UIImage(named: "defaultImg")
        self.eventImage.kf.setImage(with: eventViewModel.image,
                                    placeholder: placeholderImage,
                                    options: [.transition(.fade(1))],
                                    progressBlock: { receivedSize, totalSize in },
                                    completionHandler: {result in})
        
        self.eventDescription.text = eventViewModel.description
        self.decriptionHeightHelper =  self.descriptionHeight
        self.nameFloatLabel.floatLabelDelegate = self
        self.emailFloatLabel.floatLabelDelegate = self
        self.createGradientLayer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupMap()
    }
    
    @IBAction func colapseDescription(_ sender: Any) {
        let state = !colapseButton.isSelected
        if state {
            self.colapseButton.setImage(UIImage(systemName: "chevron.up"), for: .selected)
            self.descriptionHeight.isActive = false
            colapseButton.isSelected = state
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.contentView.layoutIfNeeded()
            }
        } else {
            self.colapseButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            self.descriptionHeight.isActive = (decriptionHeightHelper != nil)
            colapseButton.isSelected = state
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.contentView.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        let eventTitle = "Come to my event: \(eventViewModel.title)."
        let eventDescription = "Come to my event: \(eventViewModel.title)."
        let textToShare = [eventTitle, eventDescription ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    var alert =  UIAlertController()
    @IBAction func checkin(_ sender: Any) {
        guard let nome = nameFloatLabel.text else { return }
        guard let email = emailFloatLabel.text else { return }
        
        if nome.isEmpty  || email.isEmpty {
            alert = alerts.emptyTextField()
        } else {
            
            let params = [ "eventId": "\(eventViewModel.id)", "name": nome, "email": email ]
            do{
                eventDetailsViewMode.checkin(params).subscribe(
                    onNext: { result in
                        print("status code: ",  result)
                    },
                    onError: { error in
                        print("error : ", error)
                    },
                    onCompleted: {
                    }).disposed(by: disposebag)
                
            }
            
            alert = alerts.checkinAlert()
        }
        self.present(alert, animated: true)
    }
    
    private func setupMap() {
        let coordinate = CLLocationCoordinate2D(latitude: eventViewModel.latitude!, longitude: eventViewModel.longitude!)
        let region = self.map.regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750))
        self.map.setRegion(region, animated: true)
    }
    
    
    private func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.clear]
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            checkinHeigth.constant = keyboardRect.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.contentView.layoutIfNeeded()
            }
        }
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        checkinHeigth.constant = 50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
