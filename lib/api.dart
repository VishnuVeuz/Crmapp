import 'dart:convert';

import 'package:crm_project/model/multicompany.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'model/calendarmodel.dart';
 //String baseUrl = "http://10.10.10.123:8030/";
//server
  String baseUrl = "http://165.22.30.188:8040/";

//live server bibpin
//String baseUrl = "http://207.154.229.85:8069/";

login(String email, password, dbId) async {
  String? authresponce,
      personName,
      personMobile,
      personJwt,
      personMail,
      resMessage,
      resMessageText;
  List multiCompany;

  try {
    final msg = jsonEncode({
      "params": {"db": dbId, "login": email, "password": password}
    });
    Response response = await post(
      Uri.parse('${baseUrl}api/generate_token'),
      headers: {
        "Content-Type": "application/json",
      },
      body: msg,
    );

    var data = jsonDecode(response.body.toString());

    authresponce = data['result'].toString();

    resMessage = data['result']['message'].toString();

    if (resMessage == "success") {
      resMessageText = "success";
      personName = data['result']['data']['user_name']['name'].toString();
      personMobile = data['result']['data']['user_name']['mobile'].toString();
      personMail = data['result']['data']['user_name']['email'].toString();
      personJwt = data['result']['data']['Token'].toString();

      multiCompany = data['result']['data']['companies'];

      final jsonListmultiCompany = json.encode(multiCompany);
      print(jsonListmultiCompany);
      print(multiCompany);
      print("dhdhdhdhdhdh");
      addUserStringToSF(personName, personMobile, personMail, personJwt,
          jsonListmultiCompany);
    }

    if (resMessage == "error") {
      resMessageText = data['result']['data'].toString();
    }
  } catch (e) {
    print(e.toString());
  }

  return resMessageText;
}

defaultDropdown(String model) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  try {
    final msg = jsonEncode({
      "params": {"model": "lead.lead"}
    });

    Response response = await get(
      Uri.parse("${baseUrl}api/default_values?model=${model}"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("failed to get data from internet");
    } else {
      print(response.body);
      print("responce dataa");
      data = jsonDecode(response.body);

      authresponce = data.toString();
    }
  } catch (e) {
    print(e.toString());
  }

  return data;
}

defaultDropdownCustomer() async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  try {
    final msg = jsonEncode({
      "params": {"model": "lead.lead"}
    });

    Response response = await get(
      Uri.parse("${baseUrl}api/default_values?"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("failed to get data from internet");
    } else {
      print(response.body);
      print("responce dataa");
      data = jsonDecode(response.body);

      authresponce = data.toString();
    }
  } catch (e) {
    print(e.toString());
  }

  return data;
}

getLeadData(int leadId, String value) async {
  String token = await getUserJwt();

  print(leadId);
  print("lead dataaa");

  var data;
  String? authresponce;

  String dd= "${baseUrl}api/lead/${leadId}?action=${value}";
print(dd);
print("finaldd");

  Response response = await get(
    Uri.parse("${baseUrl}api/lead/${leadId}?action=${value}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}

convertleadDataGet(int leadId, String value) async {
  String token = await getUserJwt();

  print(leadId);
  print("lead dataaa");

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/lead/${leadId}/${value}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}

leadconvertion(int id, String modeltype, int salespersonId, int salesTeamId,
    String action, int? customerId, List leadTableData) async {
  String token = await getUserJwt();
  (action == "create"
      ? customerId = null
      : action == "nothing"
          ? customerId = null
          : customerId = customerId);

  print(id);
  print(modeltype);
  print(salespersonId);
  print(salesTeamId);
  print(action);
  print(customerId);
  print(leadTableData);
  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg;
    modeltype == "convert"
        ? msg = jsonEncode({
            "params": {
              "id": id,
              "name": modeltype,
              "user_id": salespersonId,
              "team_id": salesTeamId,
              "action": action,
              "partner_id": customerId
            }
          })
        : msg = jsonEncode({
            "params": {
              "id": id,
              "name": modeltype,
              "user_id": salespersonId,
              "team_id": salesTeamId,
              "duplicated_lead_ids": leadTableData,
            }
          });

    Response response = await post(
      Uri.parse('${baseUrl}api/lead/convert'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      authresponce = data['result'].toString();
      print(data);
      print(authresponce);
      print("finalstring");
      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  return resMessageText;
}

deleteLeadData(int leadId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/lead/${leadId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}

createLead(
  String name,
  email_from,
  email_cc,
  contactname,
  companyname,
  phone,
  priority,
  lang_id,
  street,
  street2,
  city,
  website,
  function,
  refferedby,
  description,
  int? company_id,
  user_id,
  team_id,
  probability,
  state_id,
  zip,
  country_id,
  mobile,
  tag_ids,
  title_id,
  medium_id,
  source_id,
  campaign_id,
) async {
  print(tag_ids);
  print('tag idsssscreate');
  print(name.toString());
  print(companyname.toString());
  print(title_id.toString());

  print(contactname.toString());

  print(email_from.toString());
  print(email_cc.toString());
  print(phone.toString());
  //print(expected_revenue.toString());
  print(priority.toString());
  print(company_id.toString());
  print(country_id.toString());
  //print(title.toString());
  print(lang_id.toString());
  print(user_id.toString());
  print(team_id.toString());
  print(probability.toString());
  print("probability proobability");

  print(street.toString());
  print(street2.toString());
  print(city.toString());
  print(state_id.toString());
  print(zip.toString());
  print(website.toString());
  print(function.toString());
  print(mobile.toString());
  print(refferedby.toString());
  print(description.toString());
  print(medium_id.toString());
  print(source_id.toString());
  print(campaign_id.toString());

  String token = await getUserJwt();

  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "name": name,
        "type": "lead",
        "email_from": email_from,
        "phone": phone,
        "priority": priority,
        "company_id": company_id,
        "user_id": user_id,
        "team_id": team_id,
        "probability": probability,
        "street": street,
        "street2": street2,
        "city": city,
        "state_id": state_id,
        "zip": zip,
        "country_id": country_id,
        "website": website,
        "function": function,
        "mobile": mobile,
        "lang_id": lang_id,
        //"tag_ids":[tag_ids],
        "tag_ids": tag_ids,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "title": title_id,
        "partner_name": companyname,
        "contact_name": contactname,
        "email_cc": email_cc,
        "referred": refferedby,
        "description": description
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/lead'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = '0';
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");

  name = "";
  email_from = "";
  email_cc = "";
  contactname = "";
  companyname = "";
  phone = "";
  priority = "";
  lang_id = "";
  street = "";
  street2 = "";
  city = "";
  website = "";
  function = "";
  refferedby = "";
  description = "";

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}

editLead(
  String name,
  email_from,
  email_cc,
  contactname,
  companyname,
  phone,
  priority,
  lang_id,
  street,
  street2,
  city,
  website,
  function,
  refferedby,
  description,
  int? company_id,
  user_id,
  team_id,
  probability,
  state_id,
  zip,
  country_id,
  mobile,
  tag_ids,
  title_id,
  medium_id,
  source_id,
  campaign_id,
  leadid,
) async {
  print(tag_ids);
  print('tag idssss');
  print(name.toString());
  print(companyname.toString());
  print(title_id.toString());

  print(contactname.toString());

  print(email_from.toString());
  print(email_cc.toString());
  print(phone.toString());
  //print(expected_revenue.toString());
  print(priority.toString());
  print(company_id.toString());
  print(country_id.toString());
  //print(title.toString());
  print(lang_id.toString());
  print(user_id.toString());
  print(team_id.toString());
  print(probability.toString());
  print("probability proobability");

  print(street.toString());
  print(street2.toString());
  print(city.toString());
  print(state_id.toString());
  print(zip.toString());
  print(website.toString());
  print(function.toString());
  print(mobile.toString());
  print(refferedby.toString());
  print(description.toString());
  print(medium_id.toString());
  print(source_id.toString());
  print(campaign_id.toString());

  String token = await getUserJwt();

  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "name": name,
        "type": "lead",
        "email_from": email_from,
        "phone": phone,
        "priority": priority,
        "company_id": company_id,
        "user_id": user_id,
        "team_id": team_id,
        "probability": probability,
        "street": street,
        "street2": street2,
        "city": city,
        "state_id": state_id,
        "zip": zip,
        "country_id": country_id,
        "website": website,
        "function": function,
        "mobile": mobile,
        "lang_id": lang_id,
        //"tag_ids":[],
        "tag_ids": tag_ids,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "title": title_id,
        "partner_name": companyname,
        "contact_name": contactname,
        "email_cc": email_cc,
        "referred": refferedby,
        "description": description
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/lead/${leadid}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");

  name = "";
  email_from = "";
  email_cc = "";
  contactname = "";
  companyname = "";
  phone = "";
  priority = "";
  lang_id = "";
  street = "";
  street2 = "";
  city = "";
  website = "";
  function = "";
  refferedby = "";
  description = "";

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}



editLeadpriority(
    String
    priority,

    leadid,
    ) async {


  String token = await getUserJwt();

  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {

        "priority": priority,

      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/lead/${leadid}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");


  print(resMessageText);
  print("dataaa");
  return resMessageText;
}



lostLead(int id, bool value) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {"active": value}
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/lead/${id}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      //authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}

Future<List<dynamic>> recentLead(String model) async {
  String token = await getUserJwt();
  var responseList;
  print(token);

  print("${baseUrl}api/leads?count=10&page_no=1&key_word=&company_ids=${globals.selectedIds}&filters=[$model]");
  print("fsfsdfsf");
  try {
    final response = await get(
      Uri.parse(
          "${baseUrl}api/leads?count=10&page_no=1&key_word=&company_ids=${globals.selectedIds}&filters=[$model]"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    //"https://jsonplaceholder.typicode.com/LeadModels?_page=$_pageNumber&_limit=$_numberOfLeadModelsPerRequest"));
    //List responseList = json.decode(response.body);
    responseList = jsonDecode(response.body);
    print("company_ids");
    print(responseList['records']);
    print("c");
  } catch (e) {
    print("error --> $e");
  }

  print("company_ids11");
  return responseList['records'];
}

//create opportunity

createOpportunity(
    String name,
    email_from,
    email_cc,
    contactname,
    companyname,
    phone,
    priority,
    lang_id,
    street,
    street2,
    city,
    website,
    function,
    refferedby,
    description,
    int? pricelist_id,
    company_id,
    user_id,
    team_id,
    probability,
    state_id,
    zip,
    country_id,
    mobile,
    tag_ids,
    title_id,
    medium_id,
    source_id,
    campaign_id,
    partner_id,
    double expected_revenue,
    List orderLineProducts) async {
  print(tag_ids);
  print(name.toString());
  print(companyname.toString());
  print(title_id.toString());
  print(contactname.toString());
  print(email_from.toString());
  print(email_cc.toString());
  print(phone.toString());
  print(priority.toString());
  print(pricelist_id.toString());
  print(company_id.toString());
  print(country_id.toString());
  print(lang_id.toString());
  print(user_id.toString());
  print(team_id.toString());
  print(probability.toString());
  print(street.toString());
  print(street2.toString());
  print(city.toString());
  print(state_id.toString());
  print(zip.toString());
  print(website.toString());
  print(function.toString());
  print(mobile.toString());
  print(refferedby.toString());
  print(description.toString());
  print(medium_id.toString());
  print(source_id.toString());
  print(campaign_id.toString());
  print(partner_id.toString());
  print(expected_revenue.toString());

  String token = await getUserJwt();

  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "name": name,
        "type": "opportunity",
        "email_from": email_from,
        "phone": phone,
        "priority": priority,
        "pricelist_id": pricelist_id,
        "company_id": company_id,
        "user_id": user_id,
        "team_id": team_id,
        "expected_revenue": expected_revenue,
        "probability": probability,
        "partner_id": partner_id,
        "street": street,
        "street2": street2,
        "city": city,
        "state_id": state_id,
        "zip": zip,
        "country_id": country_id,
        "website": website,
        "function": function,
        "mobile": mobile,
        "lang_id": lang_id,
        "tag_ids": tag_ids,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "title": title_id,
        "partner_name": companyname,
        "contact_name": contactname,
        "email_cc": email_cc,
        "referred": refferedby,
        "description": description,
        "crm_lead_line": orderLineProducts
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/opportunity'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = '0';
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");

  name = "";
  email_from = "";
  email_cc = "";
  contactname = "";
  companyname = "";
  phone = "";
  priority = "";
  lang_id = "";
  street = "";
  street2 = "";
  city = "";
  website = "";
  function = "";
  refferedby = "";
  description = "";
  expected_revenue = 0.0;

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}

//create opportunity

//edit opportinity

editOpportunity(
    String name,
    email_from,
    email_cc,
    contactname,
    companyname,
    phone,
    mobile,
    priority,
    lang_id,
    street,
    street2,
    city,
    zip,
    website,
    function,
    refferedby,
    description,
    int? pricelist_id,
    company_id,
    user_id,
    team_id,
    probability,
    state_id,
    country_id,
    tag_ids,
    title_id,
    medium_id,
    source_id,
    campaign_id,
    partner_id,
    opportunityid,
    double expected_revenue,
    List orderLineProducts) async {
  print(name.toString());
  print(companyname.toString());
  print(title_id.toString());
  print(contactname.toString());
  print(email_from.toString());
  print(email_cc.toString());
  print(phone.toString());
  print(priority.toString());
  print(pricelist_id.toString());
  print(company_id.toString());
  print(country_id.toString());
  print(lang_id.toString());
  print(user_id.toString());
  print(team_id.toString());
  print(expected_revenue.toString());
  print(probability.toString());
  print(street.toString());
  print(street2.toString());
  print(city.toString());
  print(state_id.toString());
  print(zip.toString());
  print(website.toString());
  print(function.toString());
  print(mobile.toString());
  print(refferedby.toString());
  print(description.toString());
  print(medium_id.toString());
  print(source_id.toString());
  print(campaign_id.toString());
  print(partner_id.toString());
  print(tag_ids);
  String token = await getUserJwt();
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "name": name,
        "type": "opportunity",
        "email_from": email_from,
        "phone": phone,
        "priority": priority,
        "pricelist_id": pricelist_id,
        "company_id": company_id,
        "user_id": user_id,
        "team_id": team_id,
        "expected_revenue": expected_revenue,
        "probability": probability,
        "partner_id": partner_id,
        "street": street,
        "street2": street2,
        "city": city,
        "state_id": state_id,
        "zip": zip,
        "country_id": country_id,
        "website": website,
        "function": function,
        "mobile": mobile,
        "lang_id": lang_id,
        "tag_ids": tag_ids,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "title": title_id,
        "partner_name": companyname,
        "contact_name": contactname,
        "email_cc": email_cc,
        "referred": refferedby,
        "description": description,
        "crm_lead_line": orderLineProducts
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/opportunity/${opportunityid}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      print(resMessage);

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);

  name = "";
  email_from = "";
  email_cc = "";
  contactname = "";
  companyname = "";
  phone = "";
  priority = "";
  lang_id = "";
  street = "";
  street2 = "";
  city = "";
  website = "";
  function = "";
  refferedby = "";
  description = "";
  expected_revenue = 0.0;

  print(resMessageText);
  return resMessageText;
}





editOppertunitypriority(
    String
    priority,
   int opportunityid,
    ) async {

  String token = await getUserJwt();
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {

        "priority": priority,

      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/opportunity/${opportunityid}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      print(resMessage);

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);



  print(resMessageText);
  return resMessageText;
}



//delete opportunity

deleteOpportunityData(int opportunityId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/opportunity/${opportunityId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  return data;
}

getOpportunityData(int opportunityId, String value) async {
  String token = await getUserJwt();

  print(opportunityId);
  var data;
  String? authresponce="${baseUrl}api/opportunity/${opportunityId}?action=${value}";

print(authresponce);
print("jsfhdvjdsv");
  Response response = await get(
    Uri.parse("${baseUrl}api/opportunity/${opportunityId}?action=${value}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("demooooooo");
  return data;
}

getOpportunityTypes() async {
  String token = await getUserJwt();

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/stages"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data['records']);
  print("data");

  return data['records'];
}

Future<List<dynamic>> getOpportunityTypesData(int type) async {
  String token = await getUserJwt();
  var responseList;
  print(token);
  print(type);
  print("datatypeee");

  try {
    final response = await get(
      Uri.parse(
          "${baseUrl}api/opportunity?count=10&page_no=1&key_word=&company_ids=${globals.selectedIds}&stage_id=[$type]"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    //"https://jsonplaceholder.typicode.com/LeadModels?_page=$_pageNumber&_limit=$_numberOfLeadModelsPerRequest"));
    //List responseList = json.decode(response.body);
    responseList = jsonDecode(response.body);
    print("company_ids");
    print(responseList['records']);
    print("c");
  } catch (e) {
    print("error --> $e");
  }

  print("company_ids11");
  return responseList['records'];
}

lostOpportunity(int id, opportunitylostId, String action) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {"action": action, "lost_reason": opportunitylostId}
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/opportunity/${id}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  return resMessageText;
}

restoreWonOpportunity(int id, opportunitylostId, String action) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "action": action,
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/opportunity/${id}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  return resMessageText;
}

archiveOpportunity(int id, opportunitylostId, bool action) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "active": action,
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/opportunity/${id}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  return resMessageText;
}

opportunityStageChange(int stateId, opportunityId) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "stage_id": stateId,
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/opportunity/${opportunityId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessage);
  return resMessageText;
}


getOpportunityQuotationData(int opportunityId, String value) async {
  String token = await getUserJwt();

  print(opportunityId);
  var data;
  String? authresponce;

  print("${baseUrl}api/opportunity/${opportunityId}/quotation");
  print("finalnaknsk");
  Response response = await get(

    Uri.parse("${baseUrl}api/opportunity/${opportunityId}/quotation"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("quatationedit");
  return data;
}


getOpportunityProductDefaultData(int opportunityProductId) async {
  String token = await getUserJwt();

  print("lead dataaa");

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/product/${opportunityProductId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}


createQuotation(
    int? customer_id,
    quotation_template_id,
    pricelist_id,
    payment_terms_id,
    salesperson_id,
    team_id,
    company_id,
    tags_id,
    fiscal_position_id,
    campaign_id,
    medium_id,
    source_id,
    String customer_reference,
    source_document,
    expiration_date,
    delivery_date,
    bool online_signature,
    online_payment,
    String shipping_policy,
    List orderLineProducts,
    optionalProducts,
    opportunity_id) async {

  String token = await getUserJwt();
  String? authresponce, resMessage, resMessageText;
  print(token);

  try {
    final msg = jsonEncode({
      "params": {
        "partner_id": customer_id,
        "opportunity_id":opportunity_id,
        "sale_order_template_id": quotation_template_id,
        "validity_date": expiration_date,
        "pricelist_id": pricelist_id,
        "commitment_date": delivery_date,
        "payment_term_id": payment_terms_id,
        "user_id": salesperson_id,
        "team_id": team_id,
        "company_id": company_id,
        "require_signature": online_signature,
        "require_payment": online_payment,
        "client_order_ref": customer_reference,
        "picking_policy": shipping_policy,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "tag_ids": tags_id,
        "fiscal_position_id": fiscal_position_id,
        "origin": source_document,
        "order_line": orderLineProducts,
        "sale_order_option_ids": optionalProducts
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/quotation'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    print("printtttttt");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
        print(resMessageText);
        print("suuuuuuu");
      }

      if (resMessage == "error") {
        resMessageText = '0';
      }
      print("lakkkkkk");
    } else {}
  } catch (e) {
    print(e.toString());
  }
  customer_reference = "";
  source_document = "";
  expiration_date = "";
  delivery_date = "";

  print(resMessage);
  print(" resMessageText");
  return resMessageText;
}





createQuotationOpp(
    int? customer_id,
    quotation_template_id,
    pricelist_id,
    payment_terms_id,
    salesperson_id,
    team_id,
    company_id,
    tags_id,
    fiscal_position_id,
    campaign_id,
    medium_id,
    source_id,
    String customer_reference,
    source_document,
    expiration_date,
    delivery_date,
    bool online_signature,
    online_payment,
    String shipping_policy,
    List orderLineProducts,
    optionalProducts,
    opportunity_id) async {
  print(customer_id);
  print(quotation_template_id);
  print(pricelist_id);
  print(payment_terms_id);
  print(salesperson_id);
  print(team_id);
  print(company_id);
  print(tags_id);
  print(fiscal_position_id);
  print(campaign_id);
  print(medium_id);
  print(source_id);
  print(customer_reference.toString());
  print(source_document.toString());
  print(expiration_date.toString());
  print(delivery_date.toString());

  String token = await getUserJwt();
  String?  resMessage, resMessageText;
  var authresponce;
  print(token);

  try {
    final msg = jsonEncode({
      "params": {
        "partner_id": customer_id,
        "opportunity_id":opportunity_id,
        "sale_order_template_id": quotation_template_id,
        "validity_date": expiration_date,
        "pricelist_id": pricelist_id,
        "commitment_date": delivery_date,
        "payment_term_id": payment_terms_id,
        "user_id": salesperson_id,
        "team_id": team_id,
        "company_id": company_id,
        "require_signature": online_signature,
        "require_payment": online_payment,
        "client_order_ref": customer_reference,
        "picking_policy": shipping_policy,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "tag_ids": tags_id,
        "fiscal_position_id": fiscal_position_id,
        "origin": source_document,
        "order_line": orderLineProducts,
        "sale_order_option_ids": optionalProducts
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/quotation'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    print("printtttttt");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      // authresponce = data['result'].toString();
      authresponce = data;

      resMessage = data['result']['message'];
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
        print(resMessageText);
        print("suuuuuuu");
      }

      if (resMessage == "error") {
        resMessageText = data['result']['data'];
      }
      print("lakkkkkk");
    } else {}
  } catch (e) {
    print(e.toString());
  }
  customer_reference = "";
  source_document = "";
  expiration_date = "";
  delivery_date = "";

  print(resMessage);
  print(" resMessageText");
  return authresponce;
}

editQuotation(
    int? customer_id,
    quotation_template_id,
    pricelist_id,
    payment_terms_id,
    salesperson_id,
    team_id,
    company_id,
    tags_id,
    fiscal_position_id,
    campaign_id,
    medium_id,
    source_id,
    String customer_reference,
    source_document,
    expiration_date,
    delivery_date,
    bool online_signature,
    online_payment,
    quotationid,
    String shipping_policy,
    List orderLineProducts,
    optionalProducts,
   ) async {
  print(customer_id);
  print(quotation_template_id);
  print(pricelist_id);
  print(payment_terms_id);
  print(salesperson_id);
  print(team_id);
  print(company_id);
  print(tags_id);
  print(fiscal_position_id);
  print(campaign_id);
  print(medium_id);
  print(source_id);
  //print(customer_reference.toString());
  print(source_document.toString());
  print(expiration_date.toString());
  print(delivery_date);
  print(orderLineProducts);
  print(optionalProducts);

  print("demo datatata");

  String token = await getUserJwt();
  String? authresponce, resMessage, resMessageText;

  print("hjfgcjsgj");
  try {
    final msg = jsonEncode({
      "params": {
        "partner_id": customer_id,

        "sale_order_template_id": quotation_template_id,
        "validity_date": expiration_date,
        "pricelist_id": pricelist_id,
        "commitment_date": delivery_date,
        "payment_term_id": payment_terms_id,
        "user_id": salesperson_id,
        "team_id": team_id,
        "company_id": company_id,
        "require_signature": online_signature,
        "require_payment": online_payment,
        "client_order_ref": customer_reference,
        "picking_policy": shipping_policy,
        "source_id": source_id,
        "medium_id": medium_id,
        "campaign_id": campaign_id,
        "tag_ids": tags_id,
        "fiscal_position_id": fiscal_position_id,
        "origin": source_document,
        "order_line": orderLineProducts,
        "sale_order_option_ids": optionalProducts
      }
    });

    print(msg);
    print("datapapapa");

    Response response = await put(
      Uri.parse('${baseUrl}api/quotation/${quotationid}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);

    print(jsonDecode(response.body.toString()));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = '0';
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  return resMessageText;
}

getQuotationData(int quotationId, String value) async {
  String token = await getUserJwt();

  print(quotationId);
  var data;
  String? authresponce=   "${baseUrl}api/quotation/${quotationId}?action=${value}";
  print(authresponce);
  print("final responceee");

  Response response = await get(
    Uri.parse("${baseUrl}api/quotation/${quotationId}?action=${value}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data["tax_totals_json"]);
  print("quatationedit");
  return data;
}



getProductSum(List orderLineProductsData,int pricelistId) async {
  String token = await getUserJwt();
  print("pricelisttt");

  String? authresponce, resMessage, resMessageText;
 var data;
  try {
    final msg = jsonEncode({
      "params": {
        "pricelist_id":pricelistId,
        "order_line": orderLineProductsData,
      }
    });

print(orderLineProductsData);
print("orderLineProductsData");

    Response response = await post(
      Uri.parse('${baseUrl}api/total'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    print("datatatata");

    if (response.statusCode != 200) {
      throw Exception("failed to get data from internet");
    } else {
      data = jsonDecode(response.body);
    }

  } catch (e) {
    print(e.toString());
  }
  print(data);
  // print(data['result']["data"]['data']);
  // print(data['result']['data']["total"]);
  // print("quatationedit");


  return data;
}





//
// getProductSum(List orderLineProductsData) async {
//   String token = await getUserJwt();
//
//   print(orderLineProductsData);
//   print("final data");
//   var data;
//   String? authresponce;
//
//
//   Map<String, String> queryParams = {
//   // "params": {
//     'order_line': orderLineProductsData.toString(),
//   // }
//   };
//
//   Response response = await get(
//     Uri.parse("${baseUrl}api/total?${orderLineProductsData}"),
//     headers: {
//       'Authorization': 'Bearer $token',
//     },
//   ).timeout(const Duration(
//     seconds: 10,
//   ));
//   print(response);
//   print("final responceeee");
//
//   if (response.statusCode != 200) {
//     throw Exception("failed to get data from internet");
//   } else {
//     data = jsonDecode(response.body);
//   }
//
//   print(data);
//   print("quatationedit");
//   return data;
// }
//


getQuotationCustomerData(int quoatationcustomerId) async {
  String token = await getUserJwt();

  print(quoatationcustomerId);
  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/customer/${quoatationcustomerId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("responce datatatatat");
  return data;
}


getCustomerCompanyData(int customerId) async {
  String token = await getUserJwt();

  print(customerId);
  var data;
  String? authresponce;

  Response response = await get(

    Uri.parse("${baseUrl}api/customer/${customerId}?model=contact"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("responce datatatatat");
  return data;
}





addUserStringToSF(String personName, String personMobile, String personMail,
    String personJwt, String jsonListmultiCompany) async {
  String personNames,
      personMobiles,
      personMails,
      personJwts,
      jsonListmultiCompanys;
  // List multicompanyData;

  personNames = personName;
  personMobiles = personMobile;
  personMails = personMail;
  personJwts = personJwt;
  jsonListmultiCompanys = jsonListmultiCompany;
  //multicompanyData = multicompany;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('personName', personNames);
  prefs.setString('personMobile', personMobiles);
  prefs.setString('personMail', personMails);
  prefs.setString('personJwt', personJwts);
  prefs.setString('multiCompany', jsonListmultiCompanys);
}

deleteQuotationData(int quotationId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/quotation/${quotationId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);

  return data;
}

// customer


schedulecreateCustomer(String company_type, name, email, function,phone,mobile,
    int? company_id) async {


  String token = await getUserJwt();

  print("tocken responece");
  String? authresponce, resMessage;
      var resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "company_type": company_type,
        "name": name,
        "email": email,
        "function": function,
        "parent_id": company_id,
        "phone": phone,
        "mobile": mobile,
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/contact'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    print("demo message");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'];
      }

      if (resMessage == "error") {
        resMessageText = 0;
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");


  print(resMessageText);
  print("dataaa");
  return resMessageText;
}




createCustomer(String company_type, name, street, street2, city, website, email, function, ref, comment,zip,
    vat,phone,mobile,
    int? parent_id,company_id,title,state_id,country_id,customer_rank,supplier_rank,
    category_id,user_id,property_payment_term_id,language,fiscalposition,pricelist,String selectedImages,List addNewCustomer) async {


  String token = await getUserJwt();

  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "company_type": company_type,
        "name": name,
        "street": street,
        "street2": street2,
        "city": city,
        "website": website,
        "email": email,
        "function": function,
        "ref": ref,
        "parent_id": parent_id,
        "comment": comment,
        "company_id": company_id,
        "title":title,
        "state_id": state_id,
        "zip": zip,
        "country_id": country_id,
        "vat": vat,
        "phone": phone,
        "mobile": mobile,
        "customer_rank":customer_rank !="" ? int.parse(customer_rank):0,
        "supplier_rank":supplier_rank !="" ? int.parse(supplier_rank):0,
        "category_id": category_id,
        "user_id": user_id,
        "property_payment_term_id": property_payment_term_id,
        "lang":language,
        "property_product_pricelist":pricelist,
        "property_account_position_id":fiscalposition,
        "image_1920":selectedImages,
        "child_ids": addNewCustomer
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/contact'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    print("demo message");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = '0';
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");


  print(resMessageText);
  print("dataaa");
  return resMessageText;
}



EditCustomer(String company_type, name, street, street2, city, website, email, function, ref, comment,zip,
    vat,phone,mobile,
    int? parent_id,company_id,title,state_id,country_id,customer_rank,supplier_rank,
    category_id,user_id,property_payment_term_id,language,fiscalposition,pricelist,List addNewCustomer,int customerId,String selectedImages ) async {


  String token = await getUserJwt();
print(addNewCustomer);
  print("tocken responece");
  String? authresponce, resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "company_type": company_type,
        "name": name,
        "street": street,
        "street2": street2,
        "city": city,
        "website": website,
        "email": email,
        "function": function,
        "ref": ref,
        "parent_id": parent_id,
        "comment": comment,
        "company_id": company_id,
        "title":title,
        "state_id": state_id,
        "zip": zip,
        "country_id": country_id,
        "vat": vat,
        "phone": phone,
        "mobile": mobile,
        "customer_rank":customer_rank !="" ? int.parse(customer_rank):0,
        "supplier_rank":supplier_rank !="" ? int.parse(supplier_rank):0,
        "category_id": category_id,
        "user_id": user_id,
        "property_payment_term_id": property_payment_term_id,
        "lang":language,
        "property_product_pricelist":pricelist,
        "property_account_position_id":fiscalposition,
        "image_1920":selectedImages,
        "child_ids": addNewCustomer
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/contact/${customerId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    print("demo message");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = '0';
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(authresponce);

  print(resMessage);
  print(resMessageText);
  print("bhgvhb");


  print(resMessageText);
  print("dataaa");
  return resMessageText;
}





getCustomerData(int customerId,String value) async {
  String token = await getUserJwt();

  var data;
  String? authresponce="${baseUrl}api/contact/${customerId}?action=${value}";
  print(authresponce);

  Response response = await get(Uri.parse(
      "${baseUrl}api/contact/${customerId}?action=${value}"),
    headers: {

      'Authorization': 'Bearer $token',

    },
  )
      .timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  }
  else{
    data = jsonDecode(response.body);
  }
  print(data);
  return data;
}

deleteCustomerData(int customerId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(Uri.parse(
      "${baseUrl}api/contact/${customerId}"),
    headers: {

      'Authorization': 'Bearer $token',

    },
  )
      .timeout(const Duration(
    seconds: 10,
  ));


  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  }
  else{
    data = jsonDecode(response.body);
  }
  print(data);

  return data;
}


archiveCustomer(int id, bool value) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {"active": value}
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/contact/${id}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);

  return resMessageText;
}


getCustomerDefaultData(int customerId, String value) async {
  String token = await getUserJwt();

  print(customerId);
  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/contact/${customerId}?action=${value}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  return data;
}



getCalenders() async {

  List<Calenders> calenders = [];
  late Calenders calendersDetails;
  List<Calenders> calendersDetailss = [];

  String token = await getUserJwt();


  String url = "${baseUrl}api/calendars";
  final response = await http.get(Uri.parse(url),
    headers: {

      'Authorization': 'Bearer $token',

    },);

  print("calendar datatata");
  print(jsonDecode(response.body)['records']);


  var convertData = jsonDecode(response.body)['records'];
  print(convertData);
  print("asdfgdemooo");



  for (var u in convertData) {
    calendersDetails = new Calenders(id: u["id"], name: u["name"],starttime: u["start"],stoptime: u["stop"],durations: u["duration"].toString());

    calendersDetailss.add(calendersDetails);
    calenders.add(calendersDetails);

    // setState(() {
    //   calenders.add(calendersDetails);
    //
    // });

  }
  print(calendersDetailss);
  print("demodemo");
  print(calenders);
  return calendersDetailss;
}

createCalendar(int? orgnizerId,partnerName,reminders,tags,
    String meetingsubject, meeting_duration,location,meetingurl,meeting_discription,dropdowncreatevalue,dropdowncreatevalues,
    String startTime,stopTime,res_model_id,int? res_id,activity_ids
) async {

  String token = await getUserJwt();
  String? authresponce, resMessage, resMessageText;
  print(token);

  try {
    final msg = jsonEncode({
      "params": {
        "activity_ids": [activity_ids],
        "res_id": res_id,
        "res_model_id": res_model_id,
        "name":meetingsubject,
        "location": location,
        "videocall_location": meetingurl,
        "start": startTime,
        "stop": stopTime,
        "partner_ids": partnerName,
        "user_id": orgnizerId,
        "allday": false,
        "privacy": dropdowncreatevalue,
        "show_as": dropdowncreatevalues,
        "description": meeting_discription,
        "categ_ids": tags,
        "alarm_ids": reminders
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/calendar'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
        print(resMessageText);
        print("ssuuuuuu");

      }

      if (resMessage == "error") {
        resMessageText = '0';
        print("dddddd");
      }

    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessage);
  print(" resMessageText");
  return resMessageText;
}


editCalendar(int? orgnizerId,partnerName,reminders,tags,
    String meetingsubject, meeting_duration,location,meetingurl,meeting_discription,dropdowncreatevalue,dropdowncreatevalues,
    String startTime,stopTime,calendarid,String res_model_id,int? res_id,activity_ids
    ) async {

  String token = await getUserJwt();
  String? authresponce, resMessage, resMessageText;
  print(partnerName);
  print("partnerName");
  print(token);

  try {
    final msg = jsonEncode({
      "params": {
        "activity_ids": [activity_ids],
        "res_id": res_id,
        "res_model": res_model_id,
        "name":meetingsubject,
        "location": location,
        "videocall_location": meetingurl,
        "start": startTime,
        "stop": stopTime,
        "partner_ids": partnerName,
        "user_id": orgnizerId,
        "allday": false,
        "privacy": dropdowncreatevalue,
        "show_as": dropdowncreatevalues,
        "description": meeting_discription,
        "categ_ids": tags,
        "alarm_ids": reminders,
        "duration":meeting_duration
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/calendar/${calendarid}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("dasfsf");
      authresponce = data['result'].toString();

      resMessage = data['result']['message'];
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
        print(resMessageText);
        print("ssuuuuuu");

      }

      if (resMessage == "error") {
        resMessageText = '0';
        print("dddddd");
      }

    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessage);
  print(" resMessageText");
  return resMessageText;
}


deleteCalendar(int calendarId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/calendar/${calendarId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}






defaultDropdownCalendar() async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/calendar"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    print(response.body);
    print("responce dataa");
    data = jsonDecode(response.body);

    authresponce = data.toString();
  }


  return data;
}

deleteCalendarData(int calendarId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/calendar/${calendarId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);


  return data;
}

getCalendarData(int calendarId) async {
  String token = await getUserJwt();

  print(calendarId);
  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/calendar/${calendarId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("finalllalalalala");
  return data;
}


// schedule activity

defaultScheduleData(int id, String value) async {
  String token = await getUserJwt();

  print(id);
  print("${baseUrl}api/activity?res_model=${value}&res_id=${id}");
  print("lead dataaatttt");

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/activity?res_model=${value}&res_id=${id}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}


// tag colors
colorsData()  async {
  String token = await getUserJwt();


  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/colors"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    data=[];
    throw Exception("failed to get data from internet");

  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("data");

  return data;
}

colorChange(int tagId,colorId) async {

  String token = await getUserJwt();
  String? resMessage, resMessageText;

  try {
    final msg = jsonEncode({
      "params": {
        "color":colorId,

      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/tag/${tagId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = "success";
      }


      if (resMessage == "error") {
        resMessageText = "error";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}


// tag colors

//send message

defaultSendmessageData(int id, String value,List<int> selectedIds)  async {
  String token = await getUserJwt();

  print(id);
  print("${baseUrl}api/log?res_model=${value}&res_id=${id}&type=send_message&partner_ids=${selectedIds}");
  print("lead dataaa final");

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/log?res_model=${value}&res_id=${id}&type=send_message&partner_ids=${selectedIds}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("data");

  return data;
}

sendMailsFollowers(int id, String value) async {
  String token = await getUserJwt();

  print(id);
  print("${baseUrl}api/log?res_model=${value}&res_id=${id}&type=send_message");
  print("lead dataaa finalsshshs");

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/email_followers?res_model=${value}&res_id=${id}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);
  }

  print(data);
  print("datafinalsssss");

  return data;
}




scheduleActivity(int activity_type_id,user_id,res_id,
    String summary,date_deadline,note,res_model,mark_done) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;



  try {
    final msg = jsonEncode({
      "params": {
        "action":mark_done,
        "activity_type_id":activity_type_id,
        "summary": summary,
        "date_deadline": date_deadline,
        "user_id": user_id,
        "note": note,
        "res_id": res_id,
        "res_model": res_model
      }
    });

    Response response = await post(
      Uri.parse('${baseUrl}api/activity'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
        resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}





editScheduleActivity(int activity_type_id,user_id,res_id,
    String summary,date_deadline,note,res_model,mark_done,
    int scheduleId) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  print(scheduleId);
  print("asjfbvjsbf");



  try {
    final msg = jsonEncode({
      "params": {
        "action":mark_done,
        "activity_type_id":activity_type_id,
        "summary": summary,
        "date_deadline": date_deadline,
        "user_id": user_id,
        "note": note,
        "res_id": res_id,
        "res_model": res_model
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/activity/${scheduleId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstring");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaa");
  return resMessageText;
}


markDoneScheduleActivity(String notes,int scheduleId) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  print(scheduleId);
  print("asjfbvjsbf");



  try {
    final msg = jsonEncode({
      "params": {
        "action" : "mark_done",
        "note": notes,

      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/activity/${scheduleId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstringdataaa");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaaa");
  return resMessageText;
}


getScheduleActivityData(int dataId, String activityModel) async {
  String token = await getUserJwt();

  print(dataId);
  print("lead dataaa");

  var data;
  String? authresponce= "${baseUrl}api/activities?res_model=${activityModel}&res_id=${dataId}";

  print(authresponce);
  print("authresponce");

  Response response = await get(



    Uri.parse("${baseUrl}api/activities?res_model=${activityModel}&res_id=${dataId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}

deleteScheduleData(int scheduleId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/activity/${scheduleId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("datadaasf");

  return data;
}





editDefaultScheduleData(int dataId) async {
  String token = await getUserJwt();

  print(dataId);
  print("lead dataaa");

  var data;
  String? authresponce;

  Response response = await get(



    Uri.parse("${baseUrl}api/activity/${dataId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("dataegrfsbfhjsbfjh");

  return data;
}


// lognote


logNoteCreate(String lognotes,logmodel,int resId,List myData1) async {
  String token = await getUserJwt();
  String? resMessage;
      var resMessageText;

  print(resId);
  print("asjfbvjsbf");



  try {
    final msg = jsonEncode({
      "params": {
        "data": {
          "body": lognotes,
          "model": logmodel,
          "res_id": resId
        },

        "attachments": myData1,

      }

    });

    Response response = await post(
      Uri.parse('${baseUrl}api/log'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstringdataaa");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result'];
      }

      if (resMessage == "error") {
        resMessageText = "failed";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaaa");
  return resMessageText;
}


EditlogNote(String lognotes,logmodel,int resId,List myData1,int logId) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  print(resId);
  print("asjfbvjsbf");



  try {
    final msg = jsonEncode({
      "params": {
        "data": {
          "body": lognotes,
          "model": logmodel,
          "res_id": resId
        },

       "attachments": myData1,

      }

    });

    Response response = await put(
      Uri.parse('${baseUrl}api/log/${logId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstringdataaa");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaaa");
  return resMessageText;
}




getlogNoteData(int dataId, String activityModel) async {
  String token = await getUserJwt();

  print(dataId);
  print("${baseUrl}api/logs?res_model=${activityModel}&res_id=${dataId}");
  print("lead dataaaaaaaa");

  var data;
  String? authresponce;
  print("${baseUrl}api/logs?res_model=${activityModel}&res_id=${dataId}");
  print("finallllaaa");
  Response response = await get(



    Uri.parse("${baseUrl}api/logs?res_model=${activityModel}&res_id=${dataId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data.length);
  print("datapasssssssdemoooo");

  return data;
}



deleteLogData(int logId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/log/${logId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("datadeleteeee");

  return data;
}


deleteEmoji(String emoji,int logId) async {
  String token = await getUserJwt();
  var data;



  try {
    final msg = jsonEncode({
      "params": {
        "reaction": emoji
      }
    });
    print(msg);
    print("finedata");
    Response response = await delete(
      Uri.parse("${baseUrl}api/reaction/${logId}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );
print(msg);

    if (response.statusCode != 200) {
      throw Exception("failed to get data from internet");
    } else {
      data = jsonDecode(response.body);


    }
  }
  catch(e) {
    print(e.toString());
  }
  print(data);
  print("datadeleteeee");

  return data;
}



logStarChange(int logId, bool value) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;
  var data;
  try {
    final msg = jsonEncode({
      "params": {
        "data": {
          "starred": value
        }
      }
    });

    Response response = await put(
      Uri.parse('${baseUrl}api/log/${logId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());

    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(data);
  print("dataaa");
  return data;
}


deleteLogAttachment(int attachmentId) async {
  String token = await getUserJwt();
  var data;
  String? authresponce;

  Response response = await delete(
    Uri.parse("${baseUrl}api/attachment/${attachmentId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("datadeleteeeedelete");

  return data;
}

// attachment details


attchmentDataCreate(List myData1) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;




  try {
    final msg = jsonEncode({
      "params": {
        "attachments": myData1,
      }

    });

    Response response = await post(
      Uri.parse('${baseUrl}api/attachment'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstringdataaa");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['att_count'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaaa");
  return resMessageText;
}



getattchmentData(int dataId, String activityModel) async {
  String token = await getUserJwt();

  print(dataId);
  print("lead dataaa");

  var data;
  String? authresponce;
  print("${baseUrl}api/attachments?res_model=${activityModel}&res_id=${dataId}");
  print("finallllaaa");
  Response response = await get(



    Uri.parse("${baseUrl}api/attachments?res_model=${activityModel}&res_id=${dataId}"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data.length);
  print(data);
  print("datapasssssssdemoooo111");

  return data;
}


 singleQuatationOpprtunity(int opportunity_id) async {
  String token = await getUserJwt();
  int quotationId=0;
  print(token);

  try {

    final response = await get(Uri.parse(

        "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=10&page_no=1&key_word=&opportunity_id=${opportunity_id}"),

      headers: {

        'Authorization': 'Bearer $token',

      },
    );

    var responseList = jsonDecode(response.body);

     quotationId = responseList['records'][0]["id"];
     print(quotationId);
    print(responseList['records']);



    print("company_ids");



  } catch (e) {
    print("error --> $e");

  }
  return quotationId;
}


// save as new template for send msg


 newTemplateCreate(String lognotes,logmodel,subject ,int resId) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  print(resId);
  print("laakkkkk");
  try {
    final msg = jsonEncode({
      "params": {

          "body": lognotes,
          "model": logmodel,
          "subject": subject,
          "res_id": resId


        // "attachments": myData2,

      }

    });

    Response response = await post(
      Uri.parse('${baseUrl}api/message_template'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}


 templateSelectionData(int dropdownId,int resId,String model) async {
  String token = await getUserJwt();
  var responseList;
  print(token);


  print( "${baseUrl}api/message_template/${27}?model=${model}&res_id=${resId}");
  try {

    final response = await get(Uri.parse(

        "${baseUrl}api/message_template/${dropdownId}?model=${model}&res_id=${resId}"),

      headers: {

        'Authorization': 'Bearer $token',

      },
    );

     responseList = jsonDecode(response.body);

    print(responseList);
    print("responseList");





  } catch (e) {
    print("error --> $e");

  }
  return responseList;
}





// save as new template for send msg

// send msg create
 sendMessageCreate(String lognotes,logmodel,subject ,int resId,partnerId,templateId,List myData1) async {
  String token = await getUserJwt();
  String? resMessage;
  var resMessageText;

  print(partnerId);
  print("laakkkkk");
  try {
    final msg = jsonEncode({
      "params": {
        "body": lognotes,
        "model": logmodel,
        "subject": subject,
        "res_id": resId,
        "partner_ids":partnerId,
        "template_id":templateId,


         "attachment_ids": myData1,

      }

    });

    Response response = await post(
      Uri.parse('${baseUrl}api/send_message'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = data['result'];
      }

      if (resMessage == "error") {
        resMessageText = "failed";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}

// send msg create


// send text message

smsDataGet(int resId,String resmodel) async {
  String token = await getUserJwt();
  var responseList;
  print(token);


  print( "${baseUrl}/api/sms?res_model=${resmodel}&res_id=${resId}");
  try {

    final response = await get(Uri.parse(

        "${baseUrl}api/sms?res_model=${resmodel}&res_id=${resId}"),

      headers: {

        'Authorization': 'Bearer $token',

      },
    );

    responseList = jsonDecode(response.body);

    print(responseList);
    print("responseList");





  } catch (e) {
    print("error --> $e");

  }
  return responseList;
}

sendSms(String message,var mobileNumber,int smsId,String numberType) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  final msg;
  print("laakkkkk");
  try {

    numberType == "phone" ?
     msg = jsonEncode({
      "params": {
        "number_field_name":"phone",
        "recipient_single_number_itf":mobileNumber,
        "body":message
      }

    }):
     msg = jsonEncode({
       "params": {
         "recipient_single_number_itf":mobileNumber,
         "body":message
       }

     });

    Response response = await post(
      Uri.parse('${baseUrl}api/sms/${smsId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    print("final messages");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = "success";
      }

      if (resMessage == "error") {
        resMessageText = "failed";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}


followerDefaultDataGet(int resId,String resmodel) async {
  String token = await getUserJwt();
  var responseList;
  print(token);


  print( "${baseUrl}api/follower?res_model=${resmodel}&res_id=${resId}");
  try {

    final response = await get(Uri.parse(

        "${baseUrl}api/follower?res_model=${resmodel}&res_id=${resId}"),

      headers: {

        'Authorization': 'Bearer $token',

      },
    );

    responseList = jsonDecode(response.body);

    print(responseList);
    print("responseList");





  } catch (e) {
    print("error --> $e");

  }
  return responseList;
}

getFollowers(int resId,String resmodel) async {
  String token = await getUserJwt();
  var responseList;
  print(token);


  print( "${baseUrl}api/follower?res_model=${resmodel}&res_id=${resId}");
  try {

    final response = await get(Uri.parse(

        "${baseUrl}api/followers?res_model=${resmodel}&res_id=${resId}"),


      headers: {

        'Authorization': 'Bearer $token',

      },
    );

    responseList = jsonDecode(response.body);

    print(responseList);
    print("responseList");





  } catch (e) {
    print("error --> $e");

  }
  return responseList;
}


followerSubscription(int followerId) async {
  String token = await getUserJwt();
  var responseList;
  print(token);


  print( "${baseUrl}api/follower/${followerId}");
  try {

    final response = await get(Uri.parse(

        "${baseUrl}api/follower/${followerId}"),


      headers: {

        'Authorization': 'Bearer $token',

      },
    );

    responseList = jsonDecode(response.body);

    print(responseList);
    print("responseList");





  } catch (e) {
    print("error --> $e");

  }
  return responseList;
}




followerSubscriptionAdding(int followerId,List selectedIds) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;


  try {
    final msg = jsonEncode({

      "params": {

        "subtype_ids": selectedIds

      }

    }


    );

    Response response = await put(
      Uri.parse('${baseUrl}api/follower/${followerId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = "success";
      }

      if (resMessage == "error") {
        resMessageText = "error";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}



unFollowing(int resId,follower_id,String res_model) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;


  try {
    final msg = jsonEncode({

      "params": {
        "res_model": res_model,
        "res_id": resId,
        "follower_id": follower_id

      }

    }


    );

    Response response = await put(
      Uri.parse('${baseUrl}api/unfollow'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = "success";
      }

      if (resMessage == "error") {
        resMessageText = "error";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}


followerUnFollow(int resId,String res_model) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;


  try {
    final msg = jsonEncode({

      "params": {
        "res_model": res_model,
        "res_id": resId,

      }

    }

    );

    Response response = await put(
      Uri.parse('${baseUrl}api/unfollow'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = "success";
      }

      if (resMessage == "error") {
        resMessageText = "error";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}

followerFollow(int resId,String res_model) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;


  try {
    final msg = jsonEncode({

      "params": {
        "res_model": res_model,
        "res_id": resId,

      }

    }

    );

    Response response = await put(
      Uri.parse('${baseUrl}api/follow'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = "success";
      }

      if (resMessage == "error") {
        resMessageText = "error";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}



followerCreate(String message,int wizardId ,recepient,bool send_mail) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;


  try {
    final msg = jsonEncode({

      "params": {

        "send_mail":send_mail,
        "partner_ids": recepient ,
        "message":message

      }

    }
    );

    Response response = await post(
      Uri.parse('${baseUrl}api/follower/${wizardId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      resMessage = data['result']['message'];
      print(resMessage);
      if (data['result']['message'].toString() == "success") {
        resMessageText = "success";
      }

      if (resMessage == "error") {
        resMessageText = "error";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }
  print(resMessageText);
  return resMessageText;
}



getNotificationActivity() async {
  String token = await getUserJwt();

  var data;
  String? authresponce;

 Response response = await get(
    Uri.parse("${baseUrl}api/activity_notification"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}




getNotificationMessageActivity() async {
  String token = await getUserJwt();

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/conversations?type=chat"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print("data");

  return data;
}


getNotificationCount() async {
  String token = await getUserJwt();

  var data;
  String? authresponce;

  Response response = await get(
    Uri.parse("${baseUrl}api/notification_count"),
    headers: {
      'Authorization': 'Bearer $token',
    },
  ).timeout(const Duration(
    seconds: 10,
  ));

  if (response.statusCode != 200) {
    throw Exception("failed to get data from internet");
  } else {
    data = jsonDecode(response.body);

    // authresponce = data['result'].toString();
  }

  print(data);
  print(data['activity_count']);
  print("datajfhejbfjbj");

  return data;
}


EmojiReaction(String reaction,int logId) async {
  String token = await getUserJwt();
  String? resMessage, resMessageText;

  print(logId);
  print("asjfbvjsbf");

  try {
    final msg = jsonEncode({
      "params": {
          "reaction":reaction
      }

    });

    Response response = await put(
      Uri.parse('${baseUrl}api/log/${logId}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: msg,
    );

    print(msg);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print("finalstringdataaa");
      resMessage = data['result']['message'];
      print(resMessage);
      print("leadeditresponce");

      if (data['result']['message'].toString() == "success") {
        print("121212121212");
        resMessageText = data['result']['data']['id'].toString();
      }

      if (resMessage == "error") {
        resMessageText = "0";
      }
    } else {}
  } catch (e) {
    print(e.toString());
  }

  print(resMessageText);
  print("dataaaa");
  return resMessageText;
}
//
// deleteEmojiReaction(String reaction,int logId) async {
//   String token = await getUserJwt();
//   String? resMessage, resMessageText;
//
//   print(logId);
//   print("asjfbvjsbf");
//
//   try {
//     final msg = jsonEncode({
//       "params": {
//         "reaction":"🤩"
//       }
//
//     });
//
//     Response response = await delete(
//       Uri.parse('${baseUrl}api/reaction/${logId}'),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer $token',
//       },
//       body: msg,
//     );
//
//     print(msg);
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       print(data);
//       print("finalstringdataaa");
//       resMessage = data['result']['message'];
//       print(resMessage);
//       print("leadeditresponce");
//
//       if (data['result']['message'].toString() == "success") {
//         print("121212121212");
//         resMessageText = data['result']['data']['id'].toString();
//       }
//
//       if (resMessage == "error") {
//         resMessageText = "0";
//       }
//     } else {}
//   } catch (e) {
//     print(e.toString());
//   }
//
//   print(resMessageText);
//   print("dataaaa");
//   return resMessageText;
// }


addMultiCmpnySF(String jsonListmultiCompany) async {
  String jsonListmultiCompanys;

  jsonListmultiCompanys = jsonListmultiCompany;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('multiCompany', jsonListmultiCompanys);
  print("datapass10");
}

getUserJwt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('personJwt');
  return stringValue;
}

getUserCompanyData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('multiCompany');
  return stringValue;
}

Future<List<multiCompany>> getListFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('myListKey');
  if (jsonString != null) {
    final jsonList = json.decode(jsonString);
    return List<multiCompany>.from(
        jsonList.map((item) => multiCompany.fromJson(item)));
  } else {
    return [];
  }
}





