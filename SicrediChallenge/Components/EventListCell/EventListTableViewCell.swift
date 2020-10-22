//
//  EventListTableViewCell.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 21/10/20.
//

import UIKit
import Kingfisher

class EventListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var cellBody: UIView!
    @IBOutlet weak var guestone: UIImageView!
    @IBOutlet weak var guestTwo: UIImageView!
    @IBOutlet weak var guestThree: UIImageView!
    @IBOutlet weak var guestCountView: UIView!
    @IBOutlet weak var guestCounter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupEventImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    private func setupEventImage() {
        eventImage.layer.cornerRadius = 8
        eventImage.clipsToBounds = true
        eventImage.layer.masksToBounds = true

        cellBody.setRadiusWithShadow(10, shadow: 6, shadowOp: 0.5)

        self.dateView.layer.cornerRadius = 6
        self.dateView.clipsToBounds = true
        self.dateView.layer.masksToBounds = true
        self.dateView.layer.borderWidth = 1
        self.dateView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        self.setupGuestView(guestThree)
        self.setupGuestView(guestTwo)
        self.setupGuestView(guestone)
        self.setupGuestView(guestCountView)
    }
    
    private func setupGuestView(_ view: UIView) {
        view.layer.cornerRadius = self.guestone.frame.size.width/2
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorSystem.backgroundColor.cgColor
    }
    
    func setTitle(_ title: String){
        self.title.text = title
    }
    
    func setDescription(_ description: String){
        self.eventDescription.text  =  description
    }
    
    func setDate(_ date: Int){
        let milisecond = date
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd\nMMM"
        let datefinal  = dateFormatter.string(from: dateVar)
        self.eventDate.text = datefinal

    }
    
    func setGuestImage(_ urlString: String, guest: Int){
        
        if let url = URL(string: urlString) {
            
            var guestImage = UIImageView()
            
            switch guest {
            case 1:
                guestImage = guestone
            case 2:
                guestImage = guestTwo
            case 3:
                guestImage = guestThree
            default:
                break
            }
            
            let placeholderImage = UIImage(named: "guestDefault")
            self.setImage(for: guestImage, with: url, placeholder: placeholderImage!)
        }
    }
    
    func setGuestCounter(_ count: Int) {
        self.guestCounter.text = "\(count)+"
    }
    
    func setEventImage(_ url: URL){
        let placeholderImage = UIImage(named: "defaultImg")
        self.setImage(for: eventImage, with: url, placeholder: placeholderImage!)
    }
    
    private func setImage(for imageView: UIImageView, with url: URL, placeholder: UIImage) {
        
        imageView.kf.setImage(with: url,
                              placeholder: placeholder,
                              options: [.transition(.fade(1))],
                              progressBlock: {receivedSize, totalSize in},
                              completionHandler: {result in})
    }
}

