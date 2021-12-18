// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctype.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocType _$DocTypeFromJson(Map<String, dynamic> json) => DocType()
  ..doctype = json['doctype'] as String?
  ..name = json['name'] as String?
  ..owner = json['owner'] as String?
  ..docStatus =
      FrappeDocFieldConverter.intToFrappeDocStatus(json['docstatus'] as int?)
  ..isLocal = FrappeDocFieldConverter.checkToBool(json['__islocal'] as int?)
  ..unsaved = FrappeDocFieldConverter.checkToBool(json['__unsaved'] as int?)
  ..amendedFrom = json['amended_from'] as String?
  ..idx = FrappeDocFieldConverter.idxFromString(json['idx'])
  ..parent = json['parent'] as String?
  ..parentType = json['parenttype'] as String?
  ..creation = json['creation'] == null
      ? null
      : DateTime.parse(json['creation'] as String)
  ..parentField = json['parentfield'] as String?
  ..modified = json['modified'] == null
      ? null
      : DateTime.parse(json['modified'] as String)
  ..modifiedBy = json['modified_by'] as String?
  ..disabledFields = (json['_fields'] as List<dynamic>?)
      ?.map((e) => DocField.fromJson(e as Map<String, dynamic>?))
      .toList()
  ..fields = (json['fields'] as List<dynamic>?)
      ?.map((e) => DocField.fromJson(e as Map<String, dynamic>?))
      .toList()
  ..permissions = (json['permissions'] as List<dynamic>?)
      ?.map((e) => DocPerm.fromJson(e as Map<String, dynamic>?))
      .toList()
  ..allowCopy = FrappeDocFieldConverter.checkToBool(json['allow_copy'] as int?)
  ..allowEventsInTimeline = FrappeDocFieldConverter.checkToBool(
      json['allow_events_in_timeline'] as int?)
  ..allowGuestToView =
      FrappeDocFieldConverter.checkToBool(json['allow_guest_to_view'] as int?)
  ..allowImport =
      FrappeDocFieldConverter.checkToBool(json['allow_import'] as int?)
  ..allowRename =
      FrappeDocFieldConverter.checkToBool(json['allow_rename'] as int?)
  ..app = json['app'] as String?
  ..autoName = json['autoname'] as String?
  ..beta = FrappeDocFieldConverter.checkToBool(json['beta'] as int?)
  ..color = json['color'] as String?
  ..colour = json['colour'] as String?
  ..custom = FrappeDocFieldConverter.checkToBool(json['custom'] as int?)
  ..defaultPrintFormat = json['default_print_format'] as String?
  ..description = json['description'] as String?
  ..documentType = json['document_type'] as String?
  ..editableGrid =
      FrappeDocFieldConverter.checkToBool(json['editable_grid'] as int?)
  ..engine = json['engine'] as String?
  ..hasWebView =
      FrappeDocFieldConverter.checkToBool(json['has_web_view'] as int?)
  ..hideToolbar =
      FrappeDocFieldConverter.checkToBool(json['hide_toolbar'] as int?)
  ..icon = json['icon'] as String?
  ..imageField = json['image_field'] as String?
  ..inCreate = FrappeDocFieldConverter.checkToBool(json['in_create'] as int?)
  ..isPublishedField =
      FrappeDocFieldConverter.checkToBool(json['is_published_field'] as int?)
  ..isSubmittable =
      FrappeDocFieldConverter.checkToBool(json['is_submittable'] as int?)
  ..isSingle = FrappeDocFieldConverter.checkToBool(json['issingle'] as int?)
  ..isTree = FrappeDocFieldConverter.checkToBool(json['is_tree'] as int?)
  ..isTable = FrappeDocFieldConverter.checkToBool(json['istable'] as int?)
  ..maxAttachments = json['max_attachments'] as int?
  ..menuIndex = json['menu_index'] as int?
  ..module = json['module'] as String?
  ..nameCase = json['name_case'] as String?
  ..parentNode = json['parent_node'] as String?
  ..printOutline = json['print_outline'] as String?
  ..quickEntry =
      FrappeDocFieldConverter.checkToBool(json['quick_entry'] as int?)
  ..readOnly = FrappeDocFieldConverter.checkToBool(json['read_only'] as int?)
  ..restrictToDomain = json['restrict_to_domain'] as String?
  ..route = json['route'] as String?
  ..searchFields = json['search_fields'] as String?
  ..showNameInGlobalSearch = FrappeDocFieldConverter.checkToBool(
      json['show_name_in_global_search'] as int?)
  ..smallIcon = json['smallicon'] as String?
  ..sortField = json['sort_field'] as String?
  ..sortOrder = json['sort_order'] as String?
  ..subject = json['subject'] as String?
  ..tagFields = json['tag_fields'] as String?
  ..timelineField = json['timeline_field'] as String?
  ..titleField = json['title_field'] as String?
  ..trackChanges =
      FrappeDocFieldConverter.checkToBool(json['track_changes'] as int?)
  ..trackSeen = FrappeDocFieldConverter.checkToBool(json['track_seen'] as int?)
  ..trackViews =
      FrappeDocFieldConverter.checkToBool(json['track_views'] as int?)
  ..treeView = FrappeDocFieldConverter.checkToBool(json['treeview'] as int?)
  ..assetsLoaded = json['__assets_loaded'] as bool?
  ..calendarJs = json['__calendar_js'] as String?
  ..css = json['__css'] as String?
  ..customJs = json['__custom_js'] as String?
  ..dashboard = json['__dashboard']
  ..formGridTemplates = json['__form_grid_templates'] as Map<String, dynamic>?
  ..js = json['__js'] as String?
  ..kanbanColumnFields = json['__kanban_column_fields'] as List<dynamic>?
  ..linkedWith = json['__linked_with'] as String?
  ..listJs = json['__list_js'] as String?
  ..listViewTemplate = json['__listview_template'] as String?
  ..mapJs = json['__map_js'] as String?
  ..messages = json['__messages'] as Map<String, dynamic>?
  ..printFormats = json['__print_formats'] as List<dynamic>?
  ..templates = json['__templates'] as Map<String, dynamic>?
  ..treeJs = json['__tree_js'] as String?
  ..workflowDocs = json['__workflow_docs'] as List<dynamic>?
  ..assign = json['_assign']
  ..comments = json['_comments']
  ..lastUpdate = json['_last_update'] as String?
  ..likedBy = json['_liked_by']
  ..userTags = json['_user_tags'] as String?
  ..showPreviewPopup =
      FrappeDocFieldConverter.checkToBool(json['show_preview_popup'] as int?)
  ..allowAutoRepeat =
      FrappeDocFieldConverter.checkToBool(json['allow_auto_repeat'] as int?);

Map<String, dynamic> _$DocTypeToJson(DocType instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('doctype', instance.doctype);
  writeNotNull('name', instance.name);
  writeNotNull('owner', instance.owner);
  writeNotNull('docstatus',
      FrappeDocFieldConverter.frappeDocStatusToInt(instance.docStatus));
  writeNotNull(
      '__islocal', FrappeDocFieldConverter.boolToCheck(instance.isLocal));
  writeNotNull(
      '__unsaved', FrappeDocFieldConverter.boolToCheck(instance.unsaved));
  writeNotNull('amended_from', instance.amendedFrom);
  writeNotNull('idx', instance.idx);
  writeNotNull('parent', instance.parent);
  writeNotNull('parenttype', instance.parentType);
  writeNotNull(
      'creation', FrappeDocFieldConverter.toFrappeDateTime(instance.creation));
  writeNotNull('parentfield', instance.parentField);
  writeNotNull(
      'modified', FrappeDocFieldConverter.toFrappeDateTime(instance.modified));
  writeNotNull('modified_by', instance.modifiedBy);
  writeNotNull(
      '_fields', instance.disabledFields?.map((e) => e.toJson()).toList());
  writeNotNull('fields', instance.fields?.map((e) => e.toJson()).toList());
  writeNotNull(
      'permissions', instance.permissions?.map((e) => e.toJson()).toList());
  writeNotNull(
      'allow_copy', FrappeDocFieldConverter.boolToCheck(instance.allowCopy));
  writeNotNull('allow_events_in_timeline',
      FrappeDocFieldConverter.boolToCheck(instance.allowEventsInTimeline));
  writeNotNull('allow_guest_to_view',
      FrappeDocFieldConverter.boolToCheck(instance.allowGuestToView));
  writeNotNull('allow_import',
      FrappeDocFieldConverter.boolToCheck(instance.allowImport));
  writeNotNull('allow_rename',
      FrappeDocFieldConverter.boolToCheck(instance.allowRename));
  writeNotNull('app', instance.app);
  writeNotNull('autoname', instance.autoName);
  writeNotNull('beta', FrappeDocFieldConverter.boolToCheck(instance.beta));
  writeNotNull('color', instance.color);
  writeNotNull('colour', instance.colour);
  writeNotNull('custom', FrappeDocFieldConverter.boolToCheck(instance.custom));
  writeNotNull('default_print_format', instance.defaultPrintFormat);
  writeNotNull('description', instance.description);
  writeNotNull('document_type', instance.documentType);
  writeNotNull('editable_grid',
      FrappeDocFieldConverter.boolToCheck(instance.editableGrid));
  writeNotNull('engine', instance.engine);
  writeNotNull(
      'has_web_view', FrappeDocFieldConverter.boolToCheck(instance.hasWebView));
  writeNotNull('hide_toolbar',
      FrappeDocFieldConverter.boolToCheck(instance.hideToolbar));
  writeNotNull('icon', instance.icon);
  writeNotNull('image_field', instance.imageField);
  writeNotNull(
      'in_create', FrappeDocFieldConverter.boolToCheck(instance.inCreate));
  writeNotNull('is_published_field',
      FrappeDocFieldConverter.boolToCheck(instance.isPublishedField));
  writeNotNull('is_submittable',
      FrappeDocFieldConverter.boolToCheck(instance.isSubmittable));
  writeNotNull(
      'issingle', FrappeDocFieldConverter.boolToCheck(instance.isSingle));
  writeNotNull('is_tree', FrappeDocFieldConverter.boolToCheck(instance.isTree));
  writeNotNull(
      'istable', FrappeDocFieldConverter.boolToCheck(instance.isTable));
  writeNotNull('max_attachments', instance.maxAttachments);
  writeNotNull('menu_index', instance.menuIndex);
  writeNotNull('module', instance.module);
  writeNotNull('name_case', instance.nameCase);
  writeNotNull('parent_node', instance.parentNode);
  writeNotNull('print_outline', instance.printOutline);
  writeNotNull(
      'quick_entry', FrappeDocFieldConverter.boolToCheck(instance.quickEntry));
  writeNotNull(
      'read_only', FrappeDocFieldConverter.boolToCheck(instance.readOnly));
  writeNotNull('restrict_to_domain', instance.restrictToDomain);
  writeNotNull('route', instance.route);
  writeNotNull('search_fields', instance.searchFields);
  writeNotNull('show_name_in_global_search',
      FrappeDocFieldConverter.boolToCheck(instance.showNameInGlobalSearch));
  writeNotNull('smallicon', instance.smallIcon);
  writeNotNull('sort_field', instance.sortField);
  writeNotNull('sort_order', instance.sortOrder);
  writeNotNull('subject', instance.subject);
  writeNotNull('tag_fields', instance.tagFields);
  writeNotNull('timeline_field', instance.timelineField);
  writeNotNull('title_field', instance.titleField);
  writeNotNull('track_changes',
      FrappeDocFieldConverter.boolToCheck(instance.trackChanges));
  writeNotNull(
      'track_seen', FrappeDocFieldConverter.boolToCheck(instance.trackSeen));
  writeNotNull(
      'track_views', FrappeDocFieldConverter.boolToCheck(instance.trackViews));
  writeNotNull(
      'treeview', FrappeDocFieldConverter.boolToCheck(instance.treeView));
  writeNotNull('__assets_loaded', instance.assetsLoaded);
  writeNotNull('__calendar_js', instance.calendarJs);
  writeNotNull('__css', instance.css);
  writeNotNull('__custom_js', instance.customJs);
  writeNotNull('__dashboard', instance.dashboard);
  writeNotNull('__form_grid_templates', instance.formGridTemplates);
  writeNotNull('__js', instance.js);
  writeNotNull('__kanban_column_fields', instance.kanbanColumnFields);
  writeNotNull('__linked_with', instance.linkedWith);
  writeNotNull('__list_js', instance.listJs);
  writeNotNull('__listview_template', instance.listViewTemplate);
  writeNotNull('__map_js', instance.mapJs);
  writeNotNull('__messages', instance.messages);
  writeNotNull('__print_formats', instance.printFormats);
  writeNotNull('__templates', instance.templates);
  writeNotNull('__tree_js', instance.treeJs);
  writeNotNull('__workflow_docs', instance.workflowDocs);
  writeNotNull('_assign', instance.assign);
  writeNotNull('_comments', instance.comments);
  writeNotNull('_last_update', instance.lastUpdate);
  writeNotNull('_liked_by', instance.likedBy);
  writeNotNull('_user_tags', instance.userTags);
  writeNotNull('show_preview_popup',
      FrappeDocFieldConverter.boolToCheck(instance.showPreviewPopup));
  writeNotNull('allow_auto_repeat',
      FrappeDocFieldConverter.boolToCheck(instance.allowAutoRepeat));
  return val;
}

RenovationScripts _$RenovationScriptsFromJson(Map<String, dynamic> json) =>
    RenovationScripts(
      json['code'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$RenovationScriptsToJson(RenovationScripts instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('name', instance.name);
  return val;
}
