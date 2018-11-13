```json
{
  "tickets": [
    {
      "_type": "ticket",
      "id": 3068931,
      "slug": "ti_dhlR2CSzh59ZLht5ELPkxjg",
      "company_name": "",
      "email": "john@example.com",
      "metadata": null,
      "first_name": "John",
      "last_name": "Smith",
      "name": "John Smith",
      "number": null,
      "phone_number": "",
      "price": "0.0",
      "reference": "ZBRE-1",
      "state": "complete",
      "test_mode": true,
      "registration_id": 3509397,
      "release_id": 1105525,
      "consented_at": null,
      "discount_code_used": null,
      "created_at": "2018-11-12T13:35:44.000+00:00",
      "updated_at": "2018-11-12T13:35:44.000+00:00",
      "responses": null,
      "assigned": true,
      "price_less_tax": "0.0",
      "total_paid": "0.0",
      "total_tax_paid": "0.0",
      "total_paid_less_tax": "0.0",
      "tags": null,
      "upgrade_ids": [],
      "upgrade_summary": {},
      "registration_slug": "reg_test_ds7qNqJ4s4doDMeh1VogTrw",
      "release_slug": "coffee-brewing",
      "release_title": "Coffee Brewing",
      "registration": {
        ...
      },
      "release": {
        ...
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "next_page": null,
    "prev_page": null,
    "total_pages": 1,
    "total_count": 1,
    "per_page": 100,
    "overall_total": 1,
    "resources_hidden_by_default_count": 0,
    "search_states_hidden_by_default": [
      "void"
    ],
    "sort_options": {
      "First name A-Z": {
        "attr": "first_name",
        "direction": "asc"
      },
      "First name Z-A": {
        "attr": "first_name",
        "direction": "desc"
      },
      "Last name A-Z": {
        "attr": "last_name",
        "direction": "asc"
      },
      "Last name Z-A": {
        "attr": "last_name",
        "direction": "desc"
      },
      "Ticket date, earliest first": {
        "attr": "tickets.created_at",
        "direction": "asc"
      },
      "Ticket date, newest first": {
        "attr": "tickets.created_at",
        "direction": "desc",
        "default": true
      },
      "Price, least first": {
        "attr": "price",
        "direction": "asc"
      },
      "Price, most first": {
        "attr": "price",
        "direction": "desc"
      },
      "Reference": {
        "attr": "reference",
        "direction": "asc"
      },
      "Number": {
        "attr": "number",
        "direction": "asc"
      }
    },
    "filter_options": {
      "types": [
        {
          "label": "Added manually",
          "value": "manual"
        },
        {
          "label": "Ordered by customer",
          "value": "standard"
        }
      ],
      "release_ids": [
        {
          "label": "Coffee Brewing",
          "value": "coffee-brewing"
        },
        {
          "label": "Tea Brewing",
          "value": "tea-brewing"
        }
      ],
      "activity_ids": [
        {
          "label": "Blah",
          "value": "1019160"
        },
        {
          "label": "Blah Copy",
          "value": "1019161"
        }
      ],
      "upgrade_ids": [],
      "sections": {
        "states": {
          "label": "Status",
          "open": false
        },
        "types": {
          "label": "Type",
          "open": false
        },
        "release_ids": {
          "label": "Tickets",
          "open": false
        },
        "activity_ids": {
          "label": "Activities",
          "open": false
        },
        "upgrade_ids": {
          "label": "Upgrades",
          "open": false
        }
      },
      "collection": false,
      "states": [
        {
          "label": "Complete",
          "value": "complete"
        },
        {
          "label": "Incomplete",
          "value": "incomplete"
        },
        {
          "label": "Unassigned",
          "value": "unassigned"
        },
        {
          "label": "Void",
          "value": "void"
        },
        {
          "label": "Changes Locked",
          "value": "changes_locked"
        },
        {
          "label": "Changes Allowed",
          "value": "changes_allowed"
        }
      ],
      "selected_states": [
        "complete",
        "incomplete",
        "unassigned",
        "changes_locked",
        "changes_allowed"
      ]
    }
  }
}
```
