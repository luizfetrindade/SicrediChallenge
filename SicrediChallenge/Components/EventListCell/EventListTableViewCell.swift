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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupEventImage() {
        eventImage.layer.cornerRadius = eventImage.frame.size.width / 2
        eventImage.clipsToBounds = true
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
        dateFormatter.dateFormat = "dd/MM/yy"
        let datefinal  = dateFormatter.string(from: dateVar)
        self.eventDate.text = datefinal

    }
    
    func setImage(_ url: URL){
        let placeholderImage = UIImage(named: "defaultImg")
        
        self.eventImage.kf.setImage(with: url,
                                    placeholder: placeholderImage,
                                    options: [.transition(.fade(1))],
                                    progressBlock: { receivedSize, totalSize in },
                                    completionHandler: { result in})

    }
}
