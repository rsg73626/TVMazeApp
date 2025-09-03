//
//  File.swift
//  Local
//
//  Created by Renan Germano on 03/09/25.
//

import Combine
import CoreData
import Domain
import LocalAPI

public final class CoreDataShowsPaginationRepository: ShowsPaginationRepository {
    
    private let persistence: PersistenceController
    private let context: NSManagedObjectContext
    private let showsPaginationParser: ShowsPaginationParsing
    private let showsParser: ShowsParsing
    private let encoder: JSONEncoder

    public init(
        persistence: PersistenceController,
        showsPaginationParser: ShowsPaginationParsing? = nil,
        showsParser: ShowsParsing? = nil,
        encoder: JSONEncoder = .init()
    ) {
        self.persistence = persistence
        self.context = persistence.container.newBackgroundContext()
        self.showsPaginationParser = showsPaginationParser ?? ShowsPaginationParser()
        self.showsParser = showsParser ?? ShowsParser()
        self.encoder = encoder
    }
    
    // MARK: - ShowsPaginationRepository
    
    public func add(id: String, shows: [Show], timestamp: Double) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(NSError())) }
            let context = self.context
            context.perform {
                do {
                    self.addPaginationToContext(id: id, shows: shows, timestamp: timestamp)
                    try context.save()
                    promise(.success(()))
                } catch {
                    context.rollback()
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    public func delete(id: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(NSError())) }
            let context = self.context
            context.perform {
                do {
                    guard let pagination = try? self.fetchShowsPagination(id: id) else {
                        return promise(.failure(NSError()))
                    }
                    guard let showsEntities = try? self.fetchShows(ids: pagination.object.showsIds) else {
                        return promise(.failure(NSError()))
                    }
                    for showEntity in showsEntities {
                        context.delete(showEntity)
                    }
                    context.delete(pagination.entity)
                    try context.save()
                } catch {
                    context.rollback()
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func pagination(id: String) -> AnyPublisher<(shows: [Show], timeStamp: Double), Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(NSError())) }
            let context = self.context
            context.perform {
                do {
                    guard let pagination = try self.fetchShowsPagination(id: id) else {
                        return promise(.failure(NSError()))
                    }
                    guard let showsEntities = try self.fetchShows(ids: pagination.object.showsIds) else {
                        return promise(.failure(NSError()))
                    }
                    let shows = self.showsParser.parse(entities: showsEntities)
                    promise(.success((shows, pagination.object.timestamp)))
                } catch {
                    context.rollback()
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func update(id: String, timestamp: Double) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(NSError())) }
            let context = self.context
            context.perform {
                do {
                    guard let pagination = try? self.fetchShowsPagination(id: id) else {
                        return promise(.failure(NSError()))
                    }
                    pagination.entity.timestamp = timestamp
                    try context.save()
                } catch {
                    context.rollback()
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private func addPaginationToContext(id: String, shows: [Show], timestamp: Double) {
        let showsPaginationEntity = ShowsPaginationEntity(context: context)
        showsPaginationEntity.id = id
        showsPaginationEntity.showIds = try? encoder.encode((shows.map { $0.id }))
        showsPaginationEntity.timestamp = timestamp
        
        for show in shows {
            addShowToContext(show)
        }
    }
    
    private func addShowToContext(_ show: Show) {
        let simpleImageEntity = SimpleImageEntity(context: context)
        simpleImageEntity.medium = show.image.medium
        simpleImageEntity.original = show.image.original
        
        let showEntity = ShowEntity(context: context)
        showEntity.id = Int64(show.id)
        showEntity.name = show.name
        showEntity.genresData = try? JSONEncoder().encode(show.genres)
        showEntity.summary = show.summary
        showEntity.image = simpleImageEntity
        
        if let year = show.year {
            showEntity.year = Int64(year)
        }
    }
    
    private func fetchShowsPagination(id: String) throws -> (entity: ShowsPaginationEntity, object: ShowsPagination)? {
        let request = ShowsPaginationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            if let showsPaginationEntity = try context.fetch(request).first,
               let showsPagination = showsPaginationParser.parse(entity: showsPaginationEntity) {
                return (showsPaginationEntity, showsPagination)
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    private func fetchShows(ids: [Int]) throws -> [ShowEntity]? {
        let request = ShowEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let showsEntities = try context.fetch(request)
            return showsEntities
        } catch {
            throw error
        }
    }
    
}
