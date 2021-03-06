//
//  MainListTableViewCell.swift
//  InteractiveUISample
//
//  Created by 酒井文也 on 2017/11/14.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainListTableViewCell: UITableViewCell {

    //UI部品の配置
    @IBOutlet weak var listImageWrappedView: UIView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var listImageCategoryLabel: UILabel!

    @IBOutlet weak var creditIconImageView: UIImageView!
    @IBOutlet weak var creditNameLabel: UILabel!

    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var listDescriptionLabel: UILabel!

    @IBOutlet weak var toArticleButtonWrappedView: UIView!
    @IBOutlet weak var toArticleButton: UIButton!

    //UIViewに内包したUIImageViewの上下の制約
    @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!

    //視差効果のズレを生むための定数（大きいほど視差効果が大きい）
    private let imageParallaxFactor: CGFloat = 75

    //FontAwesome_Swiftで表示するイメージのサイズ
    private let creditIconImageSize: CGSize = CGSize(width: 30, height: 30)

    //視差効果の計算用の変数
    private var imageBackTopInitial: CGFloat!
    private var imageBackBottomInitial: CGFloat!

    //ViewControllerへ処理内容を引き渡すためのクロージャー
    var showArticleAction: (() -> ())?

    //MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMainListTableViewCell()
    }

    //MARK: - Function

    func setCell(_ mainList: MainList) {
        
        //タイトルの行の高さを調節する
        let titleParagraphStyle = NSMutableParagraphStyle.init()
        titleParagraphStyle.minimumLineHeight = 18
        let titleAttributedText = NSMutableAttributedString.init(string: mainList.title)
        titleAttributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: titleParagraphStyle, range: NSMakeRange(0, titleAttributedText.length))
        listTitleLabel.attributedText = titleAttributedText
        
        //メインテキストの行の高さを調節する
        let mainParagraphStyle = NSMutableParagraphStyle.init()
        mainParagraphStyle.minimumLineHeight = 20
        let mainAttributedText = NSMutableAttributedString.init(string: mainList.mainText)
        mainAttributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: mainParagraphStyle, range: NSMakeRange(0, mainAttributedText.length))
        listDescriptionLabel.attributedText = mainAttributedText
        
        listImageView.sd_setImage(with: URL(string: mainList.thumbnailUrl))
        listImageCategoryLabel.text = mainList.category
        creditNameLabel.text = mainList.author
    }

    //画像にかけられているAutoLayoutの制約を再計算して制約をかけ直す
    func setBackgroundOffset(_ offset: CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        topImageViewConstraint.constant = imageBackTopInitial - pixelOffset
        bottomImageViewConstraint.constant = imageBackBottomInitial + pixelOffset
    }

    //MARK: - Private Function

    //入力ボタンのTouchDownのタイミングで実行される処理
    @objc private func onTouchDownArticleButton(sender: UIButton) {
        UIView.animate(withDuration: 0.16, animations: {
            self.toArticleButtonWrappedView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }

    //入力ボタンのTouchUpInsideのタイミングで実行される処理
    @objc private func onTouchUpInsideArticleButton(sender: UIButton) {
        UIView.animate(withDuration: 0.16, animations: {
            self.toArticleButtonWrappedView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { finished in

            //ViewController側でクロージャー内に設定した処理を実行する
            self.showArticleAction?()
        })
    }

    //入力ボタンのTouchUpOutsideのタイミングで実行される処理
    @objc private func onTouchUpOutsideArticleButton(sender: UIButton) {
        UIView.animate(withDuration: 0.16, animations: {
            self.toArticleButtonWrappedView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    //このクラスの初期設定を行う
    private func setupMainListTableViewCell() {

        //セルの装飾設定をする
        self.accessoryType = .none
        self.selectionStyle = .none

        //意図的にずらした値を視差効果の計算用の変数にそれぞれセットする
        clipsToBounds = true
        bottomImageViewConstraint.constant -= 2 * imageParallaxFactor
        imageBackTopInitial = topImageViewConstraint.constant
        imageBackBottomInitial = bottomImageViewConstraint.constant

        //カテゴリー表示用のラベルに角丸と色をつける
        listImageCategoryLabel.textColor = UIColor.white
        listImageCategoryLabel.backgroundColor = ColorDefinition.pointColor.getColor()
        listImageCategoryLabel.layer.cornerRadius = 2.5
        listImageCategoryLabel.layer.masksToBounds = true

        //画像のアイコンをつける
        creditIconImageView.image = UIImage.fontAwesomeIcon(name: .photo, textColor: ColorDefinition.navigationColor.getColor(), size: creditIconImageSize)

        //ボタンの丸みをつける
        toArticleButtonWrappedView.layer.cornerRadius = 5.0
        toArticleButtonWrappedView.layer.masksToBounds = true

        //画像の外枠UIViewに枠線をつける
        listImageWrappedView.layer.borderWidth = 1
        listImageWrappedView.layer.borderColor = UIColor.init(code: "dddddd").cgColor

        //ボタンアクションに関する設定
        //TouchDown・TouchUpInside・TouchUpOutsideの時のイベントを設定する（完了時の具体的な処理はTouchUpInside側で設定すること）
        toArticleButton.addTarget(self, action: #selector(self.onTouchDownArticleButton(sender:)), for: .touchDown)
        toArticleButton.addTarget(self, action: #selector(self.onTouchUpInsideArticleButton(sender:)), for: .touchUpInside)
        toArticleButton.addTarget(self, action: #selector(self.onTouchUpOutsideArticleButton(sender:)), for: .touchUpOutside)
    }
}
