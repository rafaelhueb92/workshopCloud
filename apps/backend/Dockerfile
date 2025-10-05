FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS builder
WORKDIR /backend
COPY . .
ENV ASPNETCORE_ENVIRONMENT Development
ENV URLS http://0.0.0.0:80
RUN dotnet publish -c Release -o build /backend/YoutubeLiveApp.csproj

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine AS runner
WORKDIR /backend
COPY --from=builder /backend/build /backend/
EXPOSE 80
ENTRYPOINT ["dotnet", "/backend/YoutubeLiveApp.dll"] 