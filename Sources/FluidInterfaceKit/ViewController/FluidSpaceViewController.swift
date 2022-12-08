import UIKit

/**
 - left
 - main
 - right
 
 - TODO:
  - ViewController life-cycle
 */
open class FluidStageViewController: UIViewController {
  
  public enum Stage {
    case left
    case main
    case right
  }

  private final class HostingScrollView: UIScrollView {

    override init(frame: CGRect) {
      super.init(frame: frame)
      
      isPagingEnabled = true
      contentInsetAdjustmentBehavior = .never
      showsVerticalScrollIndicator = false
      showsHorizontalScrollIndicator = false
      delaysContentTouches = false
      bounces = false
      
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  private final class InternalView: UIView {

    private let leftSideViewController: UIViewController
    private let mainViewController: UIViewController
    private let rightSideViewController: UIViewController

    private let scrollView: HostingScrollView
    
    private var currentStage: Stage = .main

    init(
      scrollView: HostingScrollView,
      leftSideViewController: UIViewController,
      mainViewController: UIViewController,
      rightSideViewController: UIViewController
    ) {
      self.scrollView = scrollView
      self.leftSideViewController = leftSideViewController
      self.mainViewController = mainViewController
      self.rightSideViewController = rightSideViewController

      super.init(frame: .null)
            
      addSubview(scrollView)
      
      let viewControllers = [
        leftSideViewController,
        mainViewController,
        rightSideViewController,
      ]
      
      let stackView = UIStackView(arrangedSubviews: viewControllers.map(\.view))
      scrollView.addSubview(stackView)
      stackView.translatesAutoresizingMaskIntoConstraints = false
            
      NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
        stackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
        stackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
        stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        
        scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, multiplier: 1)
      ])
            
      for viewController in viewControllers {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          viewController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1)
        ])
      }
      
      addSubview(scrollView)
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: topAnchor),
        scrollView.rightAnchor.constraint(equalTo: rightAnchor),
        scrollView.leftAnchor.constraint(equalTo: leftAnchor),
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      ])
      
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      
      select(stage: currentStage, animated: false)
      
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
      
    func select(stage: Stage, animated: Bool) {
      currentStage = stage
      scrollView.setContentOffset(.init(x: contentOffsetX(for: stage), y: 0), animated: animated)
    }
    
    private func contentOffsetX(for stage: Stage) -> CGFloat {
      
      let width = bounds.width
      
      switch stage {
      case .left:
        return 0
      case .main:
        return width
      case .right:
        return width * 2
      }
      
    }
    
  }

  private let scrollView: HostingScrollView = .init()

  open override func loadView() {
    let instance = InternalView(
      scrollView: scrollView,
      leftSideViewController: leftSideViewController,
      mainViewController: mainViewController,
      rightSideViewController: rightSideViewController
    )
    self.view = instance
  }

  private let leftSideViewController: UIViewController
  private let mainViewController: UIViewController
  private let rightSideViewController: UIViewController
  
  private var internalView: InternalView {
    view as! InternalView
  }

  public init(
    leftSideViewController: UIViewController,
    mainViewController: UIViewController,
    rightSideViewController: UIViewController
  ) {

    self.leftSideViewController = leftSideViewController
    self.mainViewController = mainViewController
    self.rightSideViewController = rightSideViewController

    super.init(nibName: nil, bundle: nil)

  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewControllers = [
      leftSideViewController,
      mainViewController,
      rightSideViewController,
    ]
    
    for viewController in viewControllers {
      addChild(viewController)
      didMove(toParent: self)
    }
    
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    view.layoutIfNeeded()
  }
  
  public func select(stage: Stage, animated: Bool) {
    internalView.select(stage: stage, animated: animated)
  }
      
}
