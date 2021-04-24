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

`POST /branches/login`

**Argument**

- `"email": string` email of the branch's account
- `"password": string` password that corresponding to the email and the account

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

- `401 Unauthorized` wrong email or password are given

```json
{
  "message": "Invalid email or password",
  "data": null
}
```

## CaSS Customer

### Add a new customer

**Request**

`POST /customers`

**Argument**

- `"name": string` name of the customer
- `"phone_no": string` phone number of the customer
- `"email": string` email of the customer for mobile app
- `"password": string` password of the customer for mobile app
- `"is_app_user": bool` whether the customer is using mobile app or not
- `"date_created": string` created date of the customer account

**Response**

- `200 OK` on success

```json
{
  "message": "Customer ${name} created successful",
  "data": null
}
```

- `409 Conflict` duplicated phone number or email are provided

```json
{
  "message": "${key} ${entry} already exist",
  "data": null
}
```

### Get all customers

**Request**

`GET /customers`

**Response**

- `200 OK` on success

```json
{
  "message": "2 total",
  "data": [
    {
      "customer_id": 1,
      "name": "Tiang King Jeck",
      "phone_no": "0138042421",
      "email": "jeck9797@gmail.com",
      "is_app_user": true,
      "date_created": "2021-04-24"
    },
    {
      "customer_id": 2,
      "name": "Lee Jong Feng",
      "phone_no": "0123456789",
      "email": null,
      "is_app_user": false,
      "date_created": "2021-04-25"
    }
  ]
}
```

### Update a customer

**Request**

`PUT /customers/<customer_id>`

**Response**

- `200 OK` on success

```json
{
  "message": "Customer ${customer_id} had been updated",
  "data": null
}
```

- `404 Not Found` customer ID does not found

```json
{
  "message": "Customer ${customer_id} does not found",
  "data": null
}
```

- `409 Conflict` duplicated data are provided

```json
{
  "message": "${key} ${entry} already exist",
  "data": null
}
```

### Update password of a customer

**Request**

`PATCH /customers/<customer_id>`

**Response**

- `200 OK` on success

```json
{
  "message": "Password of customer ${customer_id} had been updated",
  "data": null
}
```

- `404 Not Found` customer ID does not found

```json
{
  "message": "Customer ${customer_id} does not found",
  "data": null
}
```

- `409 Conflict` Same password is provided

```json
{
  "message": "New password cannot be same with the old password",
  "data": null
}
```

## CaSS Manager
