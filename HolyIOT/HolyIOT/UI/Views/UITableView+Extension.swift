//
//  UITableView+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.02.18.
//

import UIKit

extension UITableView {
    /**
     Registers a UITableViewCell for use in a UITableView.
     
     - parameter type: The type of cell to register.
     - parameter reuseIdentifier: The reuse identifier for the cell (optional).
     
     By default, the class name of the cell is used as the reuse identifier.
     
     Example:
     ```
     class CustomCell: UITableViewCell {}
     
     let tableView = UITableView()
     
     // registers the CustomCell class with a reuse identifier of "CustomCell"
     tableView.registerCell(CustomCell)
     ```
     */
    public func registerCell<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) where T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }
    /**
     Registers a UITableViewHeaderFooterView for use in a UITableView.
     
     - parameter type: The type of headerFooterView to register.
     - parameter reuseIdentifier: The reuse identifier for the headerFooterView (optional).
     
     By default, the class name of the headerFooterView is used as the reuse identifier.
     
     Example:
     ```
     class CustomHeaderFooterView: UITableViewHeaderFooterView {}
     
     let tableView = UITableView()
     
     // registers the CustomHeaderFooterView class with a reuse identifier of "CustomHeaderFooterView"
     tableView.registerHeaderFooterView(CustomHeaderFooterView)
     ```
     */
    public func registerHeaderFooterView<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) where T: UITableViewHeaderFooterView {
        register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    /**
     Registers a UITableViewHeaderFooterView for use in a UITableView.
     
     - parameter type: The type of headerFooterView to register.
     - parameter reuseIdentifier: The reuse identifier for the headerFooterView (optional).
     
     By default, the class name of the headerFooterView is used as the reuse identifier and nibName.
     
     Example:
     ```
     class CustomHeaderFooterView: UITableViewHeaderFooterView {}
     
     let tableView = UITableView()
     
     // registers the CustomHeaderFooterView class with a reuse identifier and nibName of "CustomHeaderFooterView"
     tableView.registerHeaderFooterViewFromNib(CustomHeaderFooterView)
     ```
     */
    public func registerHeaderFooterViewFromNib<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) where T: UITableViewHeaderFooterView {
        register(UINib(nibName: reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    /**
     Dequeues a UITableViewCell for use in a UITableView.
     
     - parameter type: The type of the cell.
     - parameter reuseIdentifier: The reuse identifier for the cell (optional).
     
     - returns: A force-casted UITableViewCell of the specified type.
     
     By default, the class name of the cell is used as the reuse identifier.
     
     Example:
     ```
     class CustomCell: UITableViewCell {}
     
     let tableView = UITableView()
     
     // dequeues a CustomCell class
     let cell = tableView.dequeueReusableCell(CustomCell)
     ```
     */
    public func dequeueCell<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
        }
        return cell
    }
    /**
     Dequeues a UITableViewHeaderFooterView for use in a UITableView.
     
     - parameter type: The type of the headerFooterView.
     - parameter reuseIdentifier: The reuse identifier for the headerFooterView (optional).
     
     - returns: A force-casted UITableViewHeaderFooterView of the specified type.
     
     By default, the class name of the view is used as the reuse identifier.
     
     Example:
     ```
     class CustomHeaderFooterView: UITableViewHeaderFooterView {}
     
     let tableView = UITableView()
     
     // dequeues a CustomHeaderFooterView class
     let view = tableView.dequeueReusableHeaderFooterView(CustomHeaderFooterView)
     ```
     */
    public func dequeueHeaderFooterView<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T where T: UITableViewHeaderFooterView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T else {
            fatalError("Unknown headerFooterView type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
        }
        return cell
    }
    
    /**
     Dequeues a UITableViewCell for use in a UITableView.
     
     - parameter type: The type of the cell.
     - parameter indexPath: The index path at which to dequeue a new cell.
     - parameter reuseIdentifier: The reuse identifier for the cell (optional).
     
     - returns: A force-casted UITableViewCell of the specified type.
     
     By default, the class name of the cell is used as the reuse identifier.
     
     Example:
     ```
     class CustomCell: UITableViewCell {}
     
     let tableView = UITableView()
     
     // dequeues a CustomCell class
     let cell = tableView.dequeueReusableCell(CustomCell.self, forIndexPath: indexPath)
     ```
     */
    public func dequeueCell<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self), for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
        }
        return cell
    }
    
    
    
    
    /**
     Returns the table cell at the specified index path.
     
     - parameter type: The type of the cell.
     - parameter indexPath: The index path at which to dequeue a new cell.
     
     - returns: A force-casted UITableViewCell of the specified type.
     
     Example:
     ```
     class CustomCell: UITableViewCell {}
     
     let tableView = UITableView()
     
     // dequeues a CustomCell class
     let cell = tableView.cell(CustomCell.self, forIndexPath: indexPath)
     ```
     */
    func cell<T>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T where T: UITableViewCell{
        assertIsValid(indexPath: indexPath)
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("Cannot convert cell for row at \(indexPath) to type \(String(describing: T.self)) or the cell is not visible")
        }
        return cell
    }
    
    func isLoadedCellFor(indexPath: IndexPath) -> Bool {
        assertIsValid(indexPath: indexPath)
        return cellForRow(at: indexPath) != nil
    }
    
    /**
     Inserts rows into self.
     
     - parameter indices: The rows indices to insert into self.
     - parameter section: The section in which to insert the rows (optional, defaults to 0).
     - parameter animation: The animation to use for the row insertion (optional, defaults to `.Automatic`).
     */
    public func insert(_ indices: [Int], section: Int = 0, animation: UITableViewRowAnimation = .automatic) {
        guard !indices.isEmpty else { return }
        
        let indexPaths = indices.map { IndexPath(row: $0, section: section) }
        
        beginUpdates()
        insertRows(at: indexPaths, with: animation)
        endUpdates()
    }
    
    /**
     Deletes rows from self.
     
     - parameter indices: The rows indices to delete from self.
     - parameter section: The section in which to delete the rows (optional, defaults to 0).
     - parameter animation: The animation to use for the row deletion (optional, defaults to `.Automatic`).
     */
    public func delete(_ indices: [Int], section: Int = 0, animation: UITableViewRowAnimation = .automatic) {
        guard !indices.isEmpty else { return }
        
        let indexPaths = indices.map { IndexPath(row: $0, section: section) }
        
        beginUpdates()
        deleteRows(at: indexPaths, with: animation)
        endUpdates()
    }
    
    /**
     Reloads rows in self.
     
     - parameter indices: The rows indices to reload in self.
     - parameter section: The section in which to reload the rows (optional, defaults to 0).
     - parameter animation: The animation to use for reloading the rows (optional, defaults to `.Automatic`).
     */
    public func reload(_ indices: [Int], section: Int = 0, animation: UITableViewRowAnimation = .automatic) {
        guard !indices.isEmpty else { return }
        
        let indexPaths = indices.map { IndexPath(row: $0, section: section) }
        
        beginUpdates()
        reloadRows(at: indexPaths, with: animation)
        endUpdates()
    }
}

// MARK: - IndexPathTraversing
extension UITableView {
    
    
    /// The minimum ("starting") `IndexPath` for traversing a `UITableView` "sequentially".
    public var minimumIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    /// The maximum ("ending") `IndexPath` for traversing a `UITableView` "sequentially".
    public var maximumIndexPath: IndexPath {
        let lastSection = max(0, numberOfSections - 1)
        let lastRow = max(0, numberOfRows(inSection: lastSection) - 1)
        return IndexPath(row: lastRow, section: lastSection)
    }
    
    
    /**
     When "sequentially" traversing a `UITableView`, what's the next `IndexPath` after the given `IndexPath`.
     
     - parameter indexPath: The current indexPath; the path we want to find what comes after.
     
     - returns: The next indexPath, or nil if we're at the maximumIndexPath
     - SeeAlso: `var maximumIndexpath`
     */
    public func indexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath == maximumIndexPath {
            return nil
        }
        
        assertIsValid(indexPath: indexPath)
        
        let lastRow = numberOfRows(inSection: indexPath.section) - 1
        if indexPath.item == lastRow  {
            return IndexPath(row: 0, section: indexPath.section + 1)
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    
    /**
     When "sequentially" traversing a `UITableView`, what's the previous `IndexPath` before the given `IndexPath`.
     
     - parameter indexPath: The current indexPath; the path we want to find what comes before.
     
     - returns: The prior indexPath, or nil if we're at the minimumIndexPath
     - SeeAlso: `var minimumIndexPath`
     */
    public func indexPath(before indexPath: IndexPath) -> IndexPath? {
        if indexPath == minimumIndexPath {
            return nil
        }
        
        assertIsValid(indexPath: indexPath)
        
        if indexPath.item == 0 {
            let lastRow = numberOfRows(inSection: indexPath.section - 1)
            return IndexPath(row: lastRow, section: indexPath.section - 1)
        } else {
            return IndexPath(row: indexPath.row - 1, section: indexPath.section)
        }
    }
    
    private func assertIsValid(indexPath: IndexPath, file: StaticString = #file, line: UInt = #line) {
        let maxPath = maximumIndexPath
        assert(
            indexPath.section <= maxPath.section && indexPath.section >= 0,
            "Index path \(indexPath) is outside the bounds set by the minimum (\(minimumIndexPath)) and maximum (\(maxPath)) index path",
            file: file,
            line: line
        )
        let rowCount = numberOfRows(inSection: indexPath.section)
        assert(
            indexPath.row < rowCount && indexPath.row >= 0,
            "Index path \(indexPath) row index is outside the bounds of the rows (\(rowCount)) in the indexPath's section",
            file: file,
            line: line
        )
    }
}
