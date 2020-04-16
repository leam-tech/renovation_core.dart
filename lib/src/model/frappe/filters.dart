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
  /// ```
  ///
  /// 3. Type3:
  /// ```
  /// {
  /// "name": ['LIKE', 'TEST']
  /// }
  /// ```
  static bool isDBFilter(dynamic filter) {
    var isDBFilter = false;

    if (filter is Map<String, dynamic>) {
      for (final value in filter.values) {
        if (_isDBSingleValue(value)) {
          isDBFilter = true;
        } else if (_isDBListValue(value)) {
          //Check if it's of type {name: ['LIKE', 'TEST']}
          isDBFilter = value.length == 2 &&
              !(!isDBOperator(value[0]) || !isDBValue(value[1]));
        } else {
          isDBFilter = false;
        }
        if (!isDBFilter) break;
      }
    } else if (filter is List) {
      //Check if it's of type [['name', 'LIKE', 'TEST']]
      if (filter is List<List<dynamic>>) {
        for (final i in filter) {
          if (i.length == 3) {
            if (i[0] is! String || !isDBOperator(i[1]) || !isDBValue(i[2])) {
              return false;
            }
          }
        }
        return true;
      }
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
      _isDBSingleValue(value) || _isDBListValue(value);

  static bool _isDBSingleValue(dynamic value) =>
      value == null || value is String || value is int || value is double;

  static bool _isDBListValue(dynamic value) =>
      value == null ||
      value is List<String> ||
      value is List<int> ||
      value is List<double>;

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
