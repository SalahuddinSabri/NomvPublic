class Home_Menu {
  Home_Menu(
      {required this.name,
      required this.title,
      required this.subtitle,
      required this.home_image_path});

  final String name;
  final String title, subtitle;
  final String home_image_path;
}

List<Home_Menu> home_menu = [
  Home_Menu(
      name: '',
      title: 'Who We Are',
      subtitle: 'Our Story',
      home_image_path: 'assets/images/who.svg'),
  Home_Menu(
      name: '',
      title: 'Leadership Team',
      subtitle: 'Lead With Integrity',
      home_image_path: 'assets/images/bookmark.svg'),
  Home_Menu(
      name: '',
      title: 'Upcoming Conferences',
      subtitle: 'Join Us',
      home_image_path: 'assets/images/conference.svg'),
  Home_Menu(
      name: '',
      title: 'Resources',
      subtitle: 'Downloadable Content',
      home_image_path: 'assets/images/resources_icon.svg'),
  Home_Menu(
      name: '',
      title: 'Listings',
      subtitle: 'Peer Suggested Resources',
      home_image_path: 'assets/images/listings.svg'),
  Home_Menu(
      name: '',
      title: 'Speaker Request Form',
      subtitle: 'Let Us Hear You',
      home_image_path: 'assets/images/speaker_request.svg'),
];


