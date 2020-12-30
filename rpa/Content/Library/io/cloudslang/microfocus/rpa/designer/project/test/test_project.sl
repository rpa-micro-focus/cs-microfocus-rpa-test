########################################################################################################################
#!!
#! @description: Run the test and open aosdev workspace in Designer to see if all files are green.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project.test
flow:
  name: test_project
  inputs:
    - ws_user: aosdev
    - folder_path: "c:\\\\temp"
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${ws_user}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_ws_id
    - get_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete
    - download_projects_files:
        do:
          io.cloudslang.microfocus.rpa.designer.project.download_projects_files:
            - ws_id: '${ws_id}'
            - folder_path: '${folder_path}'
        publish:
          - projects_details
        navigate:
          - FAILURE: on_failure
          - SUCCESS: upload_project_files
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${folder_path+"/AOS"}'
        navigate:
          - SUCCESS: download_projects_files
          - FAILURE: download_projects_files
    - upload_project_files:
        do:
          io.cloudslang.microfocus.rpa.designer.project.upload_project_files:
            - token: '${token}'
            - projects_details: '${projects_details}'
            - folder_path: '${folder_path}'
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
        x: 52
        'y': 91
      get_ws_id:
        x: 163
        'y': 234
      download_projects_files:
        x: 441
        'y': 235
      delete:
        x: 305
        'y': 93
      upload_project_files:
        x: 581
        'y': 85
        navigate:
          32d5bae3-3487-bf3e-0b21-7e07dcda0c23:
            targetId: 7a0b31c9-c71f-23b1-6a8a-24f5d52c19be
            port: SUCCESS
    results:
      SUCCESS:
        7a0b31c9-c71f-23b1-6a8a-24f5d52c19be:
          x: 737
          'y': 241
