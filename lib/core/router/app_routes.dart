/// Route paths (kept separate from the router to avoid import cycles).
abstract final class AppRoutes {
  static const map = '/';
  static const garage = '/garage';
  static const vehicleNew = '/garage/new';
  static const vehicleEdit = '/garage/edit';
  static const history = '/history';
  static const fillUpNew = '/history/new';
}
