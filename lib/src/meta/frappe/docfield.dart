import 'package:json_annotation/json_annotation.dart';

import '../../model/frappe/document.dart';
import '../../model/frappe/utils.dart';

part 'docfield.g.dart';

/// Class containing properties of a docField. In addition, it contains helper functions for frappe docs.
@JsonSerializable()
class DocField extends FrappeDocument {
  DocField() : super('DocField');

  factory DocField.fromJson(Map<String, dynamic>? json) =>
      _$DocFieldFromJson(json!);

  @JsonKey(ignore: true)
  List<String> docFieldTypes = <String>[
    'Attach',
    'Attach Image',
    'Barcode',
    'Button',
    'Check',
    'Code',
    'Color',
    'Column Break',
    'Currency',
    'Data',
    'Date',
    'Datetime',
    'Dynamic Link',
    'Float',
    'Fold',
    'Geolocation',
    'Heading',
    'HTML',
    'HTML Editor',
    'Image',
    'Int',
    'Link',
    'Long Text',
    'Password',
    'Percent',
    'Read Only',
    'Section Break',
    'Select',
    'Small Text',
    'Table',
    'Text',
    'Text Editor',
    'Time',
    'Signature'
  ];

  @JsonKey(
      name: 'allow_bulk_edit',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowBulkEdit;
  @JsonKey(
      name: 'allow_in_quick_entry',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowInQuickEntry;
  @JsonKey(
      name: 'allow_on_submit',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowOnSubmit;
  @JsonKey(
      name: 'bold',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? bold;

  @JsonKey(
      name: 'in_preview',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inPreview;

  /// Whether the field is collapsible in the UI
  @JsonKey(
      name: 'collapsible',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? collapsible;
  @JsonKey(name: 'collapsible_depends_on')
  String? collapsibleDependsOn;

  int? columns;
  @JsonKey(name: 'default')
  String? defaults;
  @JsonKey(name: 'depends_on')
  String? dependsOn;
  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'fetch_from')
  String? fetchFrom;
  @JsonKey(
      name: 'fetch_if_empty',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? fetchIfEmpty;

  /// The name of the field which is the field's identifier
  @JsonKey(name: 'fieldname')
  String? fieldName;

  /// The type of the fields defined in frappe such as `Data`, `Link`, `Select`, etc
  @JsonKey(name: 'fieldtype')
  String? fieldType = '';

  /// Whether the field is hidden
  @JsonKey(
      name: 'hidden',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? hidden;

  @JsonKey(
      name: 'ignore_user_permissions',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? ignoreUserPermissions;
  @JsonKey(
      name: 'ignore_xss_filter',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? ignoreXssFilter;
  @JsonKey(
      name: 'in_filter',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inFilter;
  @JsonKey(
      name: 'in_global_search',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inGlobalSearch;
  @JsonKey(
      name: 'show_preview_popup',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? showPreviewPopup;

  /// Whether the field should appear in the list view of the doctype
  @JsonKey(
      name: 'in_list_view',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inListView;

  /// Whether to include the field in the default filters appearing in list view, for instance
  @JsonKey(
      name: 'in_standard_filter',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inStandardFilter;
  @JsonKey(
      name: 'is_custom_field',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isCustomField;

  /// The human readable label of the field
  ///
  /// For example: `item_name` field would have a label called "Item Name"

  String? label;
  int? length;
  @JsonKey(name: 'linked_document_type')
  String? linkedDocumentType;
  @JsonKey(
      name: 'no_copy',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? noCopy;
  @JsonKey(name: 'oldfieldname')
  String? oldFieldName;
  @JsonKey(name: 'oldfieldtype')
  String? oldFieldType;

  /// Options contained for the docField.
  ///
  /// Link datatype will hold the doctype of the linked doctype
  /// Select datatype will contain the list of the options delimited by a line break
  @JsonKey(name: 'options')
  String? options;
  @JsonKey(name: 'permlevel')
  int? permLevel;
  String? precision;
  @JsonKey(
      name: 'print_hide',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? printHide;
  @JsonKey(
      name: 'print_hide_if_no_value',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? printHideIfNoValue;
  @JsonKey(name: 'print_width')
  String? printWidth;

  /// Whether the field is not editable and just read-only
  @JsonKey(
      name: 'read_only',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? readOnly;
  @JsonKey(
      name: 'remember_last_selected_value',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? rememberLastSelectedValue;
  @JsonKey(
      name: 'report_hide',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? reportHide;

  /// Whether the field is mandatory
  @JsonKey(
      name: 'reqd',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? required;
  @JsonKey(name: 'search_fields')
  List? searchFields;
  @JsonKey(
      name: 'search_index',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? searchIndex;
  @JsonKey(
      name: 'set_only_once',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? setOnlyOnce;

  /// Whether the field is translatable
  @JsonKey(
      name: 'translatable',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? translatable;

  @JsonKey(name: 'trigger')
  String? trigger;
  @JsonKey(
      name: 'unique',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? unique;
  @JsonKey(name: 'width')
  String? width;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => DocField.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$DocFieldToJson(this);
}
