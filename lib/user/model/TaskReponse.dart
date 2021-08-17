class TaskReponse {
  int TaskId;
  String Name;
  String Description;
  String DateStart;
  String DateFin;
  String Metadata1;
  String Metadata2;
  String Metadata3;
  String DateCreate;
  int UserId;

  TaskReponse({
    this.TaskId,
    this.Name,
    this.Description,
    this.DateStart,
    this.DateFin,
    this.Metadata1,
    this.Metadata2,
    this.Metadata3,
    this.DateCreate,
    this.UserId,
  });

  factory TaskReponse.fromJson(Map<String, dynamic> json) {
    return TaskReponse(
        TaskId: json["TaskId"],
        Name: json["Name"],
        Description: json["Description"],
        DateStart: json["DateStart"],
        DateFin: json["DateFin"],
        Metadata1: json["Metadata1"],
        Metadata2: json["Metadata2"],
        Metadata3: json["Metadata3"],
        DateCreate: json["DateCreate"],
        UserId: json["UserId"]);
  }
}
