########################################################################################################################
#!!
#! @description: Tests create / delete elements (project files and folders).
#!
#! @input folder_id: Under which folder the test folder/files will be created
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.project.test
flow:
  name: test_create_delete_element
  inputs:
    - ws_user: admin
    - folder_id: '159477'
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.oo.designer.authenticate.get_token:
            - ws_user: '${ws_user}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_folder
    - create_folder:
        do:
          io.cloudslang.microfocus.oo.designer.project.create_element:
            - token: '${token}'
            - element_name: test_folder
            - element_type: FOLDER
            - folder_id: '${folder_id}'
        publish:
          - root_folder_id: '${element_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_flow
    - create_flow:
        do:
          io.cloudslang.microfocus.oo.designer.project.create_element:
            - token: '${token}'
            - element_name: test_flow
            - element_type: FLOW
            - folder_id: '${root_folder_id}'
            - file_content: "namespace: io\\nflow:\\n  name: test_flow\\n  results: []\\n"
        publish:
          - flow_id: '${element_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_operation
    - create_operation:
        do:
          io.cloudslang.microfocus.oo.designer.project.create_element:
            - token: '${token}'
            - element_name: test_op
            - element_type: PYTHON_OPERATION
            - folder_id: '${root_folder_id}'
            - file_content: "namespace: io\\noperation:\\n  name: test_op\\n  python_action:\\n    use_jython: false\\n    script: \\\"# do not remove the execute function \\\\ndef execute(): \\\\n    # code goes here\\\\n# you can add additional helper methods below.\\\"\\n  results:\\n    - SUCCESS\\n"
        publish:
          - operation_id: '${element_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_folder
    - delete_folder:
        do:
          io.cloudslang.microfocus.oo.designer.project.delete_element:
            - token: '${token}'
            - element_id: '${root_folder_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 77
        'y': 99
      create_folder:
        x: 250
        'y': 106
      create_flow:
        x: 88
        'y': 243
      create_operation:
        x: 256
        'y': 241
      delete_folder:
        x: 432
        'y': 119
        navigate:
          108d30bc-20a7-cc0e-e8db-ac73af8e9a4b:
            targetId: b166b707-4b94-1042-939a-2a6c24fc2405
            port: SUCCESS
    results:
      SUCCESS:
        b166b707-4b94-1042-939a-2a6c24fc2405:
          x: 435
          'y': 274
