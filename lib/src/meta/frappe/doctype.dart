import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

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
  @nonVirtual
  @JsonKey(name: '_fields')
  List<DocField>? disabledFields;

  /// The fields of the doctype
  @nonVirtual
  @JsonKey(name: 'fields')
  List<DocField>? fields;

  /// The permissions of the doctype
  @nonVirtual
  @JsonKey(name: 'permissions')
  List<DocPerm>? permissions;

  @nonVirtual
  @JsonKey(
      name: 'allow_copy',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowCopy;

  @nonVirtual
  @JsonKey(
      name: 'allow_events_in_timeline',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowEventsInTimeline;

  @nonVirtual
  @JsonKey(
      name: 'allow_guest_to_view',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowGuestToView;

  @nonVirtual
  @JsonKey(
      name: 'allow_import',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowImport;

  @nonVirtual
  @JsonKey(
      name: 'allow_rename',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowRename;

  @nonVirtual
  @JsonKey(name: 'app')
  String? app;

  @nonVirtual
  @JsonKey(name: 'autoname')
  String? autoName;

  @nonVirtual
  @JsonKey(
      name: 'beta',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? beta;

  @nonVirtual
  @JsonKey(name: 'color')
  String? color;

  @nonVirtual
  @JsonKey(name: 'colour')
  String? colour;

  @nonVirtual
  @JsonKey(
      name: 'custom',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? custom;

  @nonVirtual
  @JsonKey(name: 'default_print_format')
  String? defaultPrintFormat;

  @nonVirtual
  @JsonKey(name: 'description')
  String? description;

  @nonVirtual
  @JsonKey(name: 'document_type')
  String? documentType;

  @nonVirtual
  @JsonKey(
      name: 'editable_grid',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? editableGrid;

  @nonVirtual
  @JsonKey(name: 'engine')
  String? engine;

  @nonVirtual
  @JsonKey(
      name: 'has_web_view',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? hasWebView;

  @nonVirtual
  @JsonKey(
      name: 'hide_toolbar',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? hideToolbar;

  @nonVirtual
  @JsonKey(name: 'icon')
  String? icon;

  /// The name of the field to refer for the image
  @nonVirtual
  @JsonKey(name: 'image_field')
  String? imageField;

  @nonVirtual
  @JsonKey(
      name: 'in_create',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? inCreate;

  @nonVirtual
  @JsonKey(
      name: 'is_published_field',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isPublishedField;

  /// Whether the doctype is submittable. A submittable document can't be deleted once submitted, but rather cancelled
  @nonVirtual
  @JsonKey(
      name: 'is_submittable',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isSubmittable;

  /// Whether the document is a single type meaning there will only be one document of a doctype
  @nonVirtual
  @JsonKey(
      name: 'issingle',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isSingle;

  @nonVirtual
  @JsonKey(
      name: 'is_tree',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isTree;

  /// Whether the document is a table that can be set as a child of another table

  @nonVirtual
  @JsonKey(
      name: 'istable',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isTable;

  @nonVirtual
  @JsonKey(name: 'max_attachments')
  int? maxAttachments;

  @nonVirtual
  @JsonKey(name: 'menu_index')
  int? menuIndex;

  @nonVirtual
  @JsonKey(name: 'module')
  String? module;

  @nonVirtual
  @JsonKey(name: 'name_case')
  String? nameCase;

  @nonVirtual
  @JsonKey(name: 'parent_node')
  String? parentNode;

  @nonVirtual
  @JsonKey(name: 'print_outline')
  String? printOutline;

  @nonVirtual
  @JsonKey(
      name: 'quick_entry',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? quickEntry;

  @nonVirtual
  @JsonKey(
      name: 'read_only',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? readOnly;

  @nonVirtual
  @JsonKey(name: 'restrict_to_domain')
  String? restrictToDomain;

  @nonVirtual
  @JsonKey(name: 'route')
  String? route;

  @nonVirtual
  @JsonKey(name: 'search_fields')
  String? searchFields;

  @nonVirtual
  @JsonKey(
      name: 'show_name_in_global_search',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? showNameInGlobalSearch;

  @nonVirtual
  @JsonKey(name: 'smallicon')
  String? smallIcon;

  @nonVirtual
  @JsonKey(name: 'sort_field')
  String? sortField;

  @nonVirtual
  @JsonKey(name: 'sort_order')
  String? sortOrder;

  @nonVirtual
  @JsonKey(name: 'subject')
  String? subject;

  @nonVirtual
  @JsonKey(name: 'tag_fields')
  String? tagFields;

  @nonVirtual
  @JsonKey(name: 'timeline_field')
  String? timelineField;

  /// The field to refer to as the Title
  @nonVirtual
  @JsonKey(name: 'title_field')
  String? titleField;

  @nonVirtual
  @JsonKey(
      name: 'track_changes',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? trackChanges;

  @nonVirtual
  @JsonKey(
      name: 'track_seen',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? trackSeen;

  @nonVirtual
  @JsonKey(
      name: 'track_views',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? trackViews;

  /// Whether the document should be presented in a tree view
  @nonVirtual
  @JsonKey(
      name: 'treeview',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? treeView;

  @nonVirtual
  @JsonKey(name: '__assets_loaded')
  bool? assetsLoaded;

  @nonVirtual
  @JsonKey(name: '__calendar_js')
  String? calendarJs;

  @nonVirtual
  @JsonKey(name: '__css')
  String? css;

  @nonVirtual
  @JsonKey(name: '__custom_js')
  String? customJs;

  @nonVirtual
  @JsonKey(name: '__dashboard')
  dynamic dashboard;

  @nonVirtual
  @JsonKey(name: '__form_grid_templates')
  Map<String, dynamic>? formGridTemplates;

  @nonVirtual
  @JsonKey(name: '__js')
  String? js;

  @nonVirtual
  @JsonKey(name: '__kanban_column_fields')
  List<dynamic>? kanbanColumnFields;

  @nonVirtual
  @JsonKey(name: '__linked_with')
  String? linkedWith;

  @nonVirtual
  @JsonKey(name: '__list_js')
  String? listJs;

  @nonVirtual
  @JsonKey(name: '__listview_template')
  String? listViewTemplate;

  @nonVirtual
  @JsonKey(name: '__map_js')
  String? mapJs;

  @nonVirtual
  @JsonKey(name: '__messages')
  Map<String, dynamic>? messages;

  @nonVirtual
  @JsonKey(name: '__print_formats')
  List? printFormats;

  @nonVirtual
  @JsonKey(name: '__templates')
  Map<String, dynamic>? templates;

  @nonVirtual
  @JsonKey(name: '__tree_js')
  String? treeJs;

  @nonVirtual
  @JsonKey(name: '__workflow_docs')
  List<dynamic>? workflowDocs;

  @nonVirtual
  @JsonKey(name: '_assign')
  dynamic assign;

  @nonVirtual
  @JsonKey(name: '_comments')
  dynamic comments;

  @nonVirtual
  @JsonKey(name: '_last_update')
  String? lastUpdate;

  @nonVirtual
  @JsonKey(name: '_liked_by')
  dynamic likedBy;

  @nonVirtual
  @JsonKey(name: '_user_tags')
  String? userTags;

  @nonVirtual
  @JsonKey(
      name: 'show_preview_popup',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? showPreviewPopup;

  @nonVirtual
  @JsonKey(
      name: 'allow_auto_repeat',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? allowAutoRepeat;

  @nonVirtual
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
