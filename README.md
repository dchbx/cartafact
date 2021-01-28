# What Cartafact is -

This is a micro service that you can use to store/retreive/search documents.

## Headers

###### Parameters:

**X-RequestingIdentity -

This is the requesting identity JSON, Base64 encoded.

**JSON structure -

```
  {
    authorized_identity: {
      user_id: "string",
      system: "string"
    },
    authorized_subjects: [{
      type: "string",
      id: "string"
    }]
  }
```

**X-RequestingIdentitySignature -

Signature of the requesting identity information. To calculate this, take the X-RequestingIdentity header, HMAC-SHA256 it using the secret corresponding to your application, and then Base64 encode the result.

**Payload

```
payload = {
  authorized_identity: {
    user_id: "string",
    system: "string"
  },
  authorized_subjects: [{
    type: "string",
    id: "string"
  }]
}

encoded_identity = Base64.strict_encode64(payload.to_json)

headers: {
  'HTTP-X-REQUESTINGIDENTITY' => encoded_identity,
  'HTTP-X-REQUESTINGIDENTITYSIGNATURE' => Base64.strict_encode64(OpenSSL::HMAC.digest("SHA256", your application secret key, encoded_identity))
}
```

## Store a new document:

Request - POST /api​/v1​/documents


```
body: {
  document: {
    subjects: [{
      id: string,
      type: string
    }],                                    # Required.
    document_type: string,                 # Required.
    content: 'uploaded file content here', # Required.
    creator: string,                       # Required.
    publisher: string,                     # Required.
    type: string,                          # Required.
    format: string,                        # Required.
    source: string,                        # Required.
    language: string,                      # Required.
    date_submitted: date,                  # Required.
    title: string,                         # Optional.
    identifier: string,                    # Optional.
    description: string,                   # Optional.
    contributor: string,                   # Optional.
    created: date,                         # Optional.
    date_accepted: date,                   # Optional.
    expire: date,                          # Optional.
    relation: string,                      # Optional.
    coverage: string,                      # Optional.
    tags: string,                          # Optional.
    rights: string,                        # Optional.
    access_rights: string,                 # Optional.
    extent: string,                        # Optional.
    file_data: string,                     # Optional.
  }.to_json,
}
```

Response - 

```
{
  title: "untitled",
  creator: "dchl",
  identifier: "xyz",
  description: "xyz",
  language: "en",
  format: "application/octet-stream",
  source: "enroll_system",
  date: nil,
  document_type: "notice",
  subjects: [{id: "abc", type: "Person"}],
  version: nil,
  id: "document Id reference from cartafact",
  extension: "pdf",
  size: 1503191,
  mime_type: "application/pdf"
}

```
## Download document:

GET /api​/v1​/documents/:id/download

###### Parameters:

```
id: string # Required.

```

## Delete a document:

DELETE /api/v1/documents/:id


```
id: 'id string'  # required
  
```



## Update a document:

Request - PUT /api/v1/documents/:id


```
body: {
  document: {
    subjects: [{
      id: string,
      type: string
    }],
    document_type: string
  }.to_json,
  content: 'uploaded file content here', # Required.
  creator: string,                       # Required.
  publisher: string,                     # Required.
  type: string,                          # Required.
  format: string,                        # Required.
  source: string,                        # Required.
  language: string,                      # Required.
  date_submitted: date,                  # Required.
  title: string,                         # Optional.
  identifier: string,                    # Optional.
  description: string,                   # Optional.
  contributor: string,                   # Optional.
  created: date,                         # Optional.
  date_accepted: date,                   # Optional.
  expire: date,                          # Optional.
  relation: string,                      # Optional.
  coverage: string,                      # Optional.
  tags: string,                          # Optional.
  rights: string,                        # Optional.
  access_rights: string,                 # Optional.
  extent: string,                        # Optional.
  file_data: string,                     # Optional.
}
```

Response - 

```
{
  title: "untitled",
  creator: "dchl",
  identifier: "xyz",
  description: "xyz",
  language: "en",
  format: "application/octet-stream",
  source: "enroll_system",
  date: nil,
  document_type: "notice",
  subjects: [{id: "abc", type: "Person"}],
  version: nil,
  id: "document Id reference from cartafact",
  extension: "pdf",
  size: 1503191,
  mime_type: "application/pdf"
}

```


