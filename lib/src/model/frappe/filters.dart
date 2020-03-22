/// Helper class to check whether the filter conforms with Frappé's format.
class DBFilter {
  DBFilter();

  /// Checks whether the filter conforms with Frappé.
  ///
  /// There are three formats:
  ///
  /// 1. Type1:
  /// ```
  /// {
  /// "name": "test",
  /// "enabled": 1
  /// }
  /// ```
  ///
  /// 2. Type2:
  /// ```
  /// [
  /// ['name', 'LIKE', 'test']
  /// ]
  /// ```w
  ///
  /// 3. Type3:
  /// ```
  /// {
  /// "name": ['LIKE', 'TEST']
  /// }
  /// ```
  static bool isDBFilter(dynamic filter) {
    var isDBFilter = false;

    if (filter is! Map && filter is! List) return false;

    // Check if it's of type {name: 'Test'}
    if (filter is Map<String, dynamic>) {
      // If the below is false, it means it's of type 3
      if (filter.values.every((dynamic value) => value is! List)) {
        return filter.values.every((dynamic value) =>
            value is String || value is int || value is double);
      }
    }

    //Check if it's of type [['name', 'LIKE', 'TEST']]
    if (filter is List<List<dynamic>>) {
      for (var i in filter) {
        if (i.length == 3) {
          if (i[0] is! String || !isDBOperator(i[1]) || !isDBValue(i[2])) {
            return false;
          }
        }
      }
      return true;
    }

    //Check if it's of type {name: ['LIKE', 'TEST']}
    if (filter is Map<String, List<dynamic>>) {
      isDBFilter = true;
      filter.forEach((String k, List<dynamic> v) {
        if (v.length == 2) {
          if (isDBFilter) {
            if (!isDBOperator(v[0]) || !isDBValue(v[1])) {
              isDBFilter = false;
            }
          }
        } else {
          isDBFilter = false;
        }
      });
    }

    return isDBFilter;
  }

  /// Checks if the values of the filter are the ones supported by Frappé.
  ///
  /// Supported types
  /// - null
  /// - String
  /// - int
  /// - double
  /// - List<String>
  /// - List<int>
  /// - List<double>
  static bool isDBValue(dynamic value) =>
      value == null ||
      value is String ||
      value is int ||
      value is double ||
      value is List<String> ||
      value is List<int> ||
      value is List<double>;

  static List<Type> a = [String];

  /// Checks if the operator (SQL) is valid.
  ///
  /// The allowed operators are defined in [operators].
  static bool isDBOperator(String operator) => operators.contains(operator);

  /// The allowed operators that can be used in filtering.
  static const List<String> operators = <String>[
    'LIKE',
    'NOT LIKE',
    '=',
    '!=',
    'IS',
    'IN',
    'NOT IN',
    'ANCESTORS OF',
    'NOT ANCESTORS OF',
    'DESCENDANTS OF',
    'NOT DESCENDANTS OF',
    'BETWEEN',
    '>',
    '<',
    '>=',
    '<='
  ];
}
