class Credit {
  String? id;
  String? description;
  String? price;

  Credit({this.id, this.description, this.price});

  static List<Credit> getCredit() {
    return <Credit>[
      Credit(id: "1", description: "เติม 30 เครดิต", price: "15"),
      Credit(id: "2", description: "เติม 60+3 เครดิต", price: "30"),
      Credit(id: "3", description: "เติม 90+9 เครดิต", price: "45"),
      Credit(id: "4", description: "เติม 120+15 เครดิต", price: "60"),
    ];
  }
}
