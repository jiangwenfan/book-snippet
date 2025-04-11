import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './logger_utils.dart';

/*
升级流程:
  1. version 字段+1
  2. onCreate方法，修改为最新sql
  3. onUpgrade方法，添加当前版本的case语句,进行升级
*/
class SqfliteClient {
  // 防止多次并发调用的 Future
  Database? _db;

  // 保存单例实例
  static SqfliteClient? _instance;
  // 私有命名构造函数,取消隐式加入默认构造函数,导致改类不能在外部被实例化
  SqfliteClient._internal();

  // 静态、异步、工厂方法，获取sqfliteClient为单例
  static Future<SqfliteClient> getInstance() async {
    if (_instance != null) return _instance!;

    // 创建并初始化实例
    final instance = SqfliteClient._internal();
    await instance._initdb();
    _instance = instance;
    return _instance!;
  }

  Future<void> _initdb() async {
    // 数据库存储 目录
    final dbPath = await getDatabasesPath();
    // 数据库存储 绝对路径
    final dbAbsolutePath = join(dbPath, "bs.db");
    logger.d("数据库绝对路径: $dbAbsolutePath");

    // 打开或创建数据库
    _db = await openDatabase(
      dbAbsolutePath,
      version: 1,
      onCreate: (db, version) async {
        logger.d("数据库 table 开始创建中...");
        // 初始化 category 表
        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY,
            name TEXT,
            count INTEGER,
          )
        ''');

        // 初始化 label 表
        await db.execute('''
          CREATE TABLE label (
            id INTEGER PRIMARY KEY,
            name TEXT,
          )
        ''');

        // 初始化 snippet 表
        // 当category被删除时，snippet中的记录为null
        await db.execute('''
          CREATE TABLE snippet (
            id INTEGER PRIMARY KEY,
            text TEXT,
            FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE SET NULL)
          )
        ''');

        // 初始化 snippet_label 表
        await db.execute('''
          CREATE TABLE snippet_label (
            snippet_id INTEGER,
            label_id INTEGER,
            PRIMARY KEY (snippet_id, label_id),

            FOREIGN KEY (snippet_id) REFERENCES snippet(id) ON DELETE CASCADE,
            FOREIGN KEY (label_id) REFERENCES label(id) ON DELETE CASCADE
          )
        ''');
        logger.i("数据库 table 创建成功");
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        // 循环依次升级每个版本
        for (
          int needUpVer = oldVersion + 1;
          needUpVer <= newVersion;
          needUpVer++
        ) {
          logger.d("数据库 table 升级中,当前: $oldVersion, 升级到: $needUpVer");
          switch (needUpVer) {
            case 2:
              // 升级到版本2
              // await db.execute('''
              //   ALTER TABLE snippet ADD COLUMN category_id INTEGER;
              // ''');
              logger.i("[1->2]数据库 table 升级到版本2成功");
              break;
            default:
              logger.e("未知错误: 数据库 table 升级失败 ");
              break;
          }
        }
      },
    );
  }

  // 封装

  // // 对外提供数据库对象
  Database get db => _db!;
}
