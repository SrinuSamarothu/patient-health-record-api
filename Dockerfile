FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["PHRservice/PHRservice.csproj", "PHRservice/"]
COPY ["PHRBusinessLogic/PHRBusinessLogic.csproj", "PHRBusinessLogic/"]
COPY ["PHREntityFrame/PHREntityFrame.csproj", "PHREntityFrame/"]
COPY ["PHRModels/PHRModels.csproj", "PHRModels/"]
RUN dotnet restore "PHRservice/PHRservice.csproj"
COPY . .
WORKDIR "/src/PHRservice"
RUN dotnet build "PHRservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PHRservice.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PHRservice.dll"]