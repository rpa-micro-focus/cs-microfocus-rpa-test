namespace: io.cloudslang.microfocus.oo.central.execution.test
flow:
  name: test_download_cps
  inputs:
    - cp_folder: "c:\\Temp"
  workflow:
    - get_temp_file:
        do:
          io.cloudslang.base.filesystem.temp.get_temp_file:
            - file_name: test
        publish:
          - folder_path
        navigate:
          - SUCCESS: download_cps
    - download_cps:
        do:
          io.cloudslang.microfocus.oo.central.content-pack.download_cps:
            - cps_folder: '${folder_path}'
        publish:
          - failed_cps
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_temp_file:
        x: 76
        'y': 82
      download_cps:
        x: 264
        'y': 73
        navigate:
          3c7df7d5-e5f3-7da8-be5c-f6d9ec7b257b:
            targetId: d2c6202e-6b3e-1b5f-f1a0-1be53b1c01c8
            port: SUCCESS
    results:
      SUCCESS:
        d2c6202e-6b3e-1b5f-f1a0-1be53b1c01c8:
          x: 454
          'y': 72
