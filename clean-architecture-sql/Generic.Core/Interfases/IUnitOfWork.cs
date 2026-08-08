using Core.Interfases;

namespace Core.Interfases;

public interface IUnitOfWork
{

    void Dispose();
    Task<int> SaveAsync();
}
