import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class AddContactBloc {
  final contactIsValid = BehaviorSubject<bool>.seeded(false);
  final contact = BehaviorSubject<Map>.seeded(null);
  final phones = BehaviorSubject<List>.seeded(null);

  Stream get contactIsValidStream => contactIsValid.stream;
  Stream get contactStream => contact.stream;
  Stream get phonesStream => phones.stream;

  Sink get contactIsValidSink => contactIsValid.sink;
  Sink get contactSink => contact.sink;
  Sink get phonesSink => phones.sink;

  void updateContactField(String key, String value) {
    var _contact = contact.value;
    _contact[key] = value;
    contactSink.add(_contact);
    validate();
  }

  void updatePhoneField(int index, String key, String value) {
    var _phones = phones.value;
    _phones[index][key] = value;
    phonesSink.add(_phones);
    validate();
  }

  void removePhone(int index) {
    var _phones = phones.value;
    _phones.removeAt(index);
    phonesSink.add(_phones);
    validate();
  }

  void addPhone() {
    var _phones = phones.value;
    _phones.add({"phone": "", "additional": ""});
    phonesSink.add(_phones);
    validate();
  }

  Future store() async {
    var _contact = contact.value;
    var _phones = phones.value;

    var responseData = {
      "surname": _contact['surname'],
      "name": _contact['name'],
      "patronymic": _contact['patronymic'],
      "phones": _phones,
      "position": _contact['position'],
      "email": _contact['email'],
    };

    sl<OpenedCardBloc>().storeContact(responseData);
  }

  void validate() {
    bool phonesIsValid = true;

    phones.value.forEach((el) {
      if (el['phone'].length == 0) {
        phonesIsValid = false;
      }
    });

    contactIsValidSink.add(contact.value['name'].length > 0 && phonesIsValid);
  }

  void dispose() {
    contactIsValid.close();
    contact.close();
    phones.close();
  }
}
