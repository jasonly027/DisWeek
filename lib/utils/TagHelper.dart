import 'package:flutter/material.dart';

import 'utils.dart';

Tag getGlobalTag(int id, List<Tag> globalTags) {
  return globalTags.firstWhere((tag) => tag.id == id);
}

class LocalTag {
  static List<int>? orderTags(
      {required Task task, required List<Tag> globalTags, bool? prune}) {
    task.tags?.sort((a, b) => globalTags
        .indexWhere((globalTag) => globalTag.id == a)
        .compareTo(globalTags.indexWhere((globalTag) => globalTag.id == b)));

    if (prune ?? false) {
      removeNonGlobalTags(task: task, globalTags: globalTags);
    } else {
      TaskDatabase.instance.updateTask(task);
    }
    return task.tags;
  }

  static void addTag({required Task task, required int tagID}) {
    task.tags ??= <int>[];
    task.tags!.add(tagID);
    TaskDatabase.instance.updateTask(task);
  }

  static void removeTag({required Task task, required int tagID}) {
    task.tags?.remove(tagID);
    if (task.tags?.isEmpty ?? false) task.tags = null;
    TaskDatabase.instance.updateTask(task);
  }

  static void removeNonGlobalTags(
      {required Task task, required List<Tag> globalTags}) {
    task.tags?.retainWhere((tagID) {
      for (Tag tag in globalTags) {
        if (tag.id == tagID) return true;
      }
      return false;
    });
    TaskDatabase.instance.updateTask(task);
  }
}

class GlobalTag {
  static void calculateGlobalOrder(List<Tag> globalTags) {
    for (int i = 0; i < globalTags.length; ++i) {
      globalTags[i].globalOrder = i;
      TaskDatabase.instance.updateGlobalTag(globalTags[i]);
    }
  }

  static void removeTag(
      {required Tag globalTag, required List<Tag> globalTags}) {
    globalTags.remove(globalTag);
    TaskDatabase.instance.deleteGlobalTag(globalTag.id!);
  }

  static void renameTag({required Tag globalTag, required String name}) {
    globalTag.name = name;
    TaskDatabase.instance.updateGlobalTag(globalTag);
  }

  static void recolorTag({required Tag globalTag, required Color color}) {
    globalTag.color = color;
    TaskDatabase.instance.updateGlobalTag(globalTag);
  }
}
