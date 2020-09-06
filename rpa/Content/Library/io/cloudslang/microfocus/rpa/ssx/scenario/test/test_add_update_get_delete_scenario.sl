namespace: io.cloudslang.microfocus.rpa.ssx.scenario.test
flow:
  name: test_add_update_get_delete_scenario
  inputs:
    - category_name: SALESFORCE
    - scenario_json: "${'''{\n   \"name\":\"CREATE USERS FROM EXCEL4\",\n   \"description\":\"Creates up to 1000 SAP users from given excel sheet. The sheet must have a header where each property is written in one column. Name (containing the first name and the last name) is in a single column; the names must be delimited by a white space character.\",\n   \"flowVo\":{\n      \"flowPath\":\"Library/SAP/user/bulk/create_users_from_excel.sl\",\n      \"flowUuid\":\"SAP.user.bulk.create_users_from_excel\",\n      \"timeoutValue\":0\n   },\n   \"inputs\":[\n      {\n         \"defaultValue\":\"C:\\\\\\\\Enablement\\\\\\\\HotLabs\\\\\\\\SAP\\\\\\\\Emails_Accounts.xlsx\",\n         \"label\":\"excel_file\",\n         \"originalName\":\"excel_file\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"Environment\",\n         \"label\":\"worksheet_name\",\n         \"originalName\":\"worksheet_name\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"SAP User\",\n         \"label\":\"username_header\",\n         \"originalName\":\"username_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"SAP Password\",\n         \"label\":\"password_header\",\n         \"originalName\":\"password_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"Name\",\n         \"label\":\"name_header\",\n         \"originalName\":\"name_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"E-mail\",\n         \"label\":\"email_header\",\n         \"originalName\":\"email_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"true\",\n         \"label\":\"set_admin\",\n         \"originalName\":\"set_admin\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      }\n   ],\n   \"outputs\":[\n\n   ],\n   \"roles\":[\n      \"ADMINISTRATOR\",\n      \"PROMOTER\"\n   ]\n}'''}"
    - scenario_old_name: CREATE USERS FROM EXCEL4
    - scenario_new_name: CREATE USERS FROM EXCEL5
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_category
    - add_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.add_scenario:
            - token: '${token}'
            - category_id: '${category_id}'
            - scenario_json: '${scenario_json}'
        publish:
          - scenario_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_scenario_again
    - get_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.get_category:
            - token: '${token}'
            - category_name: '${category_name}'
        publish:
          - category_json
          - category_id: "${'' if category_json is None else str(eval(category_json.replace(':null',':None')).get('id'))}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_scenario
    - add_scenario_again:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.add_scenario:
            - token: '${token}'
            - category_id: '${category_id}'
            - scenario_json: '${scenario_json}'
        navigate:
          - FAILURE: update_scenario
          - SUCCESS: FAILURE
    - update_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.update_scenario:
            - token: '${token}'
            - scenario_id: '${scenario_id}'
            - category_id: '${category_id}'
            - scenario_json: "${scenario_json.replace('CREATE USERS FROM EXCEL4', scenario_new_name)}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_old_scenario
    - get_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.get_scenario:
            - token: '${token}'
            - scenario_name: '${scenario_new_name}'
        publish:
          - scenario_json
          - new_scenario_id: "${str(eval(scenario_json.replace(':null',':None')).get('id'))}"
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${scenario_id}'
            - second_string: '${new_scenario_id}'
        navigate:
          - SUCCESS: delete_scenario
          - FAILURE: on_failure
    - delete_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.delete_scenario:
            - token: '${token}'
            - scenario_id: '${scenario_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_old_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.get_scenario:
            - token: '${token}'
            - scenario_name: '${scenario_old_name}'
        publish:
          - scenario_json
        navigate:
          - SUCCESS: is_empty
          - FAILURE: on_failure
    - is_empty:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(scenario_json) == 0)}'
        navigate:
          - 'TRUE': get_scenario
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_scenario:
        x: 52
        'y': 396
        navigate:
          b6cd0e16-3af0-7fe3-6a22-ee414dbea287:
            targetId: d1230ac0-3a26-69c9-524a-5a9ef32db2a5
            port: SUCCESS
      update_scenario:
        x: 753
        'y': 79
      get_category:
        x: 224
        'y': 72
      string_equals:
        x: 221
        'y': 389
      add_scenario:
        x: 418
        'y': 74
      add_scenario_again:
        x: 582
        'y': 79
        navigate:
          30399a72-0815-9d10-1722-ee464f80be04:
            targetId: ccaa87ce-2c5b-4e5c-9614-bb5ecb4ac420
            port: SUCCESS
      get_token:
        x: 45
        'y': 71
      get_old_scenario:
        x: 754
        'y': 390
      is_empty:
        x: 575
        'y': 394
        navigate:
          8087f7d4-13dc-e730-593c-d667cdec0b43:
            targetId: ccaa87ce-2c5b-4e5c-9614-bb5ecb4ac420
            port: 'FALSE'
      get_scenario:
        x: 423
        'y': 394
    results:
      FAILURE:
        ccaa87ce-2c5b-4e5c-9614-bb5ecb4ac420:
          x: 482
          'y': 243
      SUCCESS:
        d1230ac0-3a26-69c9-524a-5a9ef32db2a5:
          x: 207
          'y': 237
