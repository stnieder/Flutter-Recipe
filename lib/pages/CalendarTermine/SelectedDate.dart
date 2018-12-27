class SelectedDate {
  DateTime selected;

  SelectedDate();

  void setSelected(DateTime date){
    this.selected = date;
  }

  DateTime getSelected(){
    if(this.selected == null) return DateTime.now();
    else return this.selected;
  }

}