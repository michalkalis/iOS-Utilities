// Convenience pieces of code to ease everyday manipulation with view-related objects


// MARK: - Reuse identifiers

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionViewCell: ReusableView {
}

extension UITableViewCell: ReusableView {
}


// MARK: - Nib loading, registration & dequeue

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let bundle = NSBundle(forClass: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        registerNib(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.defaultReuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}