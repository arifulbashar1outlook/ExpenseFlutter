// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loan _$LoanFromJson(Map<String, dynamic> json) => Loan(
  id: json['id'] as String,
  personName: json['personName'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$LoanTypeEnumMap, json['type']),
  date: DateTime.parse(json['date'] as String),
  isSettled: json['isSettled'] as bool? ?? false,
);

Map<String, dynamic> _$LoanToJson(Loan instance) => <String, dynamic>{
  'id': instance.id,
  'personName': instance.personName,
  'amount': instance.amount,
  'type': _$LoanTypeEnumMap[instance.type]!,
  'date': instance.date.toIso8601String(),
  'isSettled': instance.isSettled,
};

const _$LoanTypeEnumMap = {
  LoanType.lent: 'lent',
  LoanType.borrowed: 'borrowed',
};
