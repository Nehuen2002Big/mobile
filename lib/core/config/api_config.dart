class ApiConfig {
  const ApiConfig({
    required this.iamBaseUrl,
    required this.personasBaseUrl,
    required this.trackingBaseUrl,
    required this.routesBaseUrl,
  });

  final String iamBaseUrl;
  final String personasBaseUrl;
  final String trackingBaseUrl;
  final String routesBaseUrl;

  static const ApiConfig production = ApiConfig(
    iamBaseUrl: 'https://iam.isatech.net',
    // OJO: el subdominio es `api-persons` (con S), no `api-people`.
    // `api-people.isatech.net` no resuelve en DNS — se nos colo el typo
    // de la spec inicial. Si lo cambiamos, actualizar tambien
    // docs/auth.md.
    personasBaseUrl: 'https://api-persons.isatech.net',
    trackingBaseUrl: 'https://api-tracking.isatech.net',
    routesBaseUrl: 'https://api-routes.isatech.net',
  );

  static const ApiConfig local = ApiConfig(
    iamBaseUrl: 'http://10.0.2.2:8010',
    personasBaseUrl: 'http://10.0.2.2:8011',
    trackingBaseUrl: 'http://10.0.2.2:8014',
    routesBaseUrl: 'http://10.0.2.2:8013',
  );

  static const ApiConfig current = production;

  String get iamApi => '$iamBaseUrl/api/v1';
  String get personasApi => '$personasBaseUrl/api/v1';
  String get trackingApi => '$trackingBaseUrl/api/v1';
  String get routesApi => '$routesBaseUrl/api/v1';
}
