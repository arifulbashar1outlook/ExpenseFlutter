// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanTransaction _$LoanTransactionFromJson(Map<String, dynamic> json) =>
    LoanTransaction(
      id: json['id'] as String,
      loanId: json['loanId'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$LoanTransactionTypeEnumMap, json['type']),
      accountId: json['accountId'] as String,
    );

Map<String, dynamic> _$LoanTransactionToJson(LoanTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loanId': instance.loanId,
      'description': instance.description,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'type': _$LoanTransactionTypeEnumMap[instance.type]!,
      'accountId': instance.accountId,
    };

const _$LoanTransactionTypeEnumMap = {
  LoanTransactionType.lent: 'lent',
  LoanTransactionType.received: 'received',
};
