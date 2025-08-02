// API
const String kBaseUrl = String.fromEnvironment("API_BASE_URL", defaultValue: "http://localhost:8080");
// ignore: prefer_interpolation_to_compose_strings
const String kApiBaseUrl = String.fromEnvironment("API_BASE_URL", defaultValue: "http://localhost:8080") + "/api/v1";
