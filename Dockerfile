FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base

USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081


FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/SharperMe.WebApp/SharperMe.WebApp.csproj", "src/SharperMe.WebApp/"]
RUN dotnet restore "src/SharperMe.WebApp/SharperMe.WebApp.csproj"
COPY . .
RUN dotnet build "src/SharperMe.WebApp/SharperMe.WebApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish

ARG BUILD_CONFIGURATION=Release

RUN dotnet publish "src/SharperMe.WebApp/SharperMe.WebApp.csproj" -c $BUILD_CONFIGURATION  -o /app/publish /p:UseAppHost=false

FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "SharperMe.WebApp.dll"]