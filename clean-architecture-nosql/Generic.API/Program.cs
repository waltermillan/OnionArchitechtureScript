using API.Extensions;
using Core.Entities;
using Core.Interfases;
using Infrastructure.Repositories;
using Infrastructure.UnitOfWork;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Driver;
using Serilog;
using Serilog.Filters;
using System.Reflection.PortableExecutable;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();

// Configure Serilog
builder.Logging.AddFilter("Microsoft", LogLevel.Warning);
builder.Logging.AddFilter("System", LogLevel.Warning);

Log.Logger = new LoggerConfiguration()
    .WriteTo.File("logs/CollaztsConjecture-.log", rollingInterval: RollingInterval.Day)
    .Filter.ByExcluding(Matching.FromSource("Microsoft.EntityFrameworkCore"))
    .Filter.ByExcluding(Matching.FromSource("Microsoft.AspNetCore"))
    .CreateLogger();

builder.Logging.AddSerilog();

// Add controllers to handle requests
builder.Services.AddControllers();

builder.Services.AddAuthorization();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.ConfigureCors();
builder.Services.AddAplicacionServices();

builder.Services.AddSingleton<IMongoClient, MongoClient>(sp =>
{
    var configuration = sp.GetRequiredService<IConfiguration>();
    return new MongoClient(configuration.GetValue<string>("CollatzConjectureDBConnection"));
});

builder.Services.AddScoped<IUnitOfWork>(sp =>
{
    var mongoClient = sp.GetRequiredService<IMongoClient>();
    var configuration = sp.GetRequiredService<IConfiguration>();
    return new UnitOfWork(mongoClient, configuration);
});

builder.Services.AddScoped<IGenericBaseRepository>(sp =>
{
    var mongoClient = sp.GetRequiredService<IMongoClient>();
    var configuration = sp.GetRequiredService<IConfiguration>();
    var databaseName = configuration.GetValue<string>("GenericBaseDBName");
    var database = mongoClient.GetDatabase(databaseName);
    var collection = database.GetCollection<GenericBase>("GenericBaseCollection");
    return new GenericBaseRepository(collection);
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("CorsPolicy");
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
