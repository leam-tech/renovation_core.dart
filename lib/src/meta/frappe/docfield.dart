import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../model/frappe/document.dart';
import '../../model/frappe/utils.dart';

part 'docfield.g.dart';

/// Class containing properties of a docField. In addition, it contains helper functions for frappe docs.
@JsonSerializable()
class DocField extends FrappeDocument {
  DocField() : super('DocField');

  factory DocField.fromJson(Map<String, dynamic>? json) =>
      _$DocFieldFromJson(json!);

  @nonVirtual
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

  @nonVirtual
  @JsonKey(
      name: 'allow_bulk_edit',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowBulkEdit;

  @nonVirtual
  @JsonKey(
      name: 'allow_in_quick_entry',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowInQuickEntry;

  @nonVirtual
  @JsonKey(
      name: 'allow_on_submit',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowOnSubmit;

  @nonVirtual
  @JsonKey(
      name: 'bold',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? bold;

  @nonVirtual
  @JsonKey(
      name: 'in_preview',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inPreview;

  @nonVirtual

  /// Whether the field is collapsible in the UI
  @JsonKey(
      name: 'collapsible',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? collapsible;

  @nonVirtual
  @JsonKey(name: 'collapsible_depends_on')
  String? collapsibleDependsOn;

  @nonVirtual
  int? columns;

  @nonVirtual
  @JsonKey(name: 'default')
  String? defaults;

  @nonVirtual
  @JsonKey(name: 'depends_on')
  String? dependsOn;

  @nonVirtual
  @JsonKey(name: 'description')
  String? description;

  @nonVirtual
  @JsonKey(name: 'fetch_from')
  String? fetchFrom;

  @nonVirtual
  @JsonKey(
      name: 'fetch_if_empty',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? fetchIfEmpty;

  /// The name of the field which is the field's identifier
  @nonVirtual
  @JsonKey(name: 'fieldname')
  String? fieldName;

  /// The type of the fields defined in frappe such as `Data`, `Link`, `Select`, etc
  @nonVirtual
  @JsonKey(name: 'fieldtype')
  String? fieldType = '';

  /// Whether the field is hidden
  @nonVirtual
  @JsonKey(
      name: 'hidden',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? hidden;

  @nonVirtual
  @JsonKey(
      name: 'ignore_user_permissions',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? ignoreUserPermissions;

  @nonVirtual
  @JsonKey(
      name: 'ignore_xss_filter',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? ignoreXssFilter;

  @nonVirtual
  @JsonKey(
      name: 'in_filter',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inFilter;

  @nonVirtual
  @JsonKey(
      name: 'in_global_search',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inGlobalSearch;

  @nonVirtual
  @JsonKey(
      name: 'show_preview_popup',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? showPreviewPopup;

  /// Whether the field should appear in the list view of the doctype
  @nonVirtual
  @JsonKey(
      name: 'in_list_view',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inListView;

  /// Whether to include the field in the default filters appearing in list view, for instance
  @nonVirtual
  @JsonKey(
      name: 'in_standard_filter',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inStandardFilter;

  @nonVirtual
  @JsonKey(
      name: 'is_custom_field',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isCustomField;

  /// The human readable label of the field
  ///
  /// For example: `item_name` field would have a label called "Item Name"

  @nonVirtual
  String? label;

  @nonVirtual
  int? length;

  @nonVirtual
  @JsonKey(name: 'linked_document_type')
  String? linkedDocumentType;

  @nonVirtual
  @JsonKey(
      name: 'no_copy',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? noCopy;

  @nonVirtual
  @JsonKey(name: 'oldfieldname')
  String? oldFieldName;

  @nonVirtual
  @JsonKey(name: 'oldfieldtype')
  String? oldFieldType;

  /// Options contained for the docField.
  ///
  /// Link datatype will hold the doctype of the linked doctype
  /// Select datatype will contain the list of the options delimited by a line break
  @nonVirtual
  @JsonKey(name: 'options')
  String? options;

  @nonVirtual
  @JsonKey(name: 'permlevel')
  int? permLevel;

  @nonVirtual
  String? precision;

  @nonVirtual
  @JsonKey(
      name: 'print_hide',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? printHide;

  @nonVirtual
  @JsonKey(
      name: 'print_hide_if_no_value',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? printHideIfNoValue;

  @nonVirtual
  @JsonKey(name: 'print_width')
  String? printWidth;

  /// Whether the field is not editable and just read-only
  @nonVirtual
  @JsonKey(
      name: 'read_only',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? readOnly;

  @nonVirtual
  @JsonKey(
      name: 'remember_last_selected_value',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? rememberLastSelectedValue;

  @nonVirtual
  @JsonKey(
      name: 'report_hide',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? reportHide;

  /// Whether the field is mandatory
  @nonVirtual
  @JsonKey(
      name: 'reqd',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? required;

  @nonVirtual
  @JsonKey(name: 'search_fields')
  List? searchFields;

  @nonVirtual
  @JsonKey(
      name: 'search_index',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? searchIndex;

  @nonVirtual
  @JsonKey(
      name: 'set_only_once',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? setOnlyOnce;

  /// Whether the field is translatable
  @nonVirtual
  @JsonKey(
      name: 'translatable',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? translatable;

  @nonVirtual
  @JsonKey(name: 'trigger')
  String? trigger;

  @nonVirtual
  @JsonKey(
      name: 'unique',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? unique;

  @nonVirtual
  @JsonKey(name: 'width')
  String? width;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => DocField.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$DocFieldToJson(this);
}
