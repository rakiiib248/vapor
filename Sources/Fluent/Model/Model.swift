import Async

/// Fluent database models. These types can be fetched
/// from a database connection using a query.
///
/// Types conforming to this protocol provide the basis
/// fetching and saving data to/from Fluent.
public protocol Model: class, Codable {
    /// The associated Identifier type.
    /// Usually Int or UUID.
    associatedtype I: Identifier

    /// This model's collection/table name
    static var entity: String { get }

    /// The model's identifier.
    var id: I? { get set }

    /// Called before a model is created when saving.
    /// Throwing will cancel the save.
    func willCreate() throws
    /// Called after the model is created when saving.
    func didCreate()

    /// Called before a model is updated when saving.
    /// Throwing will cancel the save.
    func willUpdate() throws
    /// Called after the model is updated when saving.
    func didUpdate()

    /// Called before a model is deleted.
    /// Throwing will cancel the deletion.
    func willDelete() throws
    /// Called after the model is deleted.
    func didDelete()
}

/// Free implementations.
extension Model {
    /// See Model.entity
    public static var entity: String {
        return "\(Self.self)".lowercased() + "s"
    }

    /// Seee Model.willCreate()
    public func willCreate() throws {}
    /// See Model.didCreate()
    public func didCreate() {}

    /// See Model.willUpdate()
    public func willUpdate() throws  {}
    /// See Model.didUpdate()
    public func didUpdate() {}

    /// See Model.willDelete()
    public func willDelete() throws {}
    /// See Model.didDelete()
    public func didDelete() {}
}

/// MARK: CRUD

extension Model {
    /// Saves this model to the supplied query executor.
    /// If `shouldCreate` is true, the model will be saved
    /// as a new item even if it already has an identifier.
    public func save(
        on executor: QueryExecutor,
        shouldCreate: Bool = false
    ) -> Future<Void> {
        return executor.query(Self.self).save(self, shouldCreate: shouldCreate)
    }

    /// Saves this model to the supplied query executor.
    /// If `shouldCreate` is true, the model will be saved
    /// as a new item even if it already has an identifier.
    public func delete(
        on executor: QueryExecutor
    ) -> Future<Void> {
        return executor.query(Self.self).delete(self)
    }

    /// Attempts to find an instance of this model w/
    /// the supplied identifier.
    public static func find(_ id: Self.I, on executor: QueryExecutor) -> Future<Self?> {
        let query = executor.query(Self.self)
        query.filter("id" == id)
        return query.first()
    }
}
