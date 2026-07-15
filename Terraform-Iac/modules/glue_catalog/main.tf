resource "aws_glue_catalog_database" "this" {
  name = var.database_name
  description = var.description

  parameters = {
    project = "brazillian-ecommerce"
    environment = "dev"
    data_zone = "raw"
  }

  tags = var.tags
}

locals {
  raw_tables = {
    customers = {
      s3_prefix = "customers"

      columns = [
        "customer_id",
        "customer_unique_id",
        "customer_zip_code_prefix",
        "customer_city",
        "customer_state"
      ]
    }

    geolocation = {
      s3_prefix = "geolocation"

      columns = [
        "geolocation_zip_code_prefix",
        "geolocation_lat",
        "geolocation_lng",
        "geolocation_city",
        "geolocation_state"
      ]
    }

    order_items = {
      s3_prefix = "order_items"

      columns = [
        "order_id",
        "order_item_id",
        "product_id",
        "seller_id",
        "shipping_limit_date",
        "price",
        "freight_value"
      ]
    }

    order_payments = {
      s3_prefix = "order_payments"

      columns = [
        "order_id",
        "payment_sequential",
        "payment_type",
        "payment_installments",
        "payment_value"
      ]
    }

    order_reviews = {
      s3_prefix = "order_reviews"

      columns = [
        "review_id",
        "order_id",
        "review_score",
        "review_comment_title",
        "review_comment_message",
        "review_creation_date",
        "review_answer_timestamp"
      ]
    }

    orders = {
      s3_prefix = "orders"

      columns = [
        "order_id",
        "customer_id",
        "order_status",
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
      ]
    }

    products = {
      s3_prefix = "products"

      columns = [
        "product_id",
        "product_category_name",
        "product_name_lenght",
        "product_description_lenght",
        "product_photos_qty",
        "product_weight_g",
        "product_length_cm",
        "product_height_cm",
        "product_width_cm"
      ]
    }

    sellers = {
      s3_prefix = "sellers"

      columns = [
        "seller_id",
        "seller_zip_code_prefix",
        "seller_city",
        "seller_state"
      ]
    }

    product_category_translation = {
      s3_prefix = "product_category_translation"

      columns = [
        "product_category_name",
        "product_category_name_english"
      ]
    }
  }
}

resource "aws_glue_catalog_table" "raw_tables" {
  for_each = local.raw_tables

  name = each.key
  database_name = aws_glue_catalog_database.this.name
  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
    classification = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location = "s3://${var.data_lake_bucket_name}/raw/${each.value.s3_prefix}/"

    input_format = "org.apache.hadoop.mapred.TextInputFormat"

    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name = "${each.key}-csv-serde"

      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

      parameters = {
        separatorChar = ","
        quoteChar = "\""
        escapeChar = "\\"
      }
    }
    dynamic "columns" {
      for_each = each.value.columns

      content {
        name = columns.value
        type = "string"
      }
    }
}
}

moved {
  from = aws_glue_catalog_table.customers
  to   = aws_glue_catalog_table.raw_tables["customers"]
}