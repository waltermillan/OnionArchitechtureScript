using Core.Interfases;

namespace Core.Interfases;

public interface IUnitOfWork
{
    IGenericBaseRepository GenericBase { get; }
    void Dispose();
    Task<int> SaveAsync();
}
