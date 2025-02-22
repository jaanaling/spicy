enum IconProvider {
  chellenge(imageName: 'chellenge.svg'),
  chellenge_a(imageName: 'chellenge_a.svg'),
  create(imageName: 'create.svg'),
  create_a(imageName: 'create_a.svg'),
  home(imageName: 'home.svg'),
  home_a(imageName: 'home_a.svg'),
  meat(imageName: 'meat.svg'),
  no_photo(imageName: 'no_photo.svg'),
  pepper(imageName: 'pepper.png'),
  rec(imageName: 'rec.svg'),
  rec_a(imageName: 'rec_a.svg'),
  spices(imageName: 'spices.svg'),
  splash(imageName: 'splash.webp'),
  veg(imageName: 'veg.svg'),
  china(imageName: 'china.svg'),
  india(imageName: 'india.svg'),
  malaysia(imageName: 'malaysia.svg'),
  south_korea(imageName: 'south-korea.svg'),
  thailand(imageName: 'thailand.svg'),
  vietnam(imageName: 'vietnam.svg'),
  dish_card(imageName: 'dish_card.svg'),
  logo(imageName: 'logo.webp'),
  calories(imageName: 'calories.svg'),
  search(imageName: 'search.svg'),
  chevronDown(imageName: 'chevron_down.svg'),
  arrowNext(imageName: 'back.svg'),
  pepperInactive(imageName: 'pepper_inactive.png'),
  button(imageName: 'button.png'),
   bigb(imageName: 'bigb.svg'),

  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
