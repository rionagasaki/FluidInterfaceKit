//
//  DemoThreadsMessagesViewController.swift
//  FluidUIKit-Demo
//
//  Created by Muukii on 2021/12/12.
//

import Foundation
import MondrianLayout
import FluidUIKit
import UIKit

final class DemoThreadsMessagesViewController: ZStackViewController {

  private let scrollableContainerView = ScrollableContainerView()

  override func viewDidLoad() {

    super.viewDidLoad()

    view.backgroundColor = .white

    view.mondrian.buildSubviews {
      ZStackBlock(alignment: .attach(.all)) {
        scrollableContainerView
      }
    }

    func makeCell(onTap: @escaping (UIView) -> Void) -> UIView {

      let label = UILabel()
      label.text = "Hello"

      let backgroundView = UIView()
      backgroundView.backgroundColor = .init(white: 0, alpha: 0.1)
      if #available(iOS 13.0, *) {
        backgroundView.layer.cornerCurve = .continuous
      } else {
        // Fallback on earlier versions
      }
      backgroundView.layer.cornerRadius = 16

      let body = AnyView { _ in
        HStackBlock {
          label
            .viewBlock
            .padding(24)
        }
        .background(backgroundView)
        .padding(16)
      }

      let cell = InteractiveView(content: body)

      cell.onTap = { [unowned cell] in
        onTap(cell)
      }

      return cell

    }

    let content = MondrianLayout.AnyView.init { view in
      VStackBlock {
        (0..<10).map { _ in
          makeCell(onTap: { [unowned self] cell in
            print(cell)

            addContentViewController(DemoThreadsDetailViewController(), transition: nil)

          })
        }
      }
    }

    scrollableContainerView.setContent(content)

  }

}

final class DemoThreadsDetailViewController: ZStackViewController {

  private let scrollableContainerView = ScrollableContainerView()

  override func viewDidLoad() {

    super.viewDidLoad()

    view.backgroundColor = .white

    let footerView: UIView = {

      let label = UILabel()
      label.text = "Hello"

      return AnyView { _ in
        HStackBlock {
          label
            .viewBlock
            .padding(8)
        }
      }

    }()

    view.mondrian.buildSubviews {
      ZStackBlock {
        scrollableContainerView
          .viewBlock
          .alignSelf(.attach(.all))

        footerView
          .viewBlock
          .huggingPriority(.vertical)
          .relative([.bottom, .horizontal], 0)
      }
    }

    func makeCell() -> UIView {

      let label = UILabel()
      label.text = "Message"

      let backgroundView = UIView()
      backgroundView.backgroundColor = .init(white: 0, alpha: 0.1)
      if #available(iOS 13.0, *) {
        backgroundView.layer.cornerCurve = .continuous
      } else {
        // Fallback on earlier versions
      }
      backgroundView.layer.cornerRadius = 16

      let cell = AnyView { _ in
        HStackBlock {

          StackingSpacer(minLength: 0, expands: true)
          
          HStackBlock {

            label
              .viewBlock
              .padding(24)
          }
          .background(backgroundView)
          .padding(16)
        }
      }

      return cell

    }

    let content = MondrianLayout.AnyView.init { view in
      VStackBlock {
        (0..<10).map { _ in
          makeCell()
        }
      }
    }

    scrollableContainerView.setContent(content)

  }

}
