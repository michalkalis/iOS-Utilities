// Convenience pieces of code to ease everyday manipulation with view-related objects
// Copied from https://gist.github.com/gonzalezreal/92507b53d2b1e267d49a

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


// Combinators for manipulating CGPoint, CGRect, CGSize
// Copied from https://github.com/moreindirection/SwiftGeometry

// MARK: - CGPoint Combinators

extension CGPoint {
    func mapX(f: (CGFloat -> CGFloat)) -> CGPoint {
        return self.withX(f(self.x))
    }
    
    func mapY(f: (CGFloat -> CGFloat)) -> CGPoint {
        return self.withY(f(self.y))
    }
    
    func withX(x: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: self.y)
    }
    
    func withY(y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: y)
    }
}

// MARK: - CGSize Combinators

extension CGSize {
    func mapWidth(f: (CGFloat -> CGFloat)) -> CGSize {
        return self.withWidth(f(self.width))
    }
    
    func mapHeight(f: (CGFloat -> CGFloat)) -> CGSize {
        return self.withHeight(f(self.height))
    }
    
    func withWidth(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: self.height)
    }
    
    func withHeight(height: CGFloat) -> CGSize {
        return CGSize(width: self.width, height: height)
    }
}

// MARK: - CGRect Combinators

extension CGRect {
    func mapX(f: (CGFloat -> CGFloat)) -> CGRect {
        return self.withX(f(self.origin.x))
    }
    
    func mapY(f: (CGFloat -> CGFloat)) -> CGRect {
        return self.withY(f(self.origin.y))
    }
    
    func mapWidth(f: (CGFloat -> CGFloat)) -> CGRect {
        return self.withWidth(f(self.size.width))
    }
    
    func mapHeight(f: (CGFloat -> CGFloat)) -> CGRect {
        return self.withHeight(f(self.size.height))
    }
    
    func withX(x: CGFloat) -> CGRect {
        return CGRect(origin: self.origin.withX(x), size: self.size)
    }
    
    func withY(y: CGFloat) -> CGRect {
        return CGRect(origin: self.origin.withY(y), size: self.size)
    }
    
    func withWidth(width: CGFloat) -> CGRect {
        return CGRect(origin: self.origin, size: self.size.withWidth(width))
    }
    
    func withHeight(height: CGFloat) -> CGRect {
        return CGRect(origin: self.origin, size: self.size.withHeight(height))
    }
}
