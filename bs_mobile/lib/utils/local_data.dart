import './sqflite_utils.dart';
import './logger_utils.dart';
import 'package:sqflite/sqflite.dart';

// 从本地 sqlite 读取/写入数据
class LocalData {
  // 获取数据库实例
  static Future<Database> _getDatabase() async {
    final dbClient = await SqfliteClient.getInstance();
    return dbClient.db!;
  }

  // 清除所有数据
  // static Future<void> clearAll() async {
  //   final db = await _getDatabase();
  //   await db.execute("DELETE FROM category");
  //   await db.execute("DELETE FROM label");
  //   logger.d("清除所有数据成功");
  // }

  // 插入category数据
  static Future<void> insertCategory(Map<String, dynamic> data) async {
    final db = await _getDatabase();
    await db.insert("category", data);
    logger.d("插入分类数据成功: $data");
  }

  // 插入label数据
  static Future<void> insertLabel(Map<String, dynamic> data) async {
    final db = await _getDatabase();
    await db.insert("label", data);
    logger.d("插入标签数据成功: $data");
  }

  // 插入 snippet 数据
  static Future<void> insertSnippet(Map<String, dynamic> data) async {
    final db = await _getDatabase();
    await db.insert("snippet", data);
    logger.d("插入代码片段数据成功: $data");
  }
}
