enum RouteValue {
  splash(
    path: '/',
  ),
  home(
    path: '/home',
  ),
  recipe(
    path: 'recipe',
  ),
  create(
    path: '/create',
  ),
  challenge(
    path: '/challenge',
  ),
  recommendation(
    path: '/recommendation',
  ),
   privacyScreen(
    path: '/privacyScreen',
  ),
  unknown(
    path: '',
  );

  final String path;

  const RouteValue({
    required this.path,
  });
}
