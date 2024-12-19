enum FundNeededType {
  upTo2Billion(1),
  from2To5Billion(2),
  from5To10Billion(3),
  upTo10Billion(4);

  final int value;
  const FundNeededType(this.value);
}

extension FundNeededTypeExtension on FundNeededType {
  String get description {
    switch (this) {
      case FundNeededType.upTo2Billion:
        return 'تا ۲ میلیارد تومان';
      case FundNeededType.from2To5Billion:
        return '۲ تا ۵ میلیارد تومان';
      case FundNeededType.from5To10Billion:
        return '۵ تا ۱۰ میلیارد تومان';
      case FundNeededType.upTo10Billion:
        return 'بیش از ۱۰ میلیارد تومان';
      default:
        return '';
    }
  }

  static FundNeededType fromValue(int value) {
    return FundNeededType.values.firstWhere((e) => e.value == value);
  }
}

enum AnnualIncomeType {
  upTo2Billion(1),
  from2To5Billion(2),
  from5To10Billion(3),
  upTo10Billion(4);

  final int value;
  const AnnualIncomeType(this.value);
}

extension AnnualIncomeTypeExtension on AnnualIncomeType {
  String get description {
    switch (this) {
      case AnnualIncomeType.upTo2Billion:
        return 'تا ۵ میلیارد تومان';
      case AnnualIncomeType.from2To5Billion:
        return '۵ تا ۱۰ میلیارد تومان';
      case AnnualIncomeType.from5To10Billion:
        return '۱۰ تا ۲۰ میلیارد تومان';
      case AnnualIncomeType.upTo10Billion:
        return 'بیش از ۲۰ میلیارد تومان';
      default:
        return '';
    }
  }

  static AnnualIncomeType fromValue(int value) {
    return AnnualIncomeType.values.firstWhere((e) => e.value == value);
  }
}

enum ProfitType {
  upTo2Billion(1),
  from2To5Billion(2);

  final int value;
  const ProfitType(this.value);
}

extension ProfitTypeExtension on ProfitType {
  String get description {
    switch (this) {
      case ProfitType.upTo2Billion:
        return 'زیان‌ده بوده است';
      case ProfitType.from2To5Billion:
        return 'سود‌ده بوده است';
      default:
        return '';
    }
  }

  static ProfitType fromValue(int value) {
    return ProfitType.values.firstWhere((e) => e.value == value);
  }
}

enum BouncedCheckType {
  upTo2Billion(1),
  from2To5Billion(2),
  from5To10Billion(3);

  final int value;
  const BouncedCheckType(this.value);
}

extension BouncedCheckTypeExtension on BouncedCheckType {
  String get description {
    switch (this) {
      case BouncedCheckType.upTo2Billion:
        return 'چک برگشتی داریم و هنوز رفع سوء اثر نشده';
      case BouncedCheckType.from2To5Billion:
        return 'چک برگشتی نداریم';
      case BouncedCheckType.from5To10Billion:
        return 'چک برگشتی داشتیم اما رفع سوء اثر شده';
      default:
        return '';
    }
  }

  static BouncedCheckType fromValue(int value) {
    return BouncedCheckType.values.firstWhere((e) => e.value == value);
  }
}

class Company {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final String uuid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String agentName;
  final String field;
  final String phoneNumber;
  final FundNeededType fundNeeded;
  final AnnualIncomeType annualIncome;
  final ProfitType profit;
  final BouncedCheckType bouncedCheck;

  Company({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.agentName,
    required this.field,
    required this.phoneNumber,
    required this.fundNeeded,
    required this.annualIncome,
    required this.profit,
    required this.bouncedCheck,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      agentName: json['agent_name'],
      field: json['field'],
      phoneNumber: json['phone_number'],
      fundNeeded: FundNeededTypeExtension.fromValue(json['fund_needed']),
      annualIncome: AnnualIncomeTypeExtension.fromValue(json['anual_income']),
      profit: ProfitTypeExtension.fromValue(json['profit']),
      bouncedCheck: BouncedCheckTypeExtension.fromValue(json['bounced_check']),
    );
  }
}
