using Microsoft.Extensions.DependencyInjection;

namespace Dependencies
{
    public class Stub
    {

    }

    public static class Extensions
    {
        public static IServiceCollection AppDependencies(this IServiceCollection services)
        {
            if (services == null)
                throw new ArgumentNullException(nameof(services));

            services.AddSingleton<Stub>();
            return services;
        }
    }
}
