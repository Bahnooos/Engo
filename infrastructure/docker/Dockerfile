# build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

COPY ["Engli3m.Infrastructure/Engli3m.Infrastructure.csproj", "Engli3m.Infrastructure/"]
COPY ["Engli3m.Domain/Engli3m.Domain.csproj", "Engli3m.Domain/"]
COPY ["Engli3m.Application/Engli3m.Application.csproj", "Engli3m.Application/"]
COPY ["Engli3m/Engli3m.csproj", "Engli3m/"]

RUN dotnet restore "Engli3m/Engli3m.csproj"

COPY . .


# publish stage
FROM build AS publish
WORKDIR /src/Engli3m
RUN dotnet publish "Engli3m.csproj" -c Release -o /app /p:UseAppHost=false

# run stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app .
ENV ASPNETCORE_HTTP_PORTS=8000
EXPOSE 8000

ENTRYPOINT ["dotnet", "Engli3m.dll"]