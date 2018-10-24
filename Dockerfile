FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY other.csproj ./
RUN dotnet restore other.csproj
COPY . .
WORKDIR /src/
RUN dotnet build other.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish other.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "other.dll"]
