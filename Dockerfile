#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

#COPY zscaler.crt /usr/local/share/ca-certificates/zscaler.crt
#RUN chmod 644 /usr/local/share/ca-certificates/zscaler.crt && update-ca-certificates

ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["./Web/autoinstrumentation-repro.csproj", "autoinstrumentation-repro/"]
COPY ["./Dependencies/Dependencies.csproj", "Dependencies/"]
RUN dotnet restore "autoinstrumentation-repro/autoinstrumentation-repro.csproj" -r linux-x64 -v n

COPY ["Web/", "Web/"]
COPY ["Dependencies/", "Dependencies/"]

WORKDIR "/src/Web/."
RUN dotnet build "./autoinstrumentation-repro.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./autoinstrumentation-repro.csproj" -c $BUILD_CONFIGURATION -o /app/publish -v n -r linux-x64 --no-self-contained

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["./autoinstrumentation-repro"]