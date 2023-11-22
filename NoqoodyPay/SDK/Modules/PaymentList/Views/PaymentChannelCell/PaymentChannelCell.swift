//
//  PaymentChannelCell.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//

import UIKit

class PaymentChannelCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: PaymentChannelCell.self)

    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var channelLogoImageView: UIImageView!
    @IBOutlet private weak var channelNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(viewModel: NooqodyPaymentScene.Channels.Channel) {
        self.channelNameLabel.text = viewModel.name

        if viewModel.isSelected {
            borderView.borderColor = #colorLiteral(red: 0.2047759295, green: 0.1998669803, blue: 0.4919438362, alpha: 1)
            borderView.borderWidth = 2
        } else {
            borderView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
            borderView.borderWidth = 4
        }

        guard let imageURL = URL(string: viewModel.imageURL) else {
            return
        }
        self.channelLogoImageView.downloaded(from: imageURL)
    }
}
