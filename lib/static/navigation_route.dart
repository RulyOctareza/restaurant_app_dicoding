enum NavigationRoute {
  homeRoute('/home'),
  detailRoute('/detail'),
  searchPage('/searchpage');

  const NavigationRoute(this.name);
  final String name;
}
