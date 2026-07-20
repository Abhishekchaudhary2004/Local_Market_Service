# Multi-stage Dockerfile for a .NET 10 Razor Pages application
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy the solution and all files then restore and publish
COPY ["Local_Market_Service.slnx", "./"]
COPY . .

RUN dotnet restore "Local_Market_Service.slnx"
RUN dotnet publish "Local_Market_Service.slnx" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "Local_Market_Service.dll"]
