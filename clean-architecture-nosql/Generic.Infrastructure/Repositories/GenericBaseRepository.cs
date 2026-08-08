using Core.Entities;
using Core.Interfases;
using MongoDB.Bson;
using MongoDB.Driver;
using System.Linq.Expressions;
using System.Security.AccessControl;

namespace Infrastructure.Repositories;

public class GenericBaseRepository : IGenericBaseRepository
{
    private readonly IMongoCollection<GenericBase> _genericBase;

    public GenericBaseRepository(IMongoCollection<GenericBase> genericBase)
    {
        _genericBase = genericBase;
    }

    public async Task<IEnumerable<GenericBase>> GetAllAsync()
    {
        var collatzsConjecture = await _genericBase.Find(collatzConjecture => true).ToListAsync();
        return collatzsConjecture;
    }

    public async Task<GenericBase> GetByIdAsync(ObjectId id)
    {
        var genericBase = await _genericBase.Find(collatzConjecture => collatzConjecture.Id == id).FirstOrDefaultAsync();
        return genericBase;
    }

    public async void Add(GenericBase genericBase)
    {
        await _genericBase.InsertOneAsync(genericBase);
    }

    public async void AddRange(IEnumerable<GenericBase> entities)
    {
        await _genericBase.InsertManyAsync(entities);
    }

    public async void Remove(GenericBase entity)
    {
        await _genericBase.DeleteOneAsync(p => p.Id == entity.Id);
    }

    public async void RemoveRange(IEnumerable<GenericBase> entities)
    {
        var ids = entities.Select(e => e.Id).ToList();
        await _genericBase.DeleteManyAsync(p => ids.Contains(p.Id));
    }

    public async void Update(GenericBase genericBase)
    {
        await _genericBase.ReplaceOneAsync(p => p.Id == genericBase.Id, genericBase);
    }

    public async Task<IEnumerable<GenericBase>> Find(Expression<Func<GenericBase, bool>> predicate)
    {
        return await _genericBase.Find(predicate).ToListAsync();
    }

    public async Task CreateAsync(GenericBase genericBase)
    {
        await _genericBase.InsertOneAsync(genericBase);
    }

    public async Task UpdateAsync(GenericBase genericBase)
    {
        await _genericBase.ReplaceOneAsync(p => p.Id == genericBase.Id, genericBase);
    }

    public async Task DeleteAsync(ObjectId id)
    {
        await _genericBase.DeleteOneAsync(p => p.Id == id);
    }
}
