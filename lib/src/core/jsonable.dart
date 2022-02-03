/// Abstract class containing serializing methods
///
/// In addition includes helper functions.
abstract class JSONAble {
  JSONAble();

  /// Returns the target type from json ([Map])
  T fromJson<T>(Map<String, dynamic> json);

  /// Returns the JSON representation of a type in the form of [Map]
  Map<String, dynamic> toJson();

  /// Returns a clone of the object preserving the type
  static T clone<T extends JSONAble>(JSONAble object) =>
      object.fromJson(object.toJson());

  List<T>? deserializeList<T>(List? docs) => docs != null
      ? List<T>.from(docs.map<dynamic>((dynamic obj) => fromJson<T>(obj)))
      : null;
}
