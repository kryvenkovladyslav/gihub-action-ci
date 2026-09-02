# First Stage:
# This is used to run dotnet app (ASP.NET Runtime). 
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base 

USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Second Stage (Restore + Build): 
# .NET SDK is used only for building an app. Won't be included in the final image.

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/SharperMe.WebApp/SharperMe.WebApp.csproj", "SharperMe.WebApp/"]
RUN dotnet restore "SharperMe.WebApp/SharperMe.WebApp.csproj"

COPY src/SharperMe.WebApp/ ./SharperMe.WebApp/
RUN dotnet build "SharperMe.WebApp/SharperMe.WebApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Third Stage (Publish):

FROM build AS publish

ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SharperMe.WebApp/SharperMe.WebApp.csproj" -c $BUILD_CONFIGURATION  -o /app/publish /p:UseAppHost=false

# Fourth Stage (Final App):
# The final image will include a runtime and the app itself.

FROM base AS final

WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SharperMe.WebApp.dll"]