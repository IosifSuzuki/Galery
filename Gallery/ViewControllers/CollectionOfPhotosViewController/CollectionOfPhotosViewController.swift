//
//  CollectionOfPhotosViewController.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

protocol AddNewImageDelegate: class {
    
    func addNewImage(category: Category)
    
}

class CollectionOfPhotosViewController: UIViewController, UINavigationControllerDelegate {
    
    enum Section {
      case photos
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoItem>!
    
    //MARK: - Public Properties
    
    var category: Category!
    weak var delegate: AddNewImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureColletionView()
        configureDataSource()
        setupAppearance()
    }

    // MARK: - Action
    
    @IBAction func addNewImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension CollectionOfPhotosViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        let photoItem = PhotoItem(pathToPhoto: MyFileManager.saveImage(image: image.normalizedImage()))
        category.references.append(photoItem)
        delegate?.addNewImage(category: category)
        picker.dismiss(animated: true) { [unowned self] in
            dataSource.apply(snapshot(), animatingDifferences: true)
        }
    }
    
}


extension CollectionOfPhotosViewController: UICollectionViewDelegate {
    //MARK: - TODO
}

extension CollectionOfPhotosViewController {
    
    private func configureColletionView() {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: generateLayout()
        )
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        self.collectionView = collectionView
        registerCell(withClass: PhotoItemCollectionViewCell.self)
        self.configureDataSource()
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        
        let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)
            )
        )
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let mainPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0))
        )

        mainPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let pairPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5))
        )

        pairPhotoItem.contentInsets = NSDirectionalEdgeInsets(
          top: 2,
          leading: 2,
          bottom: 2,
          trailing: 2
        )
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)),
            subitem: pairPhotoItem,
            count: 2
        )

        
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [mainPhotoItem, trailingGroup]
        )
        
        let tripletItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0))
        )

        tripletItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )

        let tripletGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/9)),
            subitems: [tripletItem, tripletItem, tripletItem]
        )
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(12/9)),
            subitems: [
                fullPhotoItem,
                mainWithPairGroup,
                tripletGroup,
            ]
        )
        nestedGroup.contentInsets = .zero

        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func snapshot() -> NSDiffableDataSourceSnapshot<Section, PhotoItem>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoItem>()
        snapshot.appendSections([Section.photos])
        snapshot.appendItems(loadViewModel())
        return snapshot
    }
    
    func loadViewModel() -> [PhotoItem] {
        return category.references
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, PhotoItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, detailItem: PhotoItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: PhotoItemCollectionViewCell.self),
                    for: indexPath) as? PhotoItemCollectionViewCell else {
                        fatalError("Could not create new cell")
                    }
            cell.setup(viewModel: detailItem)
            return cell
        }
        dataSource.apply(snapshot(), animatingDifferences: false)
    }

    private func registerCell<T: UICollectionViewCell>(withClass type: T.Type) {
        let nibName = String(describing: type)
        
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    private func setupAppearance() {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        title = category.title
        collectionView.backgroundColor = Constants.mainColor
    }
}
