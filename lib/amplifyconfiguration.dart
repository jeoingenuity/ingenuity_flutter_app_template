// ignore_for_file: leading_newlines_in_multiline_strings, eol_at_end_of_file

const amplifyconfig = '''{
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/2.0",
        "Version": "1.0",
        "CognitoUserPool": {
          "Default": {
            "PoolId": "ap-southeast-1_WpBqThawk",
            "AppClientId": "1pcvktbhbe24dbm447c9388vii",
            "Region": "ap-southeast-1"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    }
  }
}''';