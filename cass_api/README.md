# Car Service System

## Usage

All response will have a form

```json
{
  "message": "Description of what happened",
  "data": "Mixed type holding the content of the response"
}
```

Following JSON definitions will be responsed when general error occurred

- `500 Internal Server Error` if error occurred on database

```json
{
  "message": "Database connection error",
  "data": null
}
```

## CaSS Branch

### Login branch

**Request**

`POST /branch/login`

**Argument**

- `"email": string` an email of the branch's account
- `"password": string` a password that corresponding to the email and the account

**Response**

- `200 OK` on sucess

```json
{
  "message": "Login successful",
  "data": {
    "branch_id": 1,
    "name": "CaSS Jelutong",
    "email": "cassb001@sample.com",
    "location": "Batu Lanchang, 11600 Jelutong, Penang"
  }
}
```

- `401 Unauthorized` if wrong email or password are given

```json
{
  "message": "Invalid email or password",
  "data": null
}
```

## CaSS Customer

## CaSS Manager
