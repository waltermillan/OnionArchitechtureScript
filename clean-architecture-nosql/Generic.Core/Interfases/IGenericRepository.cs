using Core.Entities;
using MongoDB.Bson;

namespace Core.Interfases;
public interface IGenericRepository<T> where T : BaseEntity
{
    Task CreateAsync(GenericBase genericBase);      // Create a item
    Task<T> GetByIdAsync(ObjectId id);              // Read all items
    Task<IEnumerable<T>> GetAllAsync();             // Read a item
    Task UpdateAsync(GenericBase genericBase);      // Update a item
    Task DeleteAsync(ObjectId id);                  // Delete a item
}
