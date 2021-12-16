// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'docfield.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocField _$DocFieldFromJson(Map<String, dynamic> json) => DocField()
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
  ..allowBulkEdit =
      FrappeDocFieldConverter.checkToBool(json['allow_bulk_edit'] as int?)
  ..allowInQuickEntry =
      FrappeDocFieldConverter.checkToBool(json['allow_in_quick_entry'] as int?)
  ..allowOnSubmit =
      FrappeDocFieldConverter.checkToBool(json['allow_on_submit'] as int?)
  ..bold = FrappeDocFieldConverter.checkToBool(json['bold'] as int?)
  ..inPreview = FrappeDocFieldConverter.checkToBool(json['in_preview'] as int?)
  ..collapsible =
      FrappeDocFieldConverter.checkToBool(json['collapsible'] as int?)
  ..collapsibleDependsOn = json['collapsible_depends_on'] as String?
  ..columns = json['columns'] as int?
  ..defaults = json['default'] as String?
  ..dependsOn = json['depends_on'] as String?
  ..description = json['description'] as String?
  ..fetchFrom = json['fetch_from'] as String?
  ..fetchIfEmpty =
      FrappeDocFieldConverter.checkToBool(json['fetch_if_empty'] as int?)
  ..fieldName = json['fieldname'] as String?
  ..fieldType = json['fieldtype'] as String?
  ..hidden = FrappeDocFieldConverter.checkToBool(json['hidden'] as int?)
  ..ignoreUserPermissions = FrappeDocFieldConverter.checkToBool(
      json['ignore_user_permissions'] as int?)
  ..ignoreXssFilter =
      FrappeDocFieldConverter.checkToBool(json['ignore_xss_filter'] as int?)
  ..inFilter = FrappeDocFieldConverter.checkToBool(json['in_filter'] as int?)
  ..inGlobalSearch =
      FrappeDocFieldConverter.checkToBool(json['in_global_search'] as int?)
  ..showPreviewPopup =
      FrappeDocFieldConverter.checkToBool(json['show_preview_popup'] as int?)
  ..inListView =
      FrappeDocFieldConverter.checkToBool(json['in_list_view'] as int?)
  ..inStandardFilter =
      FrappeDocFieldConverter.checkToBool(json['in_standard_filter'] as int?)
  ..isCustomField =
      FrappeDocFieldConverter.checkToBool(json['is_custom_field'] as int?)
  ..label = json['label'] as String?
  ..length = json['length'] as int?
  ..linkedDocumentType = json['linked_document_type'] as String?
  ..noCopy = FrappeDocFieldConverter.checkToBool(json['no_copy'] as int?)
  ..oldFieldName = json['oldfieldname'] as String?
  ..oldFieldType = json['oldfieldtype'] as String?
  ..options = json['options'] as String?
  ..permLevel = json['permlevel'] as int?
  ..precision = json['precision'] as String?
  ..printHide = FrappeDocFieldConverter.checkToBool(json['print_hide'] as int?)
  ..printHideIfNoValue = FrappeDocFieldConverter.checkToBool(
      json['print_hide_if_no_value'] as int?)
  ..printWidth = json['print_width'] as String?
  ..readOnly = FrappeDocFieldConverter.checkToBool(json['read_only'] as int?)
  ..rememberLastSelectedValue = FrappeDocFieldConverter.checkToBool(
      json['remember_last_selected_value'] as int?)
  ..reportHide =
      FrappeDocFieldConverter.checkToBool(json['report_hide'] as int?)
  ..required = FrappeDocFieldConverter.checkToBool(json['reqd'] as int?)
  ..searchFields = json['search_fields'] as List<dynamic>?
  ..searchIndex =
      FrappeDocFieldConverter.checkToBool(json['search_index'] as int?)
  ..setOnlyOnce =
      FrappeDocFieldConverter.checkToBool(json['set_only_once'] as int?)
  ..translatable =
      FrappeDocFieldConverter.checkToBool(json['translatable'] as int?)
  ..trigger = json['trigger'] as String?
  ..unique = FrappeDocFieldConverter.checkToBool(json['unique'] as int?)
  ..width = json['width'] as String?;

Map<String, dynamic> _$DocFieldToJson(DocField instance) {
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
  writeNotNull('allow_bulk_edit',
      FrappeDocFieldConverter.boolToCheck(instance.allowBulkEdit));
  writeNotNull('allow_in_quick_entry',
      FrappeDocFieldConverter.boolToCheck(instance.allowInQuickEntry));
  writeNotNull('allow_on_submit',
      FrappeDocFieldConverter.boolToCheck(instance.allowOnSubmit));
  writeNotNull('bold', FrappeDocFieldConverter.boolToCheck(instance.bold));
  writeNotNull(
      'in_preview', FrappeDocFieldConverter.boolToCheck(instance.inPreview));
  writeNotNull(
      'collapsible', FrappeDocFieldConverter.boolToCheck(instance.collapsible));
  writeNotNull('collapsible_depends_on', instance.collapsibleDependsOn);
  writeNotNull('columns', instance.columns);
  writeNotNull('default', instance.defaults);
  writeNotNull('depends_on', instance.dependsOn);
  writeNotNull('description', instance.description);
  writeNotNull('fetch_from', instance.fetchFrom);
  writeNotNull('fetch_if_empty',
      FrappeDocFieldConverter.boolToCheck(instance.fetchIfEmpty));
  writeNotNull('fieldname', instance.fieldName);
  writeNotNull('fieldtype', instance.fieldType);
  writeNotNull('hidden', FrappeDocFieldConverter.boolToCheck(instance.hidden));
  writeNotNull('ignore_user_permissions',
      FrappeDocFieldConverter.boolToCheck(instance.ignoreUserPermissions));
  writeNotNull('ignore_xss_filter',
      FrappeDocFieldConverter.boolToCheck(instance.ignoreXssFilter));
  writeNotNull(
      'in_filter', FrappeDocFieldConverter.boolToCheck(instance.inFilter));
  writeNotNull('in_global_search',
      FrappeDocFieldConverter.boolToCheck(instance.inGlobalSearch));
  writeNotNull('show_preview_popup',
      FrappeDocFieldConverter.boolToCheck(instance.showPreviewPopup));
  writeNotNull(
      'in_list_view', FrappeDocFieldConverter.boolToCheck(instance.inListView));
  writeNotNull('in_standard_filter',
      FrappeDocFieldConverter.boolToCheck(instance.inStandardFilter));
  writeNotNull('is_custom_field',
      FrappeDocFieldConverter.boolToCheck(instance.isCustomField));
  writeNotNull('label', instance.label);
  writeNotNull('length', instance.length);
  writeNotNull('linked_document_type', instance.linkedDocumentType);
  writeNotNull('no_copy', FrappeDocFieldConverter.boolToCheck(instance.noCopy));
  writeNotNull('oldfieldname', instance.oldFieldName);
  writeNotNull('oldfieldtype', instance.oldFieldType);
  writeNotNull('options', instance.options);
  writeNotNull('permlevel', instance.permLevel);
  writeNotNull('precision', instance.precision);
  writeNotNull(
      'print_hide', FrappeDocFieldConverter.boolToCheck(instance.printHide));
  writeNotNull('print_hide_if_no_value',
      FrappeDocFieldConverter.boolToCheck(instance.printHideIfNoValue));
  writeNotNull('print_width', instance.printWidth);
  writeNotNull(
      'read_only', FrappeDocFieldConverter.boolToCheck(instance.readOnly));
  writeNotNull('remember_last_selected_value',
      FrappeDocFieldConverter.boolToCheck(instance.rememberLastSelectedValue));
  writeNotNull(
      'report_hide', FrappeDocFieldConverter.boolToCheck(instance.reportHide));
  writeNotNull('reqd', FrappeDocFieldConverter.boolToCheck(instance.required));
  writeNotNull('search_fields', instance.searchFields);
  writeNotNull('search_index',
      FrappeDocFieldConverter.boolToCheck(instance.searchIndex));
  writeNotNull('set_only_once',
      FrappeDocFieldConverter.boolToCheck(instance.setOnlyOnce));
  writeNotNull('translatable',
      FrappeDocFieldConverter.boolToCheck(instance.translatable));
  writeNotNull('trigger', instance.trigger);
  writeNotNull('unique', FrappeDocFieldConverter.boolToCheck(instance.unique));
  writeNotNull('width', instance.width);
  return val;
}
