enum units { metric, imperial }
enum region { us, uk }

/// Settings for things like:
/// theme, units, region
class Settings {
  Settings(this.properties);
  Map<String, dynamic> properties = {};

  void setProperty(String propertyName, dynamic value) => properties['propertyName'] = value;
  dynamic getProperty(String propertyName) => properties['propertyName'];
}
