using Core.Interfases;
using Infrastructure.Repositories;
using Microsoft.Extensions.Configuration;
using MongoDB.Driver;

namespace Infrastructure.UnitOfWork;

public class UnitOfWork : IUnitOfWork, IDisposable
{
    private readonly IMongoDatabase _database;
    private IGenericBaseRepository _genericBase;

    public UnitOfWork(IMongoClient mongoClient, IConfiguration configuration)
    {
        var databaseName = configuration["ProductDBName"]; // Read database name from configuration
        _database = mongoClient.GetDatabase(databaseName);
    }

    public IGenericBaseRepository GenericBase
    {
        get
        {
            if (_genericBase is null)
                // Passing the MongoDB collection to the repository
                _genericBase = new GenericBaseRepository(_database.GetCollection<Core.Entities.GenericBase>("GenericBase"));

            return _genericBase;
        }
    }

    public void Dispose()
    {

    }

    public Task<int> SaveAsync()
    {
        return Task.FromResult(1);
    }
}
