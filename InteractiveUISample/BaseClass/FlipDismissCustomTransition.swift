//
//  FlipDismissCustomTransition.swift
//  InteractiveUISample
//
//  Created by 酒井文也 on 2017/11/26.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class FlipDismissCustomTransition: NSObject {
    
    //トランジション（実行）の秒数
    fileprivate let duration: TimeInterval = 0.72
    
    //ディレイ（遅延）の秒数
    fileprivate let delay: TimeInterval = 0.00
}

extension FlipDismissCustomTransition: UIViewControllerAnimatedTransitioning {

    //アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    //アニメーションの実装を定義する
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        //コンテキストを元にViewControllerのインスタンスを取得する（存在しない場合は処理を終了）
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        //アニメーションの実態となるコンテナビューを作成する
        let containerView = transitionContext.containerView
        
        //遷移後のframe（大きさと位置）を定義する
        let finalFrame = CGRect(x: 0, y: 0, width: CGFloat(DeviceSize.screenWidth()), height: CGFloat(DeviceSize.screenHeight()))

        //UIViewのスナップショットを取得する
        guard let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: true) else {
            return
        }

        //スナップショットの設定
        snapshotView.layer.masksToBounds = true

        //コンテナビューの中に遷移先のViewControllerを配置し、更にその上にスナップショットのViewを配置する
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotView)
        
        //遷移元のViewControllerは非表示の状態にしておく
        fromViewController.view.isHidden = true
        
        //CoreAnimationを用いて回転して切り替える処理を登録しておく ※FlipPresentCustomTransition.swiftとほぼ同じ

        //コンテナビューに適用するパースペクティブを設定する
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = -0.002
        containerView.layer.sublayerTransform = perspectiveTransform

        //X軸に対して-90°(-π/2ラジアン)回転させる
        toViewController.view.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi / 2), 0.0, 1.0, 0.0)

        //アニメーションを実行する秒数設定する
        let targetDuration = transitionDuration(using: transitionContext)

        //キーフレームアニメーションを設定する
        UIView.animateKeyframes(withDuration: targetDuration, delay: delay, options: .calculationModeCubic, animations: {

            //キーフレーム(1)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                snapshotView.frame = finalFrame
            })

            //キーフレーム(2)
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                snapshotView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
            })

            //キーフレーム(3)
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                toViewController.view.layer.transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0)
            })

        }, completion: { _ in

            //アニメーションが完了した際の処理を実行する
            fromViewController.view.isHidden = false
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
