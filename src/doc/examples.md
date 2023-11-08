---
layout: default
title: "Examples"
nav_order: 9
---

# Examples

## [Restbucks](https://github.com/oxlip-lang/example-restbucks)

The compiled OpenAPI definition is available in [Redoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/oxlip-lang/example-restbucks/main/openapi.yaml).

```oal
/*
 * Example of OAL definition for the Restbucks imaginary coffee shop
 * https://www.infoq.com/articles/webber-rest-workflow/
 */

# title: drink
let drink = str `enum: [espresso, latte]`;

# title: addition to a drink
let addition = str `enum: [shot]`;

# title: status of an order
let orderStatus = str `enum: [created, preparing, ready]`;

# title: credit card number
let cardNo = str `pattern: "^[0-9]{16}$", example: 4470826293333986`;

# title: credit card expiration month and year
let cardExpiration = str `pattern: "^[0-9]{2}/[0-9]{2}$", example: 10/25`;

# title: price
let price = num `example: 4.45`;

# title: drink order
let @order = {
    'drink! drink,
    'additions [addition],
    'cost price,
    'status orderStatus,
};

# title: payment
let @payment = {
    'cardNo! cardNo,
    'expires! cardExpiration,
    'name! str,
    'amount! price,
};

// Resource URIs
let id = 'id int `title: internal identifier`;
let uriOrders = /orders;
let uriOrder = concat uriOrders /{ id };
let uriPayment = /payments/{ id };

// Helper functions for operation results
let created u s = <status=201, headers={ 'Location u }, s> `description: Created`;
let ok u s = <status=200, headers={ 'Location u }, s> `description: OK`;
let conflict u s = <status=409, headers={ 'Location u }, s> `description: Conflict`;

# title: order state representation
let orderState = @order & {
    'payment relPayment,
    'edit relOrder,
};

# title: order relation
let relOrder = uriOrder on
    # description: Update an order
    ( put : { 'order! @order } -> ok relOrder { 'order! orderState }
                               :: conflict relOrder { 'order! orderState } ),
    # description: Delete an order
    ( delete -> <status=200> `description: Deleted` );

# title: orders collection relation
let relOrders = uriOrders on
    # description: Create an order
    ( post : { 'order! @order } -> created relOrder { 'order! orderState } ),
    # description: Retrieve all orders
    ( get -> ok relOrders { 'orders! [orderState] } );

# title: payment relation
let relPayment = uriPayment on
    # description: Make a payment
    ( put : { 'payment! @payment } -> created relPayment { 'payment! @payment } ),
    # description: Retrieve a payment
    ( get -> ok relPayment { 'payment! @payment } );

// All exported relations
res relOrders;
res relOrder;
res relPayment;
```

---

[Next > OAL on Github](https://github.com/oxlip-lang/oal)
