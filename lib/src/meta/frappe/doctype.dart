import 'package:json_annotation/json_annotation.dart';

import '../../model/frappe/document.dart';
import '../../model/frappe/utils.dart';
import '../../perm/frappe/interfaces.dart';
import 'docfield.dart';

part 'doctype.g.dart';

/// Class containing properties of a doctype. In addition, it contains helper functions for frappe docs.
@JsonSerializable()
class DocType extends FrappeDocument {
  DocType() : super('Doctype');

  factory DocType.fromJson(Map<String, dynamic>? json) =>
      _$DocTypeFromJson(json!);

  /// Hidden fields
  @JsonKey(name: '_fields')
  List<DocField>? disabledFields;

  /// The fields of the doctype
  @JsonKey(name: 'fields')
  List<DocField>? fields;

  /// The permissions of the doctype
  @JsonKey(name: 'permissions')
  List<DocPerm>? permissions;

  @JsonKey(
      name: 'allow_copy',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowCopy;

  @JsonKey(
      name: 'allow_events_in_timeline',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowEventsInTimeline;

  @JsonKey(
      name: 'allow_guest_to_view',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowGuestToView;

  @JsonKey(
      name: 'allow_import',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowImport;

  @JsonKey(
      name: 'allow_rename',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowRename;

  @JsonKey(name: 'app')
  String? app;

  @JsonKey(name: 'autoname')
  String? autoName;

  @JsonKey(
      name: 'beta',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? beta;

  @JsonKey(name: 'color')
  String? color;

  @JsonKey(name: 'colour')
  String? colour;

  @JsonKey(
      name: 'custom',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? custom;

  @JsonKey(name: 'default_print_format')
  String? defaultPrintFormat;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'document_type')
  String? documentType;

  @JsonKey(
      name: 'editable_grid',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? editableGrid;

  @JsonKey(name: 'engine')
  String? engine;

  @JsonKey(
      name: 'has_web_view',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? hasWebView;

  @JsonKey(
      name: 'hide_toolbar',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? hideToolbar;

  @JsonKey(name: 'icon')
  String? icon;

  /// The name of the field to refer for the image
  @JsonKey(name: 'image_field')
  String? imageField;

  @JsonKey(
      name: 'in_create',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inCreate;

  @JsonKey(
      name: 'is_published_field',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isPublishedField;

  /// Whether the doctype is submittable. A submittable document can't be deleted once submitted, but rather cancelled
  @JsonKey(
      name: 'is_submittable',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isSubmittable;

  /// Whether the document is a single type meaning there will only be one document of a doctype
  @JsonKey(
      name: 'issingle',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isSingle;

  @JsonKey(
      name: 'is_tree',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isTree;

  /// Whether the document is a table that can be set as a child of another table

  @JsonKey(
      name: 'istable',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isTable;

  @JsonKey(name: 'max_attachments')
  int? maxAttachments;

  @JsonKey(name: 'menu_index')
  int? menuIndex;

  @JsonKey(name: 'module')
  String? module;

  @JsonKey(name: 'name_case')
  String? nameCase;

  @JsonKey(name: 'parent_node')
  String? parentNode;

  @JsonKey(name: 'print_outline')
  String? printOutline;

  @JsonKey(
      name: 'quick_entry',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? quickEntry;

  @JsonKey(
      name: 'read_only',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? readOnly;

  @JsonKey(name: 'restrict_to_domain')
  String? restrictToDomain;

  @JsonKey(name: 'route')
  String? route;

  @JsonKey(name: 'search_fields')
  String? searchFields;

  @JsonKey(
      name: 'show_name_in_global_search',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? showNameInGlobalSearch;

  @JsonKey(name: 'smallicon')
  String? smallIcon;

  @JsonKey(name: 'sort_field')
  String? sortField;

  @JsonKey(name: 'sort_order')
  String? sortOrder;

  @JsonKey(name: 'subject')
  String? subject;

  @JsonKey(name: 'tag_fields')
  String? tagFields;

  @JsonKey(name: 'timeline_field')
  String? timelineField;

  /// The field to refer to as the Title
  @JsonKey(name: 'title_field')
  String? titleField;

  @JsonKey(
      name: 'track_changes',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? trackChanges;

  @JsonKey(
      name: 'track_seen',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? trackSeen;

  @JsonKey(
      name: 'track_views',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? trackViews;

  /// Whether the document should be presented in a tree view
  @JsonKey(
      name: 'treeview',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? treeView;

  @JsonKey(name: '__assets_loaded')
  bool? assetsLoaded;

  @JsonKey(name: '__calendar_js')
  String? calendarJs;

  @JsonKey(name: '__css')
  String? css;

  @JsonKey(name: '__custom_js')
  String? customJs;

  @JsonKey(name: '__dashboard')
  dynamic dashboard;

  @JsonKey(name: '__form_grid_templates')
  Map<String, dynamic>? formGridTemplates;

  @JsonKey(name: '__js')
  String? js;

  @JsonKey(name: '__kanban_column_fields')
  List<dynamic>? kanbanColumnFields;

  @JsonKey(name: '__linked_with')
  String? linkedWith;

  @JsonKey(name: '__list_js')
  String? listJs;

  @JsonKey(name: '__listview_template')
  String? listViewTemplate;

  @JsonKey(name: '__map_js')
  String? mapJs;

  @JsonKey(name: '__messages')
  Map<String, dynamic>? messages;

  @JsonKey(name: '__print_formats')
  List? printFormats;

  @JsonKey(name: '__templates')
  Map<String, dynamic>? templates;

  @JsonKey(name: '__tree_js')
  String? treeJs;

  @JsonKey(name: '__workflow_docs')
  List<dynamic>? workflowDocs;

  @JsonKey(name: '_assign')
  dynamic assign;

  @JsonKey(name: '_comments')
  dynamic comments;

  @JsonKey(name: '_last_update')
  String? lastUpdate;

  @JsonKey(name: '_liked_by')
  dynamic likedBy;

  @JsonKey(name: '_user_tags')
  String? userTags;

  @JsonKey(
      name: 'show_preview_popup',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? showPreviewPopup;

  @JsonKey(
      name: 'allow_auto_repeat',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowAutoRepeat;

  @JsonKey(ignore: true)
  bool isLoading = false;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => DocType.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$DocTypeToJson(this);
}

@JsonSerializable()
class RenovationScripts {
  RenovationScripts(this.code, this.name);

  String? code;
  String? name;

  RenovationScripts fromJson(Map<String, dynamic> json) {
    return _$RenovationScriptsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RenovationScriptsToJson(this);
  }
}
