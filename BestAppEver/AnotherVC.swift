//
//  AnotherViewController.swift
//  TableViewApp
//
//  Created by Jastina Suah on 1/8/23.
//

import UIKit

protocol UpdatableView {
    func update()
}

class AnotherViewModel {
    private(set) var model: Model? {
        didSet {
            view?.update()
        }
    }
    
    private(set) var view: UpdatableView?
    
    func setView(view: UpdatableView) {
        self.view = view
    }
        
    struct Model {
        var bannerIcons: [ShortcutsBannerViewCell.IconInfo]
    }
    
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.model = Model(bannerIcons: [
                .init(lable: "PayNow", icon: "dollarsign.circle"),
                .init(lable: "Scan & Pay", icon: "qrcode.viewfinder"),
                .init(lable: "Pay bills", icon: "rectangle.on.rectangle")
            ])
        }
    }
}

class AnotherView: UIViewController, UpdatableView {
    var viewModel: AnotherViewModel
    
    init(viewModel: AnotherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.setView(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var shortcutsView: ShortcutsBanner = {
        let view = ShortcutsBanner()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        view.addSubview(shortcutsView)
        shortcutsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        shortcutsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        shortcutsView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        shortcutsView.heightAnchor.constraint(equalToConstant: 96).isActive = true
        viewModel.fetchData()
    }
    
    func update() {
        if let bannerIcons = viewModel.model?.bannerIcons {
            shortcutsView.setData(bannerIcons: bannerIcons)
        }
    }
}

class ShortcutsBanner: UIView {
    var cellId = "cell"
    
    private var bannerIcons: [ShortcutsBannerViewCell.IconInfo]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 8
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(gearIcon)
        gearIcon.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        gearIcon.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8).isActive = true

    }
    
    func setData(bannerIcons: [ShortcutsBannerViewCell.IconInfo]) {
        self.bannerIcons = bannerIcons
        collectionView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let cellWidth: CGFloat = 98.33
    let cellHeight: CGFloat = 48

    lazy var gearIcon: UIImageView = {
        var config = UIImage.SymbolConfiguration(paletteColors: [.black])
        let image = UIImage(systemName: "gearshape",withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 8, bottom: 0, right: 8)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.register(ShortcutsBannerViewCell.self, forCellWithReuseIdentifier: cellId)
        return view
    }()
}

extension ShortcutsBanner: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = bannerIcons?.count else {
            return 0
        }
        return count
    }

    //Create cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ShortcutsBannerViewCell,
            let bannerIcons = bannerIcons
        else {
            return UICollectionViewCell()
        }
        cell.set(cellData: bannerIcons[indexPath.row])
        
        //On click Action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
    @objc func handleTap(){
        print("tapped")
    }
}



class ShortcutsBannerViewCell: UICollectionViewCell {
    var data: IconInfo?
    
    private lazy var icon: UIImageView = {
        var config = UIImage.SymbolConfiguration(paletteColors: [.black])
        let image = UIImage(systemName: "dollarsign.circle",withConfiguration: config)
        
        let icon = UIImageView(image: image)
        //Is this correct?
        icon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func set(cellData: IconInfo) {
        self.data = cellData
        setupView()
    }
    
    struct IconInfo {
        var lable: String
        var icon: String
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let config = UIImage.SymbolConfiguration(paletteColors: [.black])
        icon.image = UIImage(systemName: data?.icon ?? "", withConfiguration: config)
        
        label.text = data?.lable
        
        contentView.addSubview(icon)
        contentView.addSubview(label)
        
        icon.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
