// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loan _$LoanFromJson(Map<String, dynamic> json) => Loan(
  id: json['id'] as String,
  personName: json['personName'] as String,
  amount: (json['amount'] as num).toDouble(),
  lastActivityDate: DateTime.parse(json['lastActivityDate'] as String),
  type: $enumDecode(_$LoanTypeEnumMap, json['type']),
);

Map<String, dynamic> _$LoanToJson(Loan instance) => <String, dynamic>{
  'id': instance.id,
  'personName': instance.personName,
  'amount': instance.amount,
  'lastActivityDate': instance.lastActivityDate.toIso8601String(),
  'type': _$LoanTypeEnumMap[instance.type]!,
};

const _$LoanTypeEnumMap = {LoanType.due: 'due', LoanType.balance: 'balance'};
