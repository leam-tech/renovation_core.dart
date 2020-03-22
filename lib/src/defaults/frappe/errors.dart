class InvalidDefaultsValue extends Error {
  @override
  String toString() =>
      'Invalid Value type. \nSupported types are "String", "Map<String, dynamic>",List<dynamic>, "bool" or "num"'
      '\n For Maps and Lists, the values should conform to the types stated above';
}
