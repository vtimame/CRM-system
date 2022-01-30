import 'package:flutter/material.dart';

final rawProfileData = {
  "newRoom": false,
  "hasRoomPlan": false,
  "source": "",
  "wifi": {
    "enabled": false,
    "comment": "",
    "scoutComment": "",
    "vendor": "undefined",
    "ownEquipments": false,
    "owrEquipments": false,
    "ssid": false,
    "hotSpotAuthorization": false,
    "zones": []
  },
  "internet": {
    "enabled": false,
    "comment": "",
    "rooms": [],
    "hasServer": false,
    "serverPosition": "inDataCenter",
    "hasAdditionalOffice": false,
    "additionalOffices": [],
    "localNetwork": false,
    "localNetworkHasBeenTested": false,
    "hasAdmin": false,
    "needOurAdmin": false,
    "scoutComment": ""
  },
  "localNetwork": {
    "enabled": false,
    "comment": "",
    "needLocalNetwork": false,
    "localNetworkHasBeenTested": false,
    "workplacesCount": 0,
    "scoutComment": ""
  },
  "pbx": {
    "enabled": false,
    "comment": "",
    "numbersCount": 0,
    "linesCount": 0,
    "ourPbx": false,
    "hasSignalman": false,
    "ourVirtualPbx": false,
    "ownVirtualPbx": false,
    "ownPbxEquipment": false,
    "pbxEquipmentCount": 0,
    "scoutComment": ""
  },
  "outsourcing": {
    "enabled": false,
    "comment": "",
    "hasAdmin": false,
    "needOurAdmin": false,
    "equipments": false,
    "serversCount": 0,
    "pcCount": 0,
    "printersCount": 0,
    "problems": false,
    "problemsComment": "",
    "scoutComment": ""
  },
  "cctv": {
    "enabled": false,
    "comment": "",
    "zones": [],
    "recording": "permanent",
    "storageDuration": "30",
    "scoutComment": ""
  }
};

final List<Map<String, String>> sourceOptions = [
  {"value": "site", "label": "Сайт"},
  {"value": "2gis", "label": "2гис"},
  {"value": "agent", "label": "Агент"},
  {"value": "landlord", "label": "Наш БЦ"},
  {"value": "manager", "label": "Менеджер"},
  {"value": "yandex", "label": "Яндекс"},
  {"value": "google", "label": "Google"},
  {"value": "social_networks", "label": "Соцсети"},
  {"value": "acquaintance", "label": "Совет знакомого"},
  {"value": "aggregator", "label": "Агрегатор"},
  {"value": "stand", "label": "Стойка"},
  {"value": "signboard", "label": "Вывеска"},
  {"value": "leaflet", "label": "Листовка"},
  {"value": "newsletter", "label": "Рассылка"},
  {"value": "car", "label": "Машина"},
  {"value": "devices", "label": "Оборудование"},
  {"value": "out_staff", "label": "Наш сотрудник"}
];
