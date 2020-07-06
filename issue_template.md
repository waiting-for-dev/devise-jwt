Please, for a bug report fill in the following template. Before that, make sure to read the whole [README](https://github.com/waiting-for-dev/devise-jwt/blob/master/README.md) and check if your issue is not related with [CORS](https://github.com/waiting-for-dev/devise-jwt#model-configuration).

Feature requests and questions about `devise-jwt` are also accepted. It isn't the place for generic questions about using `devise` with an API. For that, read our [wiki page](https://github.com/waiting-for-dev/devise-jwt/wiki/Configuring-devise-for-APIs) or ask somewhere else like [stackoverflow](https://stackoverflow.com/)

## Expected behavior

## Actual behavior

## Steps to Reproduce the Problem

1.
2.
3.

## Debugging information

Provide following information. Please, format pasted output as code. Feel free to remove the secret key value.

- Version of `devise-jwt` in use
- Version of `rails` in use
- Version of `warden-jwt_auth` in use
- Output of `Devise::JWT.config`
- Output of `Warden::JWTAuth.config`
- Output of `Devise.mappings`
- If your issue is related with not getting a JWT from the server:
  - Involved request path, method and request headers
  - Response headers for that request
- If your issue is related with not being able to revoke a JWT:
  - Involved request path, method and request headers
