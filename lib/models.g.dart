// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 0;

  @override
  QuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModel(
      id: fields[0] as String,
      category: fields[1] as String,
      subCategory: fields[2] as String,
      subject: fields[3] as String,
      topic: fields[4] as String,
      questionText: fields[5] as String,
      options: (fields[6] as List).cast<String>(),
      correctOptionIndex: fields[7] as int,
      explanation: fields[8] as String,
      difficulty: fields[9] as String,
      year: fields[10] as int,
      source: fields[11] as String,
      repetitions: fields[12] as int,
      easeFactor: fields[13] as double,
      intervalDays: fields[14] as int,
      nextReviewDate: fields[15] as DateTime?,
      isWrongBookmarked: fields[16] as bool,
      isFavorite: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.subCategory)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.topic)
      ..writeByte(5)
      ..write(obj.questionText)
      ..writeByte(6)
      ..write(obj.options)
      ..writeByte(7)
      ..write(obj.correctOptionIndex)
      ..writeByte(8)
      ..write(obj.explanation)
      ..writeByte(9)
      ..write(obj.difficulty)
      ..writeByte(10)
      ..write(obj.year)
      ..writeByte(11)
      ..write(obj.source)
      ..writeByte(12)
      ..write(obj.repetitions)
      ..writeByte(13)
      ..write(obj.easeFactor)
      ..writeByte(14)
      ..write(obj.intervalDays)
      ..writeByte(15)
      ..write(obj.nextReviewDate)
      ..writeByte(16)
      ..write(obj.isWrongBookmarked)
      ..writeByte(17)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      targetExam: fields[2] as String,
      cityCode: fields[3] as int,
      cityName: fields[4] as String,
      schoolName: fields[5] as String?,
      xp: fields[6] as int,
      level: fields[7] as int,
      streak: fields[8] as int,
      lastActiveDate: fields[9] as DateTime?,
      totalSolvedCount: fields[10] as int,
      correctSolvedCount: fields[11] as int,
      badges: (fields[12] as List).cast<String>(),
      isSchoolAmbassador: fields[13] as bool,
      isCityCoordinator: fields[14] as bool,
      solvedQuestionIds: (fields[15] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.targetExam)
      ..writeByte(3)
      ..write(obj.cityCode)
      ..writeByte(4)
      ..write(obj.cityName)
      ..writeByte(5)
      ..write(obj.schoolName)
      ..writeByte(6)
      ..write(obj.xp)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.streak)
      ..writeByte(9)
      ..write(obj.lastActiveDate)
      ..writeByte(10)
      ..write(obj.totalSolvedCount)
      ..writeByte(11)
      ..write(obj.correctSolvedCount)
      ..writeByte(12)
      ..write(obj.badges)
      ..writeByte(13)
      ..write(obj.isSchoolAmbassador)
      ..writeByte(14)
      ..write(obj.isCityCoordinator)
      ..writeByte(15)
      ..write(obj.solvedQuestionIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AwardModelAdapter extends TypeAdapter<AwardModel> {
  @override
  final int typeId = 2;

  @override
  AwardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AwardModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      requiredXp: fields[4] as int,
      isUnlocked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AwardModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.requiredXp)
      ..writeByte(5)
      ..write(obj.isUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryModelAdapter extends TypeAdapter<StoryModel> {
  @override
  final int typeId = 3;

  @override
  StoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryModel(
      id: fields[0] as String,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      content: fields[3] as String,
      category: fields[4] as String,
      author: fields[5] as String,
      createdAt: fields[6] as DateTime,
      isRead: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StoryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
